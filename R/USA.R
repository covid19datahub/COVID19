USA <- function(level, cache){

  # fallback
  if(level>3)
    return(NULL)

  # download
  x <- jhuCSSE("US", cache = cache, id = "USA")

  # clean
  x <- x[!(x$state %in% c("Grand Princess","Diamond Princess")),]

  # id: see https://github.com/emanuele-guidotti/COVID19/tree/master/inst/extdata/db/USA.csv
  if(level==2)
    x$id <- x$state
  if(level==3)
    x$id <- paste(x$state, x$city, sep = ", ")

  # return
  return(x)

}
