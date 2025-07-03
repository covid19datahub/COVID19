#' COVID-19 Data Hub
#'
#' Data source for: Worldwide
#'
#' For references and original data sources, see: 
#' \url{https://covid19datahub.io/reference/index.html}.
#'
#' @param iso ISO alpha-3 country code
#' @param level 1, 2, 3
#'
#' @section Level 1:
#' - confirmed cases
#' - deaths
#' - recovered
#' - tests
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#' - hospitalizations
#' - intensive care
#'
#' @section Level 2:
#' - confirmed cases
#' - deaths
#' - recovered
#' - tests
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#' - hospitalizations
#' - intensive care
#'
#' @section Level 3:
#' - confirmed cases
#' - deaths
#' - recovered
#' - tests
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#' - hospitalizations
#' - intensive care
#' 
#' @source https://storage.covid19datahub.io/
#'
#' @keywords internal

covid19datahub.io <- function(iso, level) {
  if(!level %in% 1:3) return(NULL)

  # url
  url <- sprintf("https://storage.covid19datahub.io/country/%s.csv", iso)

  # download
  x <- read.csv(url)
  
  # filter
  x <- x[x$administrative_area_level == level, ] %>% 
    select("id", "date", "confirmed", "deaths", "recovered", "tests", 
           "vaccines", "people_vaccinated", "people_fully_vaccinated", 
           "hosp", "icu", "vent", "administrative_area_level", "key_local")
  
  # convert date
  x$date<- as.Date(x$date)
  
  return(x)
}
