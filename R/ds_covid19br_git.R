covid19br_git <- function(cache, level){
  
  if(level<=2){
    
    # download
    url <- "https://raw.githubusercontent.com/wcota/covid19br/master/cases-brazil-states.csv"
    x <- read.csv(url, cache = cache)
    
    # formatting
    x <- map_data(x, c(
      "date" = "date",
      "state" = "state",
      "deaths" = "deaths",
      "totalCases" = "confirmed",
      "recovered" = "recovered",
      "tests" = "tests",
      "vaccinated" = "vaccines_1",
      "vaccinated_second" = "vaccines_2"
    ))
    
    # total number of doses
    x$vaccines <- x$vaccines_1 + x$vaccines_2
    
    # filter
    idx <- which(x$state=="TOTAL")
    if(level==1)
      x <- x[idx,]
    else
      x <- x[-idx,]
    
  }
  else {
    
    # url
    url <- "https://raw.githubusercontent.com/wcota/covid19br/master/cases-brazil-cities-time.csv.gz"
    
    # download  
    tmp <- tempfile()
    download.file(url, destfile=tmp, mode="wb", quiet = TRUE)
    x <- read.csv(tmp, cache = cache)
    
    # formatting
    x <- map_data(x, c(
      "date" = "date",
      "ibgeID" = "code",
      "state" = "state",
      "deaths" = "deaths",
      "totalCases" = "confirmed"
    ))
    
    # filter cities
    x <- x[nchar(x$code)==7,]
    
  }
  
  # date
  x$date <- as.Date(x$date)
  
  # return
  return(x)
}
