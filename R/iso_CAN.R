CAN <- function(level, cache){
  # Paolo Montemurro 02/05/2020 - montep@usi.ch
  
  # fallback
  if(level>2)
    return(NULL)
  
  # download
  x <- canada_ca(cache = cache, level = level)
  
  # id
  if(level==2)
    x$id <- id(x$name, iso = "CAN", ds = "canada_ca", level = level)
  
  # return
  return(x)
  
}