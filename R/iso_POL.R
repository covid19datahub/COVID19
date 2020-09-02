POL <- function(level, cache) {
  # Author: Martin Benes
  
  # fallback
  if(level > 3)
    return(NULL)
  
  # download
  x <- covid19poland_git(level = level, cache = cache)
  
  # id
  if(level == 2)
    x$id <- id(x$state, iso = "POL", ds = "covid19poland_git", level = level)
  if(level == 3)
    x$id <- id(x$district, iso = "POL", ds = "covid19poland_git", level = level)

  # return
  return(x)
  
}
