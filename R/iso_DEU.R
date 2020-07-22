DEU <- function(level, cache){

  # fallback
  if(level > 3)
    return(NULL)
  
  # download
  x <- gov_de(cache = cache, level = level)
  
  # id
  if(level==2)
    x$id <- id(x$id_state, iso = "DEU", ds = "gov_de", level = level)
  if(level==3)
    x$id <- id(x$id_district, iso = "DEU", ds = "gov_de", level = level)
  
  # return
  return(x)
  
}