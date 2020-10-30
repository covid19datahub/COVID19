PER <- function(level, cache){
  
  # fallback
  if(level>2)
    return(NULL)
  
  # download
  x <- covid19peru_git(cache = cache, level = level)
  
  # id
  if(level==2)
    x$id <- id(x$key, iso = "PER", ds = "covid19peru_git", level = level)
  
  # return
  return(x)
  
}