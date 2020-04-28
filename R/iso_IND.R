IND <- function(level, cache){
  # Author: Rijin Baby
  
  # fallback
  if(level>2)
    return(NULL)
  
  # download
  x <- openIND(cache = cache, level = level) 

  # id  
  if(level==2)
    x$id <- id(x$state)

  # return
  return(x)
  
}
