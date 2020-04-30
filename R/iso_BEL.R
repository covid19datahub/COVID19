BEL <- function(level, cache){
  # author: Elsa Burren
  
  # fallback
  if(level > 2)
    return(NULL)
  
  # download
  x <- sciensano(cache = cache, level)
  
  # id
  if(level==2)
    x$id <- id(x$state)
  
  # return
  return(x)
  
}