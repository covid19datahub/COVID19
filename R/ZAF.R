ZAF <- function(level, cache){
  # Author: Martin Benes
  
  # fallback
  if(level>2)
    return(NULL)
  
  # download
  x <- covid19za(level = level, cache = cache)
  
  # id
  if(level == 1)
    x$id <- "ZAF"
  else if(level == 2)
    x$id <- x$state
  # return
  return(x)
  
}

ZAF(2,F)
