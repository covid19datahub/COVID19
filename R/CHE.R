CHE <- function(level, cache){

  # fallback
  if(level>2)
    return(NULL)

  # download
  x <- openZH(cache = cache, id = "CH")

  # id: see https://github.com/covid19datahub/COVID19/tree/master/inst/extdata/db/CHE.csv
  x$id <- id(x$code)

  # return
  return(x)

}

