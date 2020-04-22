IND <- function(level, cache){
  # Author: Rijin Baby
  
  # fallback
  if(level>2)
    return(NULL)
  
  # download
  x <- OpenIND(cache = cache, level = level)
  
  # id
  if(level==1)
    x$id <- "IND"
  if(level==2)
    x$id <- id(x$state)
  
  # return
  return(x)
  
}
