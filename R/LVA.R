LVA <- function(level, cache){
  # Author: Martin Benes
  
  # fallback
  if(level>2)
    return(NULL)
  
  # download
  x <- cdpc(cache = cache, level = level)
  
  # id
  if(level==1) 
    x$id <- "LVA"
  if(level == 2) 
    x$id <- x$region_id
  
  # return
  return(x)
  
}

