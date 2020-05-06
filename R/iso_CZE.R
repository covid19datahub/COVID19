CZE <- function(level, cache){
  # Author: Martin Benes
  
  # fallback
  if(level > 2)
    return(NULL)
  
  # download
  x <- mzcr(level = level, cache = cache)
  
  # id
  if(level == 2)
    x$id <- x$state
  
  # return
  return(x)
  
}
