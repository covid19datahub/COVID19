CAN <- function(level, cache){
  # Paolo Montemurro 02/05/2020 - montep@usi.ch
  
  # fallback
  if(level>2)
    return(NULL)
  
  # download
  x <- canada_data(cache = cache, level = level)
  
  # id
  if(level==2)
    x$id <- id(x$id)
  
  # return
  return(x)

}
