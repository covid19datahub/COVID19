AUT <- function(level, cache){
  # Author: Martin Benes
  
  # fallback
  if(level>3)
    return(NULL)
  
  # download
  x <- gv_at(cache = cache, level = level)
  
  # level
  if(level==2)
    x$id <- id(x$state_id, iso = "AUT", ds = "gv_at", level = level)
  if(level==3)
    x$id <- id(x$city_id, iso = "AUT", ds = "gv_at", level = level)
  
  # return
  return(x)
  
}

