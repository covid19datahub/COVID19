#' @export
covid19 <- function(ISO = NULL, level = 1, raw = FALSE, cache = TRUE){

  # fallback
  if(level<1)
    return(NULL)

  # bindings
  iso_alpha_3 <- id <- date <- country <- state <- city <- confirmed <- tests <- deaths <- recovered <- hosp <- icu <- vent <- NULL

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

  # download
  for(fun in ISO){

    y <- try(do.call(fun, args = list(level = level, cache = cache)), silent = TRUE)

    if(!("try-error" %in% class(y)) & !is.null(y))
      x <- y %>%
        dplyr::mutate(iso_alpha_3 = fun) %>%
        dplyr::bind_rows(x)

  }

  if(length(ISO)!=length(unique(x$iso_alpha_3)))
    if(!is.null(w <- WORLD(level = level, cache = cache)))
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

  # fix
  x$date <- as.character(x$date)
  x <- x %>%

    dplyr::group_by(iso_alpha_3) %>%

    dplyr::group_map(keep = TRUE, function(x, iso){

      if(!is.null(y <- fix(iso[[1]]))){
        x <- x %>% dplyr::bind_rows(y)
        x <- x[!duplicated(x[,c('date','id')], fromLast = TRUE),]
        x <- tidyr::fill(x, iso_alpha_3, .direction = "downup")
      }

      return(x)

    }) %>%

    dplyr::bind_rows()

  # check dates
  if(any(is.na(x$date)))
    stop("column 'date' contains NA values")

  # clean
  x$date <- as.Date(x$date)
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

  # aggregate
  x <- x %>%

    dplyr::group_by(iso_alpha_3, id, date) %>%

    dplyr::summarize(confirmed = sum(confirmed),
                     deaths    = sum(deaths),
                     tests     = sum(tests),
                     recovered = sum(recovered),
                     hosp      = sum(hosp),
                     icu       = sum(icu),
                     vent      = sum(vent))

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

  # subset
  col <- c('date',vars())
  x[,col[!(col %in% colnames(x))]] <- NA
  x <- x[,col]

  # group and order
  x <- x %>%
    dplyr::group_by(country, state, city) %>%
    dplyr::arrange(country, state, city, date)

  # final check
  if(any(duplicated(x[,c('date','country','state','city')])))
    stop("the tuple ('date','country','state','city') must be unique")

  # return
  return(x)

}
