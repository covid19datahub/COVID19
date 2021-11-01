#' The COVID Tracking Project
#'
#' Data source for: United States
#'
#' @param level 2
#'
#' @section Level 2:
#' - confirmed cases
#' - deaths
#' - recovered
#' - tests
#' - hospitalizations
#' - intensive care
#' - patients requiring ventilation
#'
#' @source https://covidtracking.com/data/api
#'
#' @keywords internal
#'
covidtracking.com <- function(level){
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
  
  return(x) 
}
