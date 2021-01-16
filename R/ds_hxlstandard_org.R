hxlstandard_org <- function(cache){
  # author: Federico Lo Giudice
  
  # Provided by : HUMANITARIAN DATA EXCHANGE - https://data.humdata.org/dataset/haiti-covid-19-subnational-cases
  # Source : Ministry of Public Health and Population of Haiti
  # Level 2: Data at regional level only
  
  # download
  url <- "https://proxy.hxlstandard.org/data/738954/download/haiti-covid-19-subnational-data.csv"
  x   <- read.csv(url, cache = cache)[-1,]
  
  # formatting 
  colnames(x)[2] <- "state"
  x <- map_data(x, c(
    'state'             = 'state',
    'Date'              = 'date',
    'Cumulative.cases'  = 'confirmed',
    'Cumulative.Deaths' = 'deaths'
  ))
  
  # fix 
  x$state <- map_values(x$state, c("GrandAnse" = "Grand Anse"))
  
  # clean
  idx <- which(x$state=="Grand Total")
  if(length(idx))
    x <- x[-idx,]
  
  # date
  x$date <- as.Date(x$date, format="%d-%m-%Y")
  
  # integers
  x$confirmed <- as.numeric(gsub(",", "", x$confirmed))
  x$deaths    <- as.numeric(gsub(",", "", x$deaths))
  
  # return
  return(x)
  
}

