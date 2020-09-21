ourworldindata_org <- function(cache, id = NULL){
  
  url <- "https://covid.ourworldindata.org/data/owid-covid-data.csv"
  x   <- read.csv(url, cache = cache)
  
  # filter 
  x <- x[!is.na(x$iso_code),]
  if(!is.null(id))
    x <- x[x$iso_code %in% id,]
  
  # formatting
  x <- map_data(x, c(
    'date',
    'iso_code'     = 'iso_alpha_3',
    'location'     = 'country',
    'total_cases'  = 'confirmed',
    'total_deaths' = 'deaths',
    'total_tests'  = 'tests'
  ))
  
  # date
  x$date <- as.Date(x$date)
  
  # fix duplicates. Yes, it may happen -_-'
  idx <- which(duplicated(x[,c("date","iso_alpha_3")]))
  if(length(idx)){
    warning(sprintf("ourworldindata duplicated rows for %s", 
                    paste(unique(x$iso_alpha_3[idx]), collapse = ", ")))
    x <- x[-idx,]  
  }
  
  # return
  return(x)
    
}

