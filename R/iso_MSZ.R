MSZ <- function(level, cache){

  # fallback
  if(level>1)
    return(NULL)

  # download
  x <- github.cssegisanddata.covid19(file = "global", cache = cache, level = level, country = "MS Zaandam")

  # return
  return(x)

}
