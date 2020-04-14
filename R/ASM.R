ASM <- function(level, cache){

  # fallback
  if(level>1)
    return(NULL)

  # download
  x <- jhuCSSE(file = "US", cache = cache, id = "ASM")

  # return
  return(x)

}
