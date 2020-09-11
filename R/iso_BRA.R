BRA <- function(level, cache) {
  # author: Martin Benes <martinbenes1996@gmail.com>
  
  # fallback
  if(level > 3) { return(NULL) }
  
  # download
  x <- covid19brazil_git(level = level, cache = cache)
  
  # id
  if(level == 2)
    x$id <- id(x$region, iso = "BRA", ds = "covid19brazil_git", level = level)
  else if(level == 3)
    x$id <- id(x$state, iso = "BRA", ds = "covid19brazil_git", level = level)
  
  # return
  return(x)
}