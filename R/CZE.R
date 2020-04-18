CZE <- function(level, cache){
  
  # fallback
  if(level>1)
    return(NULL)
  
  # download
  x <- mzcr(cache)
  
  # filter
  #if(!is.null(x$lat) & !is.null(x$lng))
  #  x <- x[x$lat!=0 | x$lng!=0,]
  
  # id: see https://github.com/emanuele-guidotti/COVID19/tree/master/inst/extdata/db/CZE.csv
  if(level==1)
    x$id <- "CZ"
  
  # return
  return(x)
  
}

#CZE(1,NA)
