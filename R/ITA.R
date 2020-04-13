ITA <- function(level, cache){

  # fallback
  if(level>3)
    return(NULL)

  # download
  file <- c('nazione','regioni','province')
  x    <- pcmdpc(file[level], cache = cache)

  # clean
  if(!is.null(x$lat) & !is.null(x$lng))
    x <- x[x$lat!=0 | x$lng!=0,]

  # id: see https://github.com/emanuele-guidotti/COVID19/tree/master/inst/extdata/db/ITA.csv
  if(level==2)
    x$id <- x$state
  if(level==3)
    x$id <- x$sigla_provincia

  # return
  return(x)

}
