#' Health Protection Surveillance Centre (HPSC) and Health Service Executive (HSE)
#'
#' Data source for: Ireland
#'
#' @param level 1, 2
#'
#' @section Level 1:
#' - confirmed cases
#' - deaths
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
#'
#' @source https://covid-19.geohive.ie/search
#'
#' @keywords internal
#'
geohive.ie <- function(level) {
  if(!level %in% 1:2) return(NULL)

  if(level==1) {
    
    # cases
    url.cases <- "https://opendata.arcgis.com/datasets/d8eb52d56273413b84b0187a4e9117be_0.csv"
    x.cases <- read.csv(url.cases)
    
    # format cases
    x.cases <- map_data(x.cases, c(
      "Date"                     = "date",
      "TotalConfirmedCovidCases" = "confirmed",
      "TotalCovidDeaths"         = "deaths"
    ))
    
    # convert date
    x.cases$date <- as.Date(x.cases$date, "%Y/%m/%d")
    
    # intensive care
    url.icu <- "https://opendata.arcgis.com/datasets/c8208a0a8ff04a45b2922ae69e9b2206_0.csv"
    x.icu <- read.csv(url.icu)
    
    # format icu
    x.icu <- map_data(x.icu, c(
      "extract"    = "date",
      "ncovidconf" = "icu"
    ))
    
    # convert date
    x.icu$date <- as.Date(x.icu$date, "%Y/%m/%d")
    
    # hospitalizations
    url.hosp  <- "https://opendata.arcgis.com/datasets/fe9bb23592ec4142a4f4c2c9bd32f749_0.csv"
    x.hosp  <- read.csv(url.hosp)
    
    # format hospitalizations
    x.hosp <- map_data(x.hosp, c(
      "Date"                            = "date",
      "SUM_number_of_confirmed_covid_1" = "hosp"
    ))
    
    # convert date
    x.hosp$date <- as.Date(x.hosp$date, "%Y/%m/%d")
    
    # tests
    url.tests <- "https://opendata.arcgis.com/datasets/f6d6332820ca466999dbd852f6ad4d5a_0.csv"
    x.tests <- read.csv(url.tests, fileEncoding = "UTF-8-BOM")
    
    # format tests
    x.tests <- map_data(x.tests, c(
      "Date_HPSC" = "date",
      "TotalLabs" = "tests"
    ))
    
    # convert date
    x.tests$date <- as.Date(x.tests$date, "%Y/%m/%d")
    
    # vaccines
    url.vacc <- "https://opendata.arcgis.com/datasets/a0e3a1c53ad8422faf00604ee08955db_0.csv"
    x.vacc <- read.csv(url.vacc, fileEncoding = "UTF-8-BOM")
    
    # format vaccines
    x.vacc <- map_data(x.vacc, c(
      "VaccinationDate" = "date",
      "Dose1Cum" = "first",
      "Dose2Cum" = "second",
      "SingleDoseCum" = "oneshot",
      "PartiallyVacc" = "people_vaccinated",
      "FullyVacc" = "people_fully_vaccinated"
    )) 
    
    # compute total vaccine doses
    x.vacc <- x.vacc %>%
      mutate(vaccines = first + second + oneshot)
    
    # convert date
    x.vacc$date <- as.Date(x.vacc$date, format = "%Y/%m/%d")
    
    # merge
    by <- "date"
    x <- x.cases %>% 
      full_join(x.icu, by = by) %>%
      full_join(x.hosp, by = by) %>%
      full_join(x.vacc, by = by) %>%
      full_join(x.tests, by = by)
    
    # fix duplicates
    x <- x[!duplicated(x[,"date"], fromLast = TRUE),]
    
  }
  
  if(level==2) {
    
    # cases
    url <- "https://opendata.arcgis.com/datasets/d9be85b30d7748b5b7c09450b8aede63_0.csv"
    x <- read.csv(url)
    
    # format cases
    x <- map_data(x, c(
      "ORIGID"                  = "county_id",
      "CountyName"              = "county",
      "PopulationCensus16"      = "population",
      "Lat"                     = "latitude",
      "Long"                    = "longitude",
      "TimeStamp"               = "date",
      "ConfirmedCovidCases"     = "confirmed",
      "ConfirmedCovidDeaths"    = "deaths", 
      "ConfirmedCovidRecovered" = "recovered"
    ))
    
    # convert date
    x$date <- as.Date(x$date, "%Y/%m/%d")
    
    # fix duplicates
    x <- x[!duplicated(x[,c("date", "county_id")], fromLast = TRUE),]
    
  }
  
  return(x)
}
