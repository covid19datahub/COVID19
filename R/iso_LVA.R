LVA <- function(level, cache){
  # Author: Martin Benes
  
  # fallback
  if(level>2)
    return(NULL)
  
  # download
  x <- gov_lv(cache = cache, level = level)

  # id  
  if(level==2)
    x$id <- id(x$region_id, iso = "LVA", ds = "gov_lv", level = level)
  
  # return
  return(x)
  
}

