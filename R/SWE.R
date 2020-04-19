SWE <- function(level, cache){
  # Author: Martin Benes
  
  # fallback
  if(level>2)
    return(NULL)
  
  # download
  x <- oppnadata(cache = cache, level = level)
  
  # id
  if(level==1)
    x$id <- "SWE"
  if(level==2)
    x$id <- id(x$state) 
  
  # return
  return(x)
  
}

