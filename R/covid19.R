#' COVID-19 Data Hub
#'
#' Unified datasets for a better understanding of COVID-19.
#'
#' @param country vector of country names or \href{https://github.com/covid19datahub/COVID19/blob/master/inst/extdata/db/ISO.csv}{ISO codes} (alpha-2, alpha-3 or numeric).
#' @param level integer. Granularity level. 1: country-level data. 2: state-level data. 3: city-level data.
#' @param start the start date of the period of interest.
#' @param end the end date of the period of interest.
#' @param vintage logical. Retrieve the snapshot of the dataset that was generated at the \code{end} date instead of using the latest version. Default \code{FALSE}.
#' @param raw logical. Skip data cleaning? Default \code{FALSE}. See details.
#' @param cache logical. Memory caching? Significantly improves performance on successive calls. Default \code{TRUE}.
#' @param verbose logical. Print data sources? Default \code{TRUE}.
#'
#' @details 
#' The raw data are cleaned by filling missing dates with \code{NA} values. 
#' This ensures that all locations share the same grid of dates and no single day is skipped. 
#' Then, \code{NA} values are replaced with the previous non-\code{NA} value or \code{0}.
#'
#' @return Grouped \code{tibble} (\code{data.frame})
#'
#' @examples
#' \dontrun{
#'
#' # Worldwide data by country
#' x <- covid19()
#'
#' # Worldwide data by state
#' x <- covid19(level = 2)
#'
#' # Specific country data by city
#' x <- covid19(c("Italy","US"), level = 3)
#' 
#' # Data sources
#' s <- attr(x, "src")
#' }
#'
#' @source \url{https://covid19datahub.io}
#'
#' @references 
#' Guidotti, E., Ardia, D., (2020), "COVID-19 Data Hub", Journal of Open Source Software 5(51):2376, \doi{10.21105/joss.02376}.
#'
#' @note 
#' We have invested a lot of time and effort in creating \href{https://covid19datahub.io}{COVID-19 Data Hub}, please:
#' 
#' \itemize{
#' \item cite \href{https://doi.org/10.21105/joss.02376}{Guidotti and Ardia (2020)} when using \href{https://covid19datahub.io}{COVID-19 Data Hub}.
#' \item place the URL \url{https://covid19datahub.io} in a footnote to help others find \href{https://covid19datahub.io}{COVID-19 Data Hub}.
#' \item you assume full risk for the use of \href{https://covid19datahub.io}{COVID-19 Data Hub}. 
#' We try our best to guarantee the data quality and consistency and the continuous filling of the Data Hub. 
#' However, it is free software and comes with ABSOLUTELY NO WARRANTY. 
#' Reliance on \href{https://covid19datahub.io}{COVID-19 Data Hub} for medical guidance or use of \href{https://covid19datahub.io}{COVID-19 Data Hub} in commerce is strictly prohibited.
#' }
#' 
#' @export
#'
covid19 <- function(country = NULL,
                    level   = 1,
                    start   = "2019-01-01",
                    end     = Sys.Date(),
                    raw     = FALSE,
                    vintage = FALSE,
                    verbose = TRUE,
                    cache   = TRUE){

  # fallback
  if(!(level %in% 1:3))
    stop("valid options for 'level' are:
         1: admin area level 1
         2: admin area level 2
         3: admin area level 3")

  # cache
  cachekey <- make.names(sprintf("covid19_%s_%s_%s_%s",paste0(country, collapse = "."), level, ifelse(vintage, end, 0), raw))
  if(cache & exists(cachekey, envir = cachedata)){
    x <- get(cachekey, envir = cachedata)    
    return(x[x$date >= start & x$date <= end,])
  }

  # data
  x <- data.frame()
  
  # ISO 
  iso <- extdata("db","ISO.csv")
  if(is.null(country)){
    ISO <- iso$iso_alpha_3
  }
  else {
    ISO <- sapply(toupper(country), function(i) iso$iso_alpha_3[which(iso$iso_alpha_2==i | iso$iso_alpha_3==i | iso$iso_numeric==i | toupper(iso$administrative_area_level_1)==i)])
    ISO <- as.character(unique(ISO))  
  }
    
  if(length(ISO)==0)
    return(NULL)

  # vintage
  if(vintage){
    
    url  <- "https://storage.covid19datahub.io"
    name <- sprintf("%sdata-%s", ifelse(raw, 'raw', ''), level)
    
    # download
    if(end == Sys.Date()){
      
      zip  <- sprintf("%s/%s.zip", url, name) 
      file <- sprintf("%s.csv", name) 
      
      x   <- try(read.zip(zip, file, cache = cache)[[1]], silent = TRUE)
      src <- try(read.csv(sprintf("%s/src.csv", url), cache = cache), silent = TRUE)
      
      if("try-error" %in% c(class(x),class(src)) | is.null(x) | is.null(src))
        stop(sprintf("vintage data not available today", end))
      
    }
    else {
      
      if(end < "2020-04-14")
        stop("vintage data not available before 2020-04-14")
    
      zip          <- sprintf("%s/%s.zip", url, end)
      files        <- c(paste0("data-",1:3,".csv"), paste0("rawdata-",1:3,".csv"), "src.csv")
      names(files) <- gsub("\\.csv$", "", files)
      
      x <- try(read.zip(zip, files, cache = cache), silent = TRUE)
    
      if("try-error" %in% class(x) | is.null(x))
        stop(sprintf("vintage data not available on %s", end))
      
      src <- x[["src"]]
      x   <- x[[name]]
      
    }
    
    # filter
    if(length(ISO)>0)
      x <- dplyr::filter(x, iso_alpha_3 %in% ISO)

    # check
    if(nrow(x)==0)
      return(NULL)

  }
  # download 
  else {

    # world
    w <- try(cachecall("world", level = level, cache = cache))
    if("try-error" %in% class(w))
      w <- NULL
    
    # ISO
    for(fun in ISO) if(exists(fun, envir = asNamespace("COVID19"), mode = "function", inherits = FALSE)) {
      
      # try 
      y <- try(cachecall(fun, level = level, cache = cache))
      
      # skip on failure
      if(is.null(y) | ("try-error" %in% class(y)))
        next

      # top level
      if(level==1){
        
        # merge fallback
        if(!is.null(w)) if(length(idx <- which(w$iso_alpha_3==fun)))
          y <- merge(y, w[idx,], by = 'date', all = TRUE)
        
        # iso as id
        y$id <- fun

      } 
  
      # add iso and bind data
      x <- y %>%
        dplyr::mutate(iso_alpha_3 = fun) %>%
        dplyr::bind_rows(x)
        
    }

    # fallback 
    if(!is.null(w))
      x <- w %>%
        dplyr::filter(!(iso_alpha_3 %in% x$iso_alpha_3) & iso_alpha_3 %in% ISO) %>%
        dplyr::bind_rows(x)

    # filter
    x <- x[!is.na(x$id),]
    
    # check
    if(nrow(x)==0){
      warning("
      Sorry, the data are not available. 
      Help us extending the number of supporting data sources as a joint effort against COVID-19.
      Join the mission: https://covid19datahub.io")
      return(NULL)
    }
        
    # stringency measures
    o <- try(cachecall('oxcgrt_git', cache = cache))
    if(!("try-error" %in% class(o)))
      x <- merge(x, o, by = c('date','iso_alpha_3'), all.x = TRUE)
    
    # subset
    key <- c('iso_alpha_3','id','date',vars('fast'))
    x[,key[!(key %in% colnames(x))]] <- NA
    x <- x[,key]

    # 0 to NA
    for(i in c('hosp','vent','icu'))
      x[[i]] <- dplyr::na_if(x[[i]], 0)
    
    # check 
    if(length(which(idx <- is.na(x$date))))
      stop(sprintf("column 'date' contains NA values: %s", paste0(unique(x$iso_alpha_3[idx]), collapse = ", ")))

    # clean
    dates  <- seq(min(x$date), max(x$date), by = 1)
    if(!raw)
      x <- x %>%

        dplyr::group_by(id) %>%

        dplyr::group_map(.keep = TRUE, function(x, ...){

          miss <- dates[!(dates %in% x$date)]
          if(length(miss)>0)
            x <- x %>%
              dplyr::bind_rows(data.frame(date = miss)) %>%
              tidyr::fill(id, iso_alpha_3, .direction = "downup")

          return(x)

        }) %>%

        dplyr::bind_rows() %>%

        dplyr::group_by(id) %>%

        dplyr::arrange(date) %>%

        tidyr::fill(vars("fast"), .direction = "down") %>%

        tidyr::replace_na(as.list(sapply(vars("fast"), function(x) 0)))

    # check
    if(length(idx <- which(duplicated(x[,c("id", "date")]))))
      stop(sprintf("multiple dates per id: %s", paste0(unique(x$id[idx]), collapse = ", ")))
    
    # merge top level data
    y <- extdata("db","ISO.csv")
    if(level>1)
      y <- y[,c("iso_alpha_3","iso_alpha_2","iso_numeric","currency","administrative_area_level_1")]
    
    x <- merge(x, y, by = "iso_alpha_3", all.x = TRUE)

    # merge lower level data
    if(level>1)
      x <- x %>%

        dplyr::group_by(iso_alpha_3) %>%

        dplyr::group_map(.keep = TRUE, function(x, iso){
          
          y <- extdata("db", sprintf("%s.csv",iso[[1]]))
          if(!is.null(y))
            x <- merge(x, y[,!grepl("^id\\_", colnames(y))], by = "id", all.x = TRUE)
          
          return(x)
          
        }) %>%

        dplyr::bind_rows()
    
    # data source
    src <- extdata("src.csv")

  }
  
  # severe
  # idx <- which(is.na(x$severe) | x$severe==0)
  # x$severe[idx] <- x$icu[idx] + x$vent[idx]
  
  # subset
  cn <- colnames(x)
  cn <- unique(c(vars(), "key", cn[grepl("^key\\_", cn)]))
  x[,cn[!(cn %in% colnames(x))]] <- NA
  x <- x[,cn]
  
  # type conversion
  x <- x %>% 
    dplyr::mutate_at('date', as.Date) %>%
    dplyr::mutate_at(vars('integer'), as.integer) %>%
    dplyr::mutate_at(vars('numeric'), as.numeric) %>%
    dplyr::mutate_at(vars('character'), as.character)
  
  # group and order
  x <- x %>%
    dplyr::group_by(id) %>%
    dplyr::arrange(id, date)

  # check
  if(any(duplicated(x[,c('date','administrative_area_level_1','administrative_area_level_2','administrative_area_level_3')])))
    warning("the tuple ('date','administrative_area_level_1','administrative_area_level_2','administrative_area_level_3') is not unique")

  # src
  attr(x, "src") <- try(cite(x, src, verbose = verbose))
  
  # cache
  if(cache)
    assign(cachekey, x, envir = cachedata)

  # return
  return(x[x$date >= start & x$date <= end,])

}
