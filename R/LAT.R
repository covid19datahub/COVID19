LAT <- function(level, cache){
  # Author: Martin Benes
  
  # fallback
  if(level>2)
    return(NULL)
  
  # download
  x <- cdpc(cache = cache)
  
  # id
  if(level==1) {
    x$id <- x$country
    x <- x[which(is.na(x$region)),] # select country records
    x <- subset(x, select=-c(region,region_id)) # remove region attributes
  }
  else if(level == 2) {
    x$id <- x$region_id
    x <- x[which(!is.na(x$region)),] # select region records
    x <- subset(x, select=-c(tests, hospitalized, deaths))
  }
  
  # return
  return(x)
  
}

#LAT(1, F)
