CHL <- function(level, cache) {
  
  # fallback
  if(level == 1 | level > 3) return(NULL)
  
  # download
  x <- covid19chile_git(level, cache)
  
  # id
  if(level == 2)
    x$id <- id(x$region, iso = "CHL", ds = "covid19chile_git", level = level)
  if(level == 3)
    x$id <- id(x$commune, iso = "CHL", ds = "covid19chile_git", level = level)
  
  # return
  return(x)
}