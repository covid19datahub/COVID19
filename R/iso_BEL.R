BEL <- function(level, cache){
  # author: Elsa Burren
  
  # fallback
  if(level > 2)
    return(NULL)
  
  # download
  x <- sciensano_be(cache = cache, level = level)
  
  # id
  if(level==2)
    x$id <- id(x$REGION, iso = "BEL", ds = "sciensano_be", level = level)
  
  # return
  return(x)
  
}