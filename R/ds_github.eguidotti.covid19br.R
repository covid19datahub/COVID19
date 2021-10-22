#' Emanuele Guidotti
#'
#' Data source for: Brazil
#'
#' @param level 3
#'
#' @section Level 3:
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#'
#' @source https://github.com/eguidotti/covid19br
#'
#' @keywords internal
#'
github.eguidotti.covid19br <- function(level){
  if(level!=3) return(NULL)
  
  url <- "https://raw.githubusercontent.com/eguidotti/covid19br/main/data.csv.gz"
  x <- data.table::fread(url, encoding = "UTF-8", showProgress = FALSE)
  
  x <- map_data(x, c(
    "Date" = "date",
    "IBGE" = "ibge",
    "TotalVaccinations" = "vaccines",
    "PeopleVaccinated" = "people_vaccinated",
    "PeopleFullyVaccinated" = "people_fully_vaccinated"
  ))
  
  x <- x[which(x$ibge!="999999"),]
  
  x$date <- as.Date(x$date)
  
  return(x)
}
