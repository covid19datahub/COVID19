CZE <- function(level, cache){
  # Author: Martin Benes
  
  # fallback
  if(level>1)
    return(NULL)
  
  # download
  x <- mzcr(cache = cache)
  
  # id
  if(level==1)
    x$id <- "CZE"
  
  # return
  return(x)
  
}

