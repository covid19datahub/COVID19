ITA <- function(level, cache){

  # fallback
  if(level>3)
    return(NULL)

  # download
  file <- c('nazione','regioni','province')
  x    <- pcmdpc(file = file[level], cache = cache)

  # filter
  if(!is.null(x$lat) & !is.null(x$lng))
    x <- x[x$lat!=0 | x$lng!=0,]

  # id: see https://github.com/emanuele-guidotti/COVID19/tree/master/inst/extdata/db/ITA.csv
  if(level==1)
    x$id <- "ITA"
  if(level==2)
    x$id <- id(x$state)
  if(level==3)
    x$id <- id(x$sigla_provincia)

  # return
  return(x)

}
