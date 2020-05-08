HTI <- function(level, cache){
  # author: Federico Lo Giudice

  # fallback
  if(level > 2)
    return(NULL)
  
  # get data
  x <- hdx(cache = cache, level = level)
  
  if(level == 2)
    x$id <- x$state
  
  # return
  return(x)
  
}
