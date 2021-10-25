GPC <- function(level, cache){

  # fallback
  if(level>1)
    return(NULL)

  # download
  x <- github.cssegisanddata.covid19(file = "global", cache = cache, level = level, country = "Grand Princess")

  # return
  return(x)

}
