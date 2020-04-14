MNP <- function(level, cache){

  # fallback
  if(level>1)
    return(NULL)

  # download
  x <- jhuCSSE(file = "US", cache = cache, id = "MNP")

  # return
  return(x)

}
