USA <- function(level, cache){

  # fallback
  if(level>3)
    return(NULL)

  # download
  x <- jhuCSSE(file = "US", cache = cache, id = "USA")

  # filter
  x <- x[-which(x$state %in% c("Grand Princess","Diamond Princess")),]

  # id: see https://github.com/emanuele-guidotti/COVID19/tree/master/inst/extdata/db/USA.csv
  if(level<=2)
    x$id <- id(x$state)
  if(level==3)
    x$id <- id(x$state, x$city)

  # return
  return(x)

}
