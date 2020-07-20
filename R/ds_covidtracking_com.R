covidtracking_com <- function(cache){
# Author: Montemurro Paolo
  
  # source
  url  <- "https://covidtracking.com/api/v1/states/daily.csv"
  
  # download
  x   <- read.csv(url, cache = cache)
  
  # format 
  x <- map_data(x, c(
    'date',
    'state',
    'fips',
    'positive'              = 'confirmed',
    'death'                 = 'deaths',
    'posNeg'                = 'tests',
    'recovered'             = 'recovered',
    'hospitalizedCurrently' = 'hosp',
    'inIcuCurrently'        = 'icu',
    'onVentilatorCurrently' = 'vent'
  ))

  x$date <- as.Date(as.character(x$date), format = "%Y%m%d")
  
  return(x) 
  
}


