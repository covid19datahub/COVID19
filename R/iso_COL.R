COL <- function(cache, level){
  # author: Federico Lo Giudice
  
  # fallback
  if(level>3)
    return(NULL)
  
  # get data
  x <- msps(cache = cache, level = level)
  
  # id
  if(level == 2)
    x$id <- x$state
  if(level == 3)
    x$id <- x$city

  # return
  return(x)
  
}

