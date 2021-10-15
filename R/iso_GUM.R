GUM <- function(level, cache){

  # fallback
  if(level>1)
    return(NULL)

  # download
  x <- nytimes_git(cache = cache, level = level+1, fips = "66")

  # return
  return(x)

}
