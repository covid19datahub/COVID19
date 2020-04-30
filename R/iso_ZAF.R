ZAF <- function(level, cache){
  # Author: Martin Benes
  
  # fallback
  if(level>2)
    return(NULL)
  
  # download
  x <- covid19za(level = level, cache = cache)
  
  # id 
  if(level==2)
    x$id <- id(x$code)
  
  # return
  return(x)
  
}
