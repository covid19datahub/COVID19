RUS <- function(level, cache){
  
  # fallback
  if(level>2)
    return(NULL)
  
  # download
  x <- openRU(cache = cache)
  
  # id
  if(level==1)
    x$id <- "RUS"
  if(level==2)
    x$id <- x$state
  
  # return
  return(x)
  
}

