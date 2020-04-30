ITA <- function(level, cache){

  # fallback
  if(level>3)
    return(NULL)

  # download
  x <- pcmdpc(cache = cache, level = level)

  # id
  if(level==2)
    x$id <- id(x$state)
  if(level==3)
    x$id <- id(x$city)

  # return
  return(x)

}
