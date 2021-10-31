#' Ozan Erturk
#'
#' Data source for: Turkey
#'
#' @param level 1
#'
#' @section Level 1:
#' - confirmed cases
#' - deaths
#' - recovered
#' - tests
#' - intensive care
#' - patients requiring ventilation
#'
#' @source https://github.com/ozanerturk/covid19-turkey-api
#'
#' @keywords internal
#'
github.ozanerturk.covid19turkeyapi <- function(level){
  if(level!=1) return(NULL)

  # download
  url <- "https://raw.githubusercontent.com/ozanerturk/covid19-turkey-api/master/dataset/timeline.csv"
  x   <- read.csv(url, na.strings = c("", "-")) 
  
  # formatting
  x <- map_data(x, c(
    'date'               = 'date',
    'totalTests'         = 'tests',
    'totalPatients'      = 'confirmed',
    'totalDeaths'        = 'deaths',
    'totalRecovered'     = 'recovered',
    'totalIntensiveCare' = 'icu',
    'totalIntubated'     = 'vent'
  ))
  
  # clean date
  x <- x[!is.na(x$date),]
  x$date <- as.Date(x$date, format = "%d/%m/%Y")
  
  return(x)
}
