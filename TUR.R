
TUR <- function(level, cache){
  # Author: Seehan
  
  # fallback
  if(level>1)
    return(NULL)
  
  # download
  x <- covid19turkey(cache = cache, level = level) 
  
  # return
  return(x)
  
}