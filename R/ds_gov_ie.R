gov_ie <- function(level, cache) {
  # data from https://covid19ireland-geohive.hub.arcgis.com/
  
  if(level == 1) {
    
    # urls
    url       <- "https://opendata.arcgis.com/datasets/d8eb52d56273413b84b0187a4e9117be_0.csv"
    url.icu   <- "https://opendata.arcgis.com/datasets/c8208a0a8ff04a45b2922ae69e9b2206_0.csv"
    url.hosp  <- "https://opendata.arcgis.com/datasets/fe9bb23592ec4142a4f4c2c9bd32f749_0.csv"
    url.tests <- "https://opendata.arcgis.com/datasets/f6d6332820ca466999dbd852f6ad4d5a_0.csv"
    
    # download
    x       <- read.csv(url, cache = cache)
    x.icu   <- read.csv(url.icu, cache = cache)
    x.hosp  <- read.csv(url.hosp, cache = cache)
    x.tests <- read.csv(url.tests, cache = cache)
    
    # formatting
    x <- map_data(x, c(
      "Date"                     = "date",
      "TotalConfirmedCovidCases" = "confirmed",
      "TotalCovidDeaths"         = "deaths"
    ))
    x$date <- as.Date(x$date, "%Y/%m/%d")
    
    x.icu <- map_data(x.icu, c(
      "extract"    = "date",
      "ncovidconf" = "icu"
    ))
    x.icu$date <- as.Date(x.icu$date, "%Y/%m/%d")
    
    x.hosp <- map_data(x.hosp, c(
      "Date"                            = "date",
      "SUM_number_of_confirmed_covid_1" = "hosp"
    ))
    x.hosp$date <- as.Date(x.hosp$date, "%Y/%m/%d")
    
    colnames(x.tests)[1] <- "date"
    x.tests <- map_data(x.tests, c(
      "date"      = "date",
      "TotalLabs" = "tests"
    ))
    x.tests$date <- as.Date(x.tests$date, "%Y/%m/%d")
    
    # merge
    x <- x %>% 
      merge(x.icu, by = "date", all = TRUE) %>%
      merge(x.hosp, by = "date", all = TRUE) %>%
      merge(x.test, by = "date", all = TRUE) 
    
  }
  if(level == 2) {
    
    # download
    url <- "https://opendata.arcgis.com/datasets/d9be85b30d7748b5b7c09450b8aede63_0.csv"
    x   <- read.csv(url, cache = cache)
    
    # parse
    x <- map_data(x, c(
      "CountyName"              = "county",
      "TimeStamp"               = "date",
      "ConfirmedCovidCases"     = "confirmed",
      "ConfirmedCovidDeaths"    = "deaths", 
      "ConfirmedCovidRecovered" = "recovered"
    ))
    x$date <- as.Date(x$date, "%Y/%m/%d")
    
  }
  
  # return
  return(x)
  
}