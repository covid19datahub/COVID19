gov_ie <- function(level, cache) {
  
  if(level == 1) {
    
    # download
    url <- "https://opendata-geohive.hub.arcgis.com/datasets/d8eb52d56273413b84b0187a4e9117be_0.csv?outSR={%22latestWkid%22:3857,%22wkid%22:102100}"
    x   <- read.csv(url, cache = cache)
    
    # parse
    x <- map_data(x, c(
      "Date"                     = "date",
      "TotalConfirmedCovidCases" = "confirmed",
      "TotalCovidDeaths"         = "deaths",
      "RequiringICUCovidCases"   = "icu",
      "HospitalisedCovidCases"   = "hosp"
    ))
    
  }
  if(level == 2) {
    # download
    url <- "https://opendata-geohive.hub.arcgis.com/datasets/d9be85b30d7748b5b7c09450b8aede63_0.csv?outSR={%22latestWkid%22:3857,%22wkid%22:102100}"
    x   <- read.csv(url, cache = cache)
    
    # parse
    x <- map_data(x, c(
      "CountyName"          = "county",
      "TimeStamp"           = "date",
      "ConfirmedCovidCases" = "confirmed"
      # ConfirmedCovidDeaths, ConfirmedCovidRecovered = all null for some reason
    ))
  }
  
  # date format
  x$date <- as.Date(x$date, "%Y/%m/%d %H:%M:%S+00")
  
  # return
  return(x)
  
}