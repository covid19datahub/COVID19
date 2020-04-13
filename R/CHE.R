CHE <- function(level, cache){

  # fallback
  if(level>2)
    return(NULL)

  # download
  x <- openZH(cache = cache, id = "CH")

  # id: see https://github.com/emanuele-guidotti/COVID19/tree/master/inst/extdata/db/CHE.csv
  if(level==2)
    x$id <- x$code

  # return
  return(x)

}

