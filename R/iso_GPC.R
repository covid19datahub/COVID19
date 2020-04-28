GPC <- function(level, cache){

  # fallback
  if(level>1)
    return(NULL)

  # download
  x <- jhuCSSE(file = "global", cache = cache, level = level, id = "Grand Princess")

  # return
  return(x)

}
