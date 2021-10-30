#' COVID-19 India API
#'
#' Data source for: India
#'
#' @param level 2
#'
#' @section Level 2:
#' - confirmed cases
#' - deaths
#' - recovered
#' - tests
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#'
#' @source https://data.covid19india.org
#'
#' @keywords internal
#'
covid19india.org <- function(level){
  if(level!=2) return(NULL)

  # state codes
  url.codes <- "https://data.covid19india.org/csv/latest/state_wise.csv"
  x.codes <- read.csv(url.codes)
  
  # format codes
  x.codes <- map_data(x.codes, c(
    "State" = "state",
    "State_code" = "code"
  ))
  
  # cases
  url.cases <- "https://data.covid19india.org/csv/latest/states.csv"
  x.cases <- read.csv(url.cases)
  
  # format cases
  x.cases <- map_data(x.cases, c(
    "Date" = "date",
    "State" = "state",
    "Confirmed" = "confirmed",
    "Recovered" = "recovered",
    "Deceased" = "deaths",
    "Tested" = "tests"
  ))
  
  # convert date
  x.cases$date <- as.Date(x.cases$date)
  
  # vaccines
  url.vacc <- "http://data.covid19india.org/csv/latest/vaccine_doses_statewise_v2.csv"
  x.vacc <- read.csv(url.vacc)
  
  # format vaccines
  x.vacc <- map_data(x.vacc, c(
    "Vaccinated.As.of" = "date",
    "State" = "state",
    "First.Dose.Administered" = "people_vaccinated",
    "Second.Dose.Administered" = "people_fully_vaccinated",
    "Total.Doses.Administered" = "vaccines"
  ))
  
  # convert date
  x.vacc$date <- as.Date(x.vacc$date, format = "%d/%m/%Y")

  # merge
  by <- c("date", "state")
  x <- x.cases %>%
    full_join(x.vacc, by = by) %>%
    left_join(x.codes, by = "state")
  
  # drop total and unassigned
  x <- x %>%
    filter(!is.na(code) & !code %in% c("TT", "UN"))
  
  return(x)
}
