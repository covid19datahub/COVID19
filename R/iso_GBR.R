GBR <- function(level, cache){
  
  # fallback
  if(level>3)
    return(NULL)
  
  # fallback to worldwide data
  if(level==1)
    return(NULL)
  
  # download
  x <- govuk(cache = cache, level = level)
  
  # id
  if(level==2)
    x$id <- id(x$code)
  if(level==3)
    x$id <- id(x$code)
  
  # return
  return(x)
  
}