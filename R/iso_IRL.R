IRL <- function(level, cache) {
  
  # fallback
  if(level != 2) return(NULL)
  
  # download
  x <- gov_ie(cache = cache)
  
  # id
  x$id <- id(x$county, iso = "IRL", ds = "gov_ie", level = level)
  
  # return
  return(x)
  
}