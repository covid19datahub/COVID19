#' Matt Bolton
#'
#' Data source for: Australia
#'
#' @param level 1, 2
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
#' - patients requiring ventilation
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
#' - patients requiring ventilation
#'
#' @source https://github.com/M3IT/COVID-19_Data
#'
#' @keywords internal
#'
github.m3it.covid19data <- function(level) {
  if(!level %in% 1:2) return(NULL)

  # download
  url <- "https://raw.githubusercontent.com/M3IT/COVID-19_Data/master/Data/COVID19_Data_Hub.csv"
  x <- read.csv(url, na.strings = c("NA",""))

  # format date
  x$date <- as.Date(x$date)

  # filter by level
  x <- x[x$administrative_area_level == level,]

  return(x)
}
