MNP <- function(level, cache){

  # fallback
  if(level>2)
    return(NULL)

  # download
  x <- nytimes_git(cache = cache, level = level+1, fips = "69")
  
  # identifier
  if(level==2)
    x$id <- id(x$fips, iso = "MNP", ds = "nytimes_git", level = level)
  
  # return
  return(x)

}
