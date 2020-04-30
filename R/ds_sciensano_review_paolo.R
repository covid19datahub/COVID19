sciensano <- function(cache, level){
  # author: Elsa Burren
  
  # source: Sciensano, the Belgian institute for health, https://epistat.wiv-isp.be/covid/
  repo <- "https://epistat.sciensano.be/Data/"
  
  # Confirmed cases, hosp and icu are given on a Province level. 
  # Province => state levle.
  # Deaths by region only => aggregated to country level.
  # Confirmed cases, hosp, icu and deaths will be exported for level < 3.
  
  # Confirmed cases are, in a separate file, also given by municipality (city), 
  # the quality of the municipality data, however, seems at the time of writing inferior to the quality of the level < 3 data,
  # hence, not implemented.
  
  
  if(level < 3){
    
    urls_state = c(
      "confirmed" = "COVID19BE_CASES_AGESEX.csv", 
      "hosp"      = "COVID19BE_HOSP.csv"
    )
    
    to_aggregate = c("CASES", "TOTAL_IN", "TOTAL_IN_ICU", "DEATHS")
    
    # download and format state (=PROVINCE) level data # Comment: Not easy to read, but works
    x <- NULL
    for(i in 1:(length(urls_state))){ 
      
      url <- sprintf("%s%s", repo, urls_state[i]) 
      xx <- utils::read.csv(url, na.strings=c("","NA"), encoding = "UTF-16")
      
      # aggregating up to province (=state) level (from sex, agegroup,..)
      xx <- aggregate(xx[, names(xx) %in% to_aggregate], by=list(DATE=xx$DATE, PROVINCE=xx$PROVINCE), FUN=sum)
      
      if(is.null(x)){
        x <-xx
      }else{
        x <- merge(x, xx, all = TRUE)
      }
    }
    
    names(x) <- c("date", "state", "confirmed", "hosp", "icu")
    x   <- dplyr::group_by(x, state)
    
    # set NAs to zero and cumsum
    x$confirmed[is.na(x$confirmed)] <- 0
    x <- x %>% dplyr::mutate(confirmed = cumsum(confirmed))
    
    # aggregating level 2 data
    if(level == 1){
      x <- x[,c("date", "confirmed", "hosp", "icu")]
      x[is.na(x)] <- as.numeric(0)
      x <- aggregate(x[,!(names(x)%in%c("date"))], by=list(date=x$date), FUN=sum)
      
      # downloading level 1 data
      urls_country = c(
        "deaths"    = "COVID19BE_MORT.csv",
        "tests"     = "COVID19BE_tests.csv"
      )
      
      xx <- NULL
      for(i in 1:(length(urls_country))){
        
        url <- sprintf("%s%s", repo, urls_country[i]) 
        xxx <- utils::read.csv(url, encoding = "UTF-16")
        
        # aggregating up to country level (from region)
        if(any(names(xxx) %in% to_aggregate == TRUE))
          xxx <- aggregate(xxx[, names(xxx) %in% to_aggregate], by=list(DATE=xxx$DATE), FUN=sum)
        
        if(is.null(xx)){
          xx <-xxx
        }else{
          xx <- merge(xx, xxx, all = TRUE)
        }
      }
      
      colnames(xx)  <- c("date", "deaths", "tests")
      xx$country <- "BEL"
      
      xx <- xx %>% dplyr::group_by(country)
      xx$deaths[is.na(xx$deaths)] <- 0  
      xx <- xx %>% dplyr::mutate(deaths = cumsum(deaths))
      
      xx$tests[is.na(xx$tests)] <- 0  
      xx <- xx %>% dplyr::mutate(tests = cumsum(tests))  
      
      x <- merge(x,xx)
    }
  } 
  
  x$date <- as.Date(x$date, format="%Y-%m-%d")
  x$country   <- "Belgium"
  
  return(x)
}