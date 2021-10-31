#' Ministry of Health and National Institute for Public health
#'
#' Data source for: Slovenia
#'
#' @param level 1
#'
#' @section Level 1:
#' - confirmed cases
#' - deaths
#' - tests
#' - hospitalizations
#' - intensive care
#'
#' @source https://www.gov.si/en/topics/coronavirus-disease-covid-19/actual-data/
#'
#' @keywords internal
#'
gov.si <- function(level){
  if(level!=1) return(NULL)
  
  # download
  url <- 'https://www.gov.si/assets/vlada/Koronavirus-podatki/en/EN_Covid-19-all-data.xlsx'
  x <- read.excel(url, sheet = 1)
  
  # format
  x <- map_data(x, c(
    'Date'                                         = 'date',
    'Tested (all)'                                 = 'tests',
    'Positive (all)'                               = 'confirmed',
    'All hospitalized on certain day'              = 'hosp',
    'All persons in intensive care on certain day' = 'icu',
    'Deaths (all)'                                 = 'deaths'
  ))
  
  # clean deaths
  x$deaths <- as.numeric(gsub("\\*$", "", x$deaths))
  
  # clean date
  x$date <- as.Date(suppressWarnings(as.numeric(x$date)), origin = "1899-12-30")   
  x <- x[!is.na(d),]
  
  return(x)
}
