WORLD <- function(level, cache){

  # fallback
  if(level>2)
    return(NULL)

  # download
  x <- jhuCSSE(file = "global", cache = cache)

  # filter
  if(level==2)
    x <- x[x$lat!=0 & x$lng!=0 & x$state!="",]

  # ISO code
  iso    <- db("ISO")
  isomap <- iso$iso_alpha_3
  names(isomap) <- iso$country
  x$iso_alpha_3 <- mapvalues(x$country, isomap)

  # id: see https://github.com/emanuele-guidotti/COVID19/tree/master/inst/extdata/db/
  if(level==2)
    x$id <- x$state

  # return
  return(x)

}
