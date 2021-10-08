GBR <- function(level, cache){
  
  # fallback
  if(level>3)
    return(NULL)
  
  # download
  x <- gov_uk(level = level)
  
  # identifiers
  x$id <- id(x$code, iso = "GBR", ds = "gov_uk", level = level)

  # return
  return(x)
  
}