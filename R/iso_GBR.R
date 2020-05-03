GBR <- function(level, cache){
  
  # fallback
  if(level>3)
    return(NULL)
  
  # download
  x <- govuk(cache = cache, level = level)
  
  # id
  if(level==2)
    x$id <- id(x$id)
  if(level==3)
    x$id <- id(x$id)
  
  # return
  return(x)
  
}