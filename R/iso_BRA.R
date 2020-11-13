BRA <- function(level, cache) {
  
  # fallback
  if(level < 2)
    return(NULL)
  
  # download (Espirito Santo)
  x <- gov_br_es(level = level, cache = cache)
  
  # id
  if(level == 2)
    x$id <- id(x$State, iso = "BRA", ds = "gov_br_es", level = level)
  if(level == 3)
    x$id <- id(x$Municipio, iso = "BRA", ds = "gov_br_es", level = level)
    
  # return
  return(x)
  
}