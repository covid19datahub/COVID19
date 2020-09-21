TWN <- function(level, cache) {
  # Author: Lim Jone Keat
  
  # fallback
  if(level > 2)
    return(NULL)
  
  # download
  x <- gov_tw(level = level, cache = cache)
  
  # level
  if(level==2)
    x$id <- id(x$county, iso = "TWN", ds = "gov_tw", level = level)
  
  # return
  return(x)
}