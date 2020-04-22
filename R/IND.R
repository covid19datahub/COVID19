
IND <- function(level, cache){
  
  # fallback
  if(level>2)
    return(NULL)
  
  # download
  file <- c('nation','state')
  x <- OpenIND(file = file[level], cache = cache)
  
  if(level==1)
    x$id <- "IND"
  if(level==2)
    x$id <- id(x$state)
  
  # return
  return(x)
  
}
