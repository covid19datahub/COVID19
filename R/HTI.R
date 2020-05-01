hdx <- function(cache, level){
  # author: Federico Lo Giudice
  
  # Provided by : HUMANITARIAN DATA EXCHANGE - https://data.humdata.org/dataset/haiti-covid-19-subnational-cases
  # Source : Ministry of Public Health and Population of Haiti
  
  # cache
  cachekey <- "mspp"
  if(cache & exists(cachekey, envir = cachedata))
  return(get(cachekey, envir = cachedata))
  
  
  #' Download
  
  if(level==2)
    
  url <- "https://proxy.hxlstandard.org/data/738954/download/haiti-covid-19-subnational-data.csv"
  
  
  x   <- read.csv(url, sep = ',')[-1,]
  
  #' Create the column 'date'.
  x$Date <- as.Date(x$Date, format = "%d-%m-%Y")

  #filter
  x[,c(ncol(x), ncol(x)-1, ncol(x)-2)] <- NULL
  x <- x$Suspected.cases <- NULL
  x <- rename(x, c("DÃ.partement"="state", "Confirmed.cases"="confirmed"))
  
  
  cache
  if(cache)
  assign(cachekey, x, envir = cachedata)
  
  
 return(x)
  
}

