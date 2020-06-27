CAC <- function(level, cache){

  # fallback
  if(level>1)
    return(NULL)

  # download
  x <- covid19jp_git(cache = cache, level = 1, id = "Costa Atlantica")

  # return
  return(x)

}
