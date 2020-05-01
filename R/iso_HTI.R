
HTI <- function(level, cache){

  #author: Federico Lo Giudice
  
  x <- hdx(cache = cache, level = level)
  
  
  # Create the column 'id'.
   x$id <- id(x$date)
  
  
  # return
    return(x)
  
}