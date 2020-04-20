AUT <- function(level, cache){
  # Author: Martin Benes
  
  # fallback
  if(level>1)
    return(NULL)
  
  # download
  x <- bmsgpk(cache = cache)
  
  
  # id
  if(level==1)
    x$id <- x$country
  
  # return
  return(x)
  
}

AUT(1,F)