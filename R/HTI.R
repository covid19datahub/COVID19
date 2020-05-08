
hdx <- function(cache, level){
  # author: Federico Lo Giudice
  
  # Provided by : HUMANITARIAN DATA EXCHANGE - https://data.humdata.org/dataset/haiti-covid-19-subnational-cases
  # Source : Ministry of Public Health and Population of Haiti
  
  #cache
  cachekey <- "hdx"
  if(cache & exists(cachekey, envir = cachedata)){
  return(get(cachekey, envir = cachedata))
  }
  
  if(level==2){
    
  #' Download
    
  url <- "https://proxy.hxlstandard.org/data/738954/download/haiti-covid-19-subnational-data.csv"
  
  x   <- read.csv(url, sep = ',', fileEncoding = "UTF-8", stringsAsFactors=FALSE)[-1,]
  
  #' Create the column 'date'.
  
  x$Date <- as.Date(x$Date, format = "%d-%m-%Y")

  
  #filter
  
   x = select(x, Date, Département, Confirmed.cases, Deaths)
   x = rename(x, c("date" ="Date", "state"= "Département", "confirmed"="Confirmed.cases" , "deaths"= "Deaths"))
  
   x$confirmed = as.numeric(x$confirmed)
   x$deaths = as.numeric(x$deaths)

   
   #fill dates gaps per state
   x = x %>%
        complete(date = seq.Date(min(x$date), max(x$date), by="day"), state) %>%
        mutate_if(is.character, ~replace_na(., 0)) %>%
        group_by(state) %>%
        fill(confirmed, deaths) 
   
     
  #Add constants and id
   
  x$country <- 'Haiti'
  x$iso <- "HTI"
  x$id <- 1:nrow(x)
    
  #reorder column
  
  x = x[ ,c("id", "date", "deaths", "confirmed", "country", "state", "iso" ) ]
  
  
  #reorder rows
  
  x <- x[order(x$state),]
  
  }
  
  
 cache
 if(cache)
 assign(cachekey, x, envir = cachedata)
  
  
 return(x)
  
}

