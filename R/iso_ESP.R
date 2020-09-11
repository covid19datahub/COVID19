ESP <- function(level, cache) {
  # Author: Martin Benes 07/09/2020 - martinbenes1996@gmail.com
  
  # fallback
  if(level==1 | level>3)
    return(NULL)
  
  # download
  x <- mscbs_es(level = level, cache = cache)
  
  # id
  if(level == 2)
    x$id <- id(x$state, iso = "ESP", ds = "mscbs_es", level = level)
  if(level == 3)
    x$id <- id(x$district, iso = "ESP", ds = "mscbs_es", level = level)
    
  # return
  return(x)
  
}