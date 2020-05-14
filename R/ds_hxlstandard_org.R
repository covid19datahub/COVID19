hxlstandard_org <- function(cache){
  # author: Federico Lo Giudice
  
  # Provided by : HUMANITARIAN DATA EXCHANGE - https://data.humdata.org/dataset/haiti-covid-19-subnational-cases
  # Source : Ministry of Public Health and Population of Haiti
  # Level 2: Data at regional level only
  
  # download
  url <- "https://proxy.hxlstandard.org/data/738954/download/haiti-covid-19-subnational-data.csv"
  x   <- read.csv(url, cache=cache, encoding = "UTF-8")[-1,]
  
  # formatting 
  x <- map_data(x, c(
    'Date'              = 'date',
    'Département'       = 'id',
    'Cumulative.cases'  = 'confirmed',
    'Cumulative.Deaths' = 'deaths'
  ))
  
  # date
  x$date <- as.Date(x$date, format="%d-%m-%Y")
  
  # integers
  x$confirmed <- as.integer(x$confirmed)
  x$deaths    <- as.integer(x$deaths)
  
  # return
  return(x)
  
}

