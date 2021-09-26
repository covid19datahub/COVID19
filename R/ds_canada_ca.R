canada_ca <- function(cache,level){
  # Author: Paolo Montemurro 02/05/2020 - montep@usi.ch
  
  # === source === #
  url  <- "https://health-infobase.canada.ca/src/data/covidLive/covid19-download.csv"
  
  # === download === #
  x   <- read.csv(url, cache = cache, na.strings = c("","N/A"))
  
  # === formatting === #
  x <- map_data(x, c(
    "date",
    "pruid"      = "id",
    "prname"     = "name",
    "numdeaths"  = "deaths",
    "numconf"    = "confirmed",
    "numtests"   = "tests",
    "numrecover" = "recovered"
  ))
  
  # formatting thousand separator
  for(i in c("deaths", "confirmed", "tests", "recovered"))
    x[,i] <- as.numeric(gsub(",", "", x[,i])) 

  # formatting date
  x$date <- as.Date(x$date)
  
  # deleting non territories
  x <- x[x$name!="Repatriated travellers",] 
  
  # creating levels
  if(level==1)
    x <- x[x$name=="Canada",]   
  if(level==2)
    x <- x[x$name!="Canada",]  

  # return
  return(x)
  
}
