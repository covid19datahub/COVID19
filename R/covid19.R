#'
#' Coronavirus COVID-19 (2019-nCoV) Epidemic Datasets
#'
#' Unified tidy format datasets of the 2019 Novel Coronavirus COVID-19 (2019-nCoV) epidemic across several sources.
#' The data are downloaded in real-time, cleaned and matched with exogenous variables.
#' Vintage databases are also supported.
#'
#' @param ISO vector of ISO codes to retrieve (alpha-2, alpha-3 or numeric). Each country is identified by one of its \href{https://github.com/covid19datahub/COVID19/blob/master/inst/extdata/db/ISO.csv}{ISO codes}
#' @param level integer. Granularity level. 1: country-level data. 2: state-level data. 3: city-level data.
#' @param start the start date of the period of interest.
#' @param end the end date of the period of interest.
#' @param vintage logical. Retrieve the snapshot of the dataset at the \code{end} date instead of using the latest version? Default \code{FALSE}.
#' @param raw logical. Skip data cleaning? Default \code{FALSE}. See details.
#' @param cache logical. Memory caching? Significantly improves performance on successive calls. Default \code{TRUE}.
#'
#' @details \href{https://github.com/covid19datahub/COVID19}{Collection methodology and details}
#'
#' @return \href{https://github.com/covid19datahub/COVID19#dataset}{Grouped \code{tibble} (\code{data.frame})}
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
#' @source \href{https://github.com/covid19datahub/COVID19#data-sources}{Data sources}
#'
#' @references 
#' Guidotti, E., Ardia, D., (2020), "COVID-19 Data Hub", Working paper, \doi{10.13140/RG.2.2.11649.81763}.
#'
#' @note 
#' We have invested a lot of time and effort in creating \href{https://covid19datahub.io}{COVID-19 Data Hub}. We expect you to agree to the following rules when using it:
#' 
#' \itemize{
#' \item cite Guidotti and Ardia (2020) in working papers and published papers that use \href{https://covid19datahub.io}{COVID-19 Data Hub}
#' \item place the URL \url{https://covid19datahub.io} in a footnote to help others find \href{https://covid19datahub.io}{COVID-19 Data Hub}
#' \item you assume full risk for the use of \href{https://covid19datahub.io}{COVID-19 Data Hub}
#' }
#' 
#' The \href{https://covid19datahub.io}{COVID-19 Data Hub} (R package COVID19, GitHub repo, cloud storage), and its contents herein, including all data, mapping, and analyses, are provided to the public strictly for educational and academic research purposes. The \href{https://covid19datahub.io}{COVID-19 Data Hub} relies upon publicly available data from multiple sources. We are currently in the process of reconciling the providers with proper reference to their open-source data. Please inform us if you see any issues with the data licenses.
#' 
#' We try our best to guarantee the data quality and consistency and the continuous filling of the \href{https://covid19datahub.io}{COVID-19 Data Hub}. However, it is free software and comes with ABSOLUTELY NO WARRANTY. We hereby disclaim any and all representations and warranties with respect to the \href{https://covid19datahub.io}{COVID-19 Data Hub}, including accuracy, fitness for use, and merchantability. Reliance on the \href{https://covid19datahub.io}{COVID-19 Data Hub} for medical guidance or use of the \href{https://covid19datahub.io}{COVID-19 Data Hub} in commerce is strictly prohibited.
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
         1: admin area level 1
         2: admin area level 2
         3: admin area level 3")

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

    if(end == Sys.Date()){
      
      url  <- "https://storage.covid19datahub.io"
      name <- sprintf("%sdata-%s", ifelse(raw, 'raw', ''), level)
      zip  <- sprintf("%s/%s.zip", url, name) 
      file <- sprintf("%s.csv", name) 
      
      x <- try(suppressWarnings(read.zip(zip, file, cache = cache, colClasses = c("date" = "Date"))[[1]]), silent = TRUE)
      
    }
    else {
      
      if(end < "2020-04-14")
        stop("vintage data not available before 2020-04-14")
    
      file <- sprintf("https://storage.covid19datahub.io/%sdata-%s-%s.csv", ifelse(raw, 'raw', ''), level, format(as.Date(end),"%Y%m%d"))
      
      x <- try(suppressWarnings(read.csv(file, cache = cache, colClasses = c("date" = "Date"))), silent = TRUE)
      
    }
    
    if("try-error" %in% class(x) | is.null(x))
      stop(sprintf("vintage data not available on %s", end))

    if(length(ISO)>0)
      x <- x %>%
        dplyr::filter(sapply(strsplit(x$id,", "), function(x) x[[1]]) %in% ISO)

    if(nrow(x)==0)
      return(NULL)

  }
  else {

    # download 
    w <- try(cachecall("world", level = level, cache = cache))
    if("try-error" %in% class(w))
      w <- NULL
    
    for(fun in ISO) if(exists(fun, envir = asNamespace("COVID19"), mode = "function", inherits = FALSE)) {
      
      y <- try(cachecall(fun, level = level, cache = cache))
      
      if(is.null(y) | ("try-error" %in% class(y)))
        next

      if(level==1 & !is.null(w))
        y <- merge(y, w[w$iso_alpha_3==fun,], by = 'date', all = TRUE)
      
      x <- y %>%
        dplyr::mutate(iso_alpha_3 = fun) %>%
        dplyr::bind_rows(x)
        
    }

    if(!is.null(w))
      x <- w %>%
        dplyr::filter(!(iso_alpha_3 %in% x$iso_alpha_3) & iso_alpha_3 %in% ISO) %>%
        dplyr::bind_rows(x)

    # fallback
    if(nrow(x)==0){
      warning("
      Sorry, the data are not available. 
      Help us extending the number of supporting data sources as a joint effort against COVID-19.
      Join the mission: https://covid19datahub.io")
      return(NULL)
    }
        
    # stringency measures
    o <- try(cachecall('oxcgrt', cache = cache))
    if(!("try-error" %in% class(o)))
      x <- merge(x, o, by = c('date','iso_alpha_3'), all.x = TRUE)
    
    # reduce
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

    if(any(duplicated(x[,c("iso_alpha_3", "id", "date")])))
      stop("duplicated id on the same date")
    
    # # group by country
    # if(level==1)
    #   x$id <- NA
    # 
    # # aggregate
    # idx <- x %>%
    #   
    #   dplyr::group_by(iso_alpha_3, id, date) %>%
    #   
    #   dplyr::group_map(function(x,g){
    #     
    #     if(nrow(x)>1) return(g[[1]])
    #   
    #   }) %>%
    #   
    #   unlist() %>% 
    #   
    #   unique()
    # 
    # # @todo stop here on error
    # if(length(idx)>0){
    #   
    #   warning(sprintf("%s: data obtained by aggregating lower level data.", paste(idx, collapse = ", ")))
    #   
    #   x <- x %>%
    #     
    #     dplyr::group_by(iso_alpha_3, id, date) %>%
    #     
    #     dplyr::summarize(confirmed = sum(confirmed),
    #                      deaths    = sum(deaths),
    #                      tests     = sum(tests),
    #                      recovered = sum(recovered),
    #                      hosp      = sum(hosp),
    #                      icu       = sum(icu),
    #                      vent      = sum(vent)) 
    #   
    # }

    # merge top level slow var
    y <- db("ISO")
    if(level>1)
      y <- y[,c("iso_alpha_3","country")]
    
    x <- merge(x, y, by = "iso_alpha_3", all.x = TRUE)

    # merge slow var
    if(level>1)
      x <- x %>%

        dplyr::group_by(iso_alpha_3) %>%

        dplyr::group_map(keep = TRUE, function(x, iso){
          
          y <- try(db(iso[[1]]), silent = TRUE)
          if(class(y)!="try-error")
            x <- merge(x, y, by = "id", all.x = TRUE)
          
          return(x)
          
        }) %>%

        dplyr::bind_rows()

    # unique id
    x$id <- id(x$iso_alpha_3, x$id, esc = FALSE)

    # reduce
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
