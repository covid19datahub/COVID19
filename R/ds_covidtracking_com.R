#' The COVID Tracking Project 
#' 
#' Imports confirmed cases, deaths, recovered, tests, and hospitalization data for U.S. states from 
#' The COVID Tracking Project. The Project has ended all data collection as of March 7, 2021. 
#' The existing API will continue to work until May 2021, but will only include data up to March 7, 2021.
#' 
#' @source 
#' https://covidtracking.com/data/api
#' 
#' @keywords internal
#' 
covidtracking_com <- function(level){
  if(level!=2) return(NULL)
  
  # download
  url <- "https://covidtracking.com/api/v1/states/daily.csv"
  x   <- read.csv(url)
  
  # format 
  x <- map_data(x, c(
    'date',
    'state',
    'fips',
    'positive'              = 'confirmed',
    'death'                 = 'deaths',
    'totalTestResults'      = 'tests',
    'recovered'             = 'recovered',
    'hospitalizedCurrently' = 'hosp',
    'inIcuCurrently'        = 'icu',
    'onVentilatorCurrently' = 'vent'
  ))

  # date
  x$date <- as.Date(as.character(x$date), format = "%Y%m%d")
  
  # return
  return(x) 
  
}


