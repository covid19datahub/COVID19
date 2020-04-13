ASM <- function(level, cache){

  # fallback
  if(level>1)
    return(NULL)

  # download
  x <- jhuCSSE("US", cache = cache, id = "ASM")

  # return
  return(x)

}
