sciensano <- function(cache, level){
  # author: Elsa Burren
  
  # cache
  level_name <- ifelse(level == 3,"3","1or2")
  cachekey <- make.names(sprintf("sciensano_level_%s", level_name))
  if(cache & exists(cachekey, envir = cachedata))
    return(get(cachekey, envir = cachedata))
  
  stringsAsFactorsDefault <- default.stringsAsFactors()
  options(stringsAsFactors = FALSE)
  
  # source: Sciensano, the Belgian institute for health
  
  repo <- "https://epistat.sciensano.be/Data/"
  
  # Confirmed cases, hosp and icu are given on a PROVINCE level. 
  # PROVINCE level is chosen to be the state levle.
  # Deaths is given by region only. The 3 Belgium regions will be aggregated to country level.
  # Confirmed cases, hosp, icu and deaths will be exported for level < 3.
  #
  # Confirmed cases are, in a separate file, also given by municipality (city). 
  # This file is used in level = 3.
  # The quality of the municipality data, however, seems at the time of writing inferior to the quality of the level < 3 data.
  
  x <- NULL
  
  if(level < 3){
    
    urls_state = c(
      "confirmed" = "COVID19BE_CASES_AGESEX.csv", 
      "hosp"      = "COVID19BE_HOSP.csv"
    )
    
    urls_country = c(
      "deaths"    = "COVID19BE_MORT.csv",
      "tests"    = "COVID19BE_tests.csv"
    )
    
    to_aggregate = c("CASES", "TOTAL_IN", "TOTAL_IN_ICU", "DEATHS")
    # ------------------------------------------------------------------------------
    # download and format state (PROVINCE) level data
    x <- NULL
    for(i in 1:(length(urls_state))){ 
      
      url <- sprintf("%s%s", repo, urls_state[i]) 
      xx <- utils::read.csv(url, na.strings=c("","NA"), encoding = "UTF-16")
      
      # aggregating up to province (state) level (from sex, agegroup,..)
      xx <- aggregate(xx[, names(xx) %in% to_aggregate], by=list(DATE=xx$DATE, PROVINCE=xx$PROVINCE), FUN=sum)
      
      if(is.null(x)){
        x <-xx
      }else{
        x <- merge(x, xx, all = TRUE)
      }
    }
    
    names(x) <- c("date", "state", "confirmed", "hosp", "icu")
    
    x <- x %>% 
      dplyr::group_by(state) %>%
      dplyr::arrange(date) 
    # not every province has a new confirmed case on every date, so we need to replace these NAs by 0 before doing the cumsum
    x$confirmed[is.na(x$confirmed)] <- 0
    x <- x %>% 
      dplyr::mutate(confirmed = cumsum(confirmed))
    
    # adding columns so that we can do a rbind with deaths and tests dataframe later
    x$deaths  <- NA
    x$tests   <- NA
    x$country <- "BEL"
    
    # ------------------------------------------------------------------------------
    # download and format country level data (Belgium's 3 REGIONs will be aggregated)
    xxx <- NULL
    
    for(i in 1:(length(urls_country))){
    
      url <- sprintf("%s%s", repo, urls_country[i]) 
      xxxx <- utils::read.csv(url, encoding = "UTF-16")
      
      # aggregating up to country level (from region)
      if(any(names(xxxx) %in% to_aggregate == TRUE))
        xxxx <- aggregate(xxxx[, names(xxxx) %in% to_aggregate], by=list(DATE=xxxx$DATE), FUN=sum)
      
      if(is.null(xxx)){
        xxx <-xxxx
      }else{
        xxx <- merge(xxx, xxxx, all = TRUE)
      }
      
    }
    
    xx           <- data.frame(matrix(ncol = length(colnames(x)), nrow = nrow(xxx)))
    colnames(xx) <- colnames(x)
    xx$tests     <- xxx$TESTS
    xx$date      <- xxx$DATE
    xx$deaths    <- xxx$x
    xx$country   <- "BEL"
    
    # cumsum of confirmed cases over time (a simple cumsum on xxx would have worked but this way it is more general)
    xx <- xx %>% 
      dplyr::group_by(country) %>%
      dplyr::arrange(date)
    xx$deaths[is.na(xx$deaths)] <- 0  
    xx <- xx %>% 
      dplyr::mutate(deaths = cumsum(deaths))
    xx$tests[is.na(xx$tests)] <- 0  
    xx <- xx %>% 
      dplyr::mutate(tests = cumsum(tests))  
    
    x <- rbind(x,xx)
  } 
  # end of level < 3
  
  if(level == 3){
    
    urls_city     = c(
      "confirmed" = "COVID19BE_CASES_MUNI.csv"
    )
    
    # download and format city level data

    for(i in 1:(length(urls_city))){
      # (loop at the time of writing not necessary, placeholder for potential future datasets)
      
      url <- sprintf("%s%s", repo, urls_city[i]) 
      x <- utils::read.csv(url, encoding = "UTF-16")
      x <- x[, c("DATE", "TX_DESCR_FR", "CASES")]
      colnames(x) <- c("date", "city", "confirmed")
    }
    
    # Difficult choices here! 
    # Warning: Decided to set the newly daily confirmed values to 2 if "<5" is given, however, error could grow with cumsum !!!
    # Warning: Further decided to drop rows with NA in date (maybe they are placeholders for next day)
    x <- x[!is.na(x$date),]
    x[x=="<5"] <- "2"
    x$confirmed <- as.numeric(x$confirmed)
    
    x <- x %>% 
      dplyr::group_by(city) %>%
      dplyr::arrange(date) 
    # we proceed as for province level date, setting potential NAs to zero before doing the cumsum
    x$confirmed[is.na(x$confirmed)] <- 0
    x <- x %>% dplyr::mutate(confirmed = cumsum(confirmed))
    
  }

  # cache
  if(cache)
    assign(cachekey, x, envir = cachedata)
  
  # reset default and return
  options(stringsAsFactors = stringsAsFactorsDefault)
  
  x$date <- as.Date(x$date, format="%Y-%m-%d")
  return(x)
  
}
