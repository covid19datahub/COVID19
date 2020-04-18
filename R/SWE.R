SWE <- function(level, cache){
  
  # fallback
  if(level>2)
    return(NULL)
  
  # download
  x <- oppnadata(cache)
  
  # filter
  if(level == 1) {
    x <- x[is.na(x$state),] # selection - only country
    x <- subset(x, select=-state) # projection - remove 'state' attribute
  }
  if(level == 2) {
    x <- x[!is.na(x$state),] # selection - only regions
  }
  
  if(level==1)
    x$id <- "SWE"
  if(level==2)
    x$id <- x$state #id(x$state) # TODO: add
  
  # return
  return(x)
  
}

#SWE(2,NA)
