CZE <- function(level, cache){
  # Author: Martin Benes
  
  # fallback
  if(level > 2)
    return(NULL)
  
  # download
  x <- mzcr_cz(level = level, cache = cache)
  
  # id
  if(level == 2)
    x$id <- id(x$state, iso = "CZE", ds = "mzcr_cz", level = level)
  
  # return
  return(x)
  
}
