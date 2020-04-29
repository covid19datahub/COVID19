covidtracking <- function(cache,level){
# Montemurro Paolo
  
  # source
  url  <- "https://covidtracking.com/api/v1/states/daily.csv"
  
  # download
  x   <- read.csv(url, cache=cache)
  
  #Format 
  x$confirmed<- x$positive
  x$deaths   <- x$death
  x$tests    <- x$posNeg
  x$hosp     <- x$hospitalizedCurrently 
  x$icu      <- x$inIcuCurrently
  x$vent     <- x$onVentilatorCurrently
  
  x <- x[,c("date","state","confirmed","deaths","tests","hosp","icu","vent")]

  x$date <- as.Date(as.character(x$date),format="%Y%m%d")
  
  return(x) #Not clear...
  
}


