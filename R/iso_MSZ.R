MSZ <- function(level, cache){

  # fallback
  if(level>1)
    return(NULL)

  # download
  x <- jhucsse_git(file = "global", cache = cache, level = level, country = "MS Zaandam")

  # return
  return(x)

}
