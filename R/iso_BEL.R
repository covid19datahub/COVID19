BEL <- function(level, cache){
  # author: Elsa Burren
  
  # fallback
  if(level > 2)
    return(NULL)
  
  # download
  x <- sciensano(cache = cache, level = level)
  
  # id
  if(level==2)
    x$id <- id(x$REGION)
  
  # return
  return(x)
  
}