infobase_canada <- function(cache,level){
  # Paolo Montemurro 02/05/2020 - montep@usi.ch
  
  # === source === #
  url  <- "https://health-infobase.canada.ca/src/data/covidLive/covid19.csv"
  
  # === download === #
  x   <- read.csv(url, cache=cache)
  
  # === formatting === #
  x$date <- as.Date(x$date, format = "%d-%m-%Y")
  x           <- x[,c("prname","date","numdeaths","numconf","numtested","numrecover")]
  colnames(x) <- c("id","date","deaths","confirmed","tests","recovered")
  
  # === cleaning === #
  # creating levels
  x$level <- 2
  x$level[x$id=="Canada"] <- 1
  
  # deleting non territories
  x  <- x[x$id!="Repatriated travellers",]
  x$recovered[x$recovered=="N/A"] <- NA
  x$recovered <- as.integer(x$recovered)
  
  # === filtering === #
  if(level==1){x <- x[x$level==1,]}
  if(level==2){x <- x[x$level==2,]}
  
  # return
  return(x)
  
}
