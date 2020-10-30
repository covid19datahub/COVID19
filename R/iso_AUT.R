AUT <- function(level, cache){
  # Author: Martin Benes
  
  # fallback
  if(level>2)
    return(NULL)
  
  # download
  x <- gv_at(cache = cache, level = level)
  
  # level
  if(level==2){
    
    # id
    x$id <- id(x$state_id, iso = "AUT", ds = "gv_at", level = level)
    
  }
  
  # return
  return(x)
  
}

