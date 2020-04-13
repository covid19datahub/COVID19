PRI <- function(level, cache){

  # fallback
  if(level>1)
    return(NULL)

  # download
  x <- jhuCSSE("US", cache = cache, id = "PRI")

  # return
  return(x)

}
