mspp <- function(cache, id=NULL){

  
  # Source Ministry of Public Health and Population of Haiti
  # Provided by https://data.humdata.org/dataset/haiti-covid-19-subnational-cases
  # R code by Federico Lo Giudice
  
  library(plyr)
  
  #' Download and cache the data.
  
  url <- "https://proxy.hxlstandard.org/data/738954/download/haiti-covid-19-subnational-data.csv"
  
  x   <- read.csv(url, sep = ',')[-1,]
  
  #' Create the column 'date'.
  x$Date <- as.Date(x$Date, format = "%d-%m-%Y")

  #filter
  x[,c(ncol(x), ncol(x)-1, ncol(x)-2)] <- NULL
  x <- x$Suspected.cases <- NULL
  x <- rename(x, c("DÃ.partement"="state", "Confirmed.cases"="confirmed"))
  
 return(x)
  
}

