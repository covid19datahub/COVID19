FRA <- function(level, cache){
  
  # fallback
  if(level > 3)
    return(NULL)
  
  if(level == 1)
    x <- gouv_fr(level = level, cache = cache)
  else
    x <- opencovid_fr(level = level, cache = cache)
 
  # id
  if(level>1)
    x$id <- id(x$maille_code, iso = "FRA", ds = "opencovid_fr", level = level)
  
  # return
  return(x)
  
}
