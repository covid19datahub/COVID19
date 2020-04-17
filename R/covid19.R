#'
#' Coronavirus COVID-19 (2019-nCoV) Epidemic Datasets
#'
#' Unified tidy format datasets of the 2019 Novel Coronavirus COVID-19 (2019-nCoV) epidemic across several sources.
#' The data are downloaded in real-time, cleaned and matched with exogenous variables.
#'
#' @param ISO vector of ISO codes to retrieve (alpha-2, alpha-3 or numeric). Each country is identified by one of its \href{https://github.com/emanuele-guidotti/COVID19/blob/master/inst/extdata/db/ISO.csv}{ISO codes}
#' @param level integer. Granularity level. 1: country-level data. 2: state-level data. 3: city-level data.
#' @param start the start date of the period of interest.
#' @param end the end date of the period of interest.
#' @param vintage logical. Retrieve the snapshot of the dataset at the \code{end} date instead of using the latest version? Default \code{FALSE}.
#' @param raw logical. Skip data cleaning? Default \code{FALSE}. See details.
#' @param cache logical. Memory caching? Significantly improves performance on successive calls. Default \code{TRUE}.
#'
#' @details \href{https://github.com/emanuele-guidotti/COVID19}{Collection methodology and details}
#'
#' @return \href{https://github.com/emanuele-guidotti/COVID19#dataset}{Grouped \code{tibble} (\code{data.frame})}
#'
#' @examples
#' \dontrun{
#'
#' # Worldwide data by country
#' covid19()
#'
#' # Worldwide data by state
#' covid19(level = 2)
#'
#' # US data by state
#' covid19("USA", level = 2)
#'
#' # Swiss data by state (cantons)
#' covid19("CHE", level = 2)
#'
#' # Italian data by state (regions)
#' covid19("ITA", level = 2)
#'
#' # Italian and US data by city
#' covid19(c("ITA","USA"), level = 3)
#' }
#'
#' @source \href{https://github.com/emanuele-guidotti/COVID19#data-sources}{Data sources}
#'
#' @export
#'
covid19 <- function(ISO     = NULL,
                    level   = 1,
                    start   = "2019-01-01",
                    end     = Sys.Date(),
                    vintage = FALSE,
                    raw     = FALSE,
                    cache   = TRUE){

  # fallback
  if(!(level %in% 1:3))
    stop("valid options for 'level' are:
         1: country-level data
         2: state-level data
         3: city-level data")

  # cache
  cachekey <- make.names(sprintf("covid19_%s_%s_%s_%s",paste0(ISO, collapse = "."), level, ifelse(vintage, end, 0), raw))
  if(cache & exists(cachekey, envir = cachedata))
    return(get(cachekey, envir = cachedata) %>% dplyr::filter(date >= start & date <= end))

  # bindings
  iso_alpha_3 <- id <- date <- country <- state <- city <- confirmed <- tests <- deaths <- recovered <- hosp <- icu <- vent <- driving <- walking <- transit <- NULL

  # data
  x <- data.frame()

  # ISO code
  iso <- db("ISO")
  if(is.null(ISO))
    ISO <- iso$iso_alpha_3

  ISO <- toupper(ISO)
  ISO <- sapply(ISO, function(i) iso$iso_alpha_3[which(iso$iso_alpha_2==i | iso$iso_alpha_3==i | iso$iso_numeric==i)])
  ISO <- as.character(unique(ISO))
  if(length(ISO)==0)
    return(NULL)

  # vintage
  if(vintage){

    if(end < "2020-04-14")
      stop("vintage data not available before 2020-04-14")

    file <- sprintf("https://storage.guidotti.dev/covid19/%sdata-%s-%s.csv", ifelse(raw, 'raw', ''), level, format(as.Date(end),"%Y%m%d"))

    x <- try(suppressWarnings(read.csv(file, cache = cache, colClasses = c("date" = "Date"))), silent = TRUE)

    if(class(x)=="try-error" | is.null(x))
      stop(sprintf("vintage data not available on %s", end))

    if(length(ISO)>0)
      x <- x %>%
        dplyr::filter(sapply(strsplit(x$id,", "), function(x) x[[1]]) %in% ISO)

    if(nrow(x)==0)
      return(NULL)

  }
  else {

    # download
    for(fun in ISO){

      y <- cachecall(fun, level = level, cache = cache)

      if(!is.null(y))
        x <- y %>%
          dplyr::mutate(iso_alpha_3 = fun) %>%
          dplyr::bind_rows(x)

    }

    if(length(ISO)!=length(unique(x$iso_alpha_3)))
      if(!is.null(w <- cachecall("WORLD", level = level, cache = cache)))
        x <- w %>%
          dplyr::filter(!(iso_alpha_3 %in% x$iso_alpha_3) & iso_alpha_3 %in% ISO) %>%
          dplyr::bind_rows(x)

    # fallback
    if(nrow(x)==0)
      return(NULL)

    # subset
    key <- c('iso_alpha_3','id','date',vars('fast'))
    x[,key[!(key %in% colnames(x))]] <- NA
    x <- x[,key]

    # check dates
    if(any(is.na(x$date)))
      stop("column 'date' contains NA values")

    # clean
    dates  <- seq(min(x$date), max(x$date), by = 1)
    if(!raw)
      x <- x %>%

        dplyr::group_by(iso_alpha_3, id) %>%

        dplyr::group_map(keep = TRUE, function(x, ...){

          miss <- dates[!(dates %in% x$date)]

          if(length(miss)>0)
            x <- x %>%
              dplyr::bind_rows(data.frame(date = miss)) %>%
              tidyr::fill(iso_alpha_3, id, .direction = "downup")

          return(x)

        }) %>%

        dplyr::bind_rows() %>%

        dplyr::group_by(iso_alpha_3, id) %>%

        dplyr::arrange(date) %>%

        tidyr::fill(vars("fast"), .direction = "down") %>%

        tidyr::replace_na(as.list(sapply(vars("fast"), function(x) 0)))

    # group by country
    if(level==1)
      x$id <- NA

    # aggregate
    x <- x %>%

      dplyr::group_by(iso_alpha_3, id, date) %>%

      dplyr::summarize(confirmed = sum(confirmed),
                       deaths    = sum(deaths),
                       tests     = sum(tests),
                       recovered = sum(recovered),
                       hosp      = sum(hosp),
                       icu       = sum(icu),
                       vent      = sum(vent),
                       driving   = mean(driving),
                       walking   = mean(walking),
                       transit   = mean(transit))

    # merge top level slow var
    x <- merge(x, db("ISO"), by = "iso_alpha_3", all.x = TRUE, suffixes = c('.drop',''))

    # merge slow var
    if(level>1)
      x <- x %>%

        dplyr::group_by(iso_alpha_3) %>%

        dplyr::group_map(keep = TRUE, function(x, iso){

          drop(merge(x, db(iso[[1]]), by = "id", all.x = TRUE, suffixes = c('.drop','')))

        }) %>%

        dplyr::bind_rows()

    # unique id
    x$id <- id(x$iso_alpha_3, x$id, esc = FALSE)

    # subset
    col <- vars()
    x[,col[!(col %in% colnames(x))]] <- NA
    x <- x[,col]

  }

  # group and order
  x <- x %>%
    dplyr::group_by(id) %>%
    dplyr::arrange(id, date)

  # warning
  if(any(duplicated(x[,c('date','country','state','city')])))
    warning("the tuple ('date','country','state','city') is not unique")

  # cache
  if(cache)
    assign(cachekey, x, envir = cachedata)

  # return
  return(x %>% dplyr::filter(date >= start & date <= end))

}
