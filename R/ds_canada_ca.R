canada_ca <- function(cache,level){
  # Author: Paolo Montemurro 02/05/2020 - montep@usi.ch
  
  # === source === #
  url  <- "https://health-infobase.canada.ca/src/data/covidLive/covid19.csv"
  
  # === download === #
  x   <- read.csv(url, cache = cache, na.strings = c("","N/A"))
  
  # === formatting === #
  x <- map_data(x, c(
    "date",
    "prname"     = "name",
    "pruid"      = "uid",
    "numdeaths"  = "deaths",
    "numconf"    = "confirmed",
    "numtested"  = "tests",
    "numrecover" = "recovered"
  ))

  x$date <- as.Date(x$date, format = "%d-%m-%Y")
  
  # === cleaning === #
  
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
