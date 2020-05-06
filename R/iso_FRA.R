FRA <- function(level, cache){
  # author: Martin Benes
  
  # fallback
  if(level > 3)
    return(NULL)
  
  # get the data
  x <- santePublique(level=level, cache=cache)
  
  
  # Create the column 'id'.
  if(level == 2)
    x$id <- x$state
  if(level == 3)
    x$id <- x$city
  
  # return
  return(x)
}
