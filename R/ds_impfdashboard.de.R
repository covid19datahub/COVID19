#' Robert Koch Institute and the Federal Ministry of Health
#'
#' Data source for: Germany
#'
#' @param level 1
#'
#' @section Level 1:
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#'
#' @source https://impfdashboard.de/en/data
#'
#' @keywords internal
#'
impfdashboard.de <- function(level){
  if(level!=1) return(NULL)
  
  # download
  url <- "https://impfdashboard.de/static/data/germany_vaccinations_timeseries_v2.tsv"
  x <- read.csv(url, sep = "\t")
  
  # format
  x <- map_data(x, c(
    "date" = "date",
    "dosen_kumulativ" = "vaccines",
    "personen_erst_kumulativ" = "people_vaccinated",
    "personen_voll_kumulativ" = "people_fully_vaccinated"
  ))
  
  # convert date
  x$date <- as.Date(x$date)
  
  return(x) 
}
