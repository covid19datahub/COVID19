ZAF <- function(level, cache){
  # Author: Martin Benes
  
  # fallback
  if(level>2)
    return(NULL)
  
  # download
  x <- covid19za(level = level, cache = cache)
  
  # return
  return(x)
  
}
