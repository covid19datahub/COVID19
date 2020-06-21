nytimes_git <- function(cache, level){

  # source
  repo <- "https://raw.githubusercontent.com/nytimes/covid-19-data/master/" 
  urls <- c("us.csv","us-states.csv","us-counties.csv")
  url  <- paste0(repo, urls[level])
  
  # download
  x   <- read.csv(url, cache = cache)
  
  # format 
  x <- map_data(x, c(
    'date',
    'state',
    'fips',
    'county' = 'city',
    'cases'  = 'confirmed',
    'death'  = 'deaths'
  ))

  # clean
  if(level==3){
    
    x <- x[x$city!="Unknown",]
    x$fips[x$city=="New York City"] <- 36061
    x$fips[x$city=="Kansas City"]   <- 90000

  }
  
  # date
  x$date <- as.Date(x$date, format = "%Y-%m-%d")
  
  # return
  return(x) 
  
}


