CHN <- function(level, cache){

  # fallback
  if(level>1)
    return(NULL)

  # download
  x <- who_int(cache = cache, iso_alpha_2 = "CN")

  # return
  return(x)

}

