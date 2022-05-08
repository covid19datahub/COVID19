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
#' @source https://github.com/covid19datahub/covid19br
#'
#' @keywords internal
#'
github.covid19datahub.covid19br <- function(level){
  if(level!=3) return(NULL)
  
  # download
  url <- "https://raw.githubusercontent.com/covid19datahub/covid19br/main/data.csv.gz"
  x <- data.table::fread(url, encoding = "UTF-8", showProgress = FALSE)
  
  # format
  x <- map_data(x, c(
    "Date" = "date",
    "IBGE" = "ibge",
    "TotalVaccinations" = "vaccines",
    "PeopleVaccinated" = "people_vaccinated",
    "PeopleFullyVaccinated" = "people_fully_vaccinated"
  ))
  
  # drop missing IBGE
  x <- x[which(x$ibge!="999999"),]
  
  # convert date
  x$date <- as.Date(x$date)
  
  return(x)
}
