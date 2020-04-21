AUT <- function(level, cache){
  # Author: Martin Benes
  
  # fallback
  if(level>1)
    return(NULL)
  
  # download
  x <- bmsgpk(cache = cache)
  
  # id
  if(level==1)
    x$id <- "AUT"
  
  # return
  return(x)
  
}

