LVA <- function(level, cache){
  # Author: Martin Benes

  # fallback
  if(level==2)
    return(NULL)
  
  # download
  x <- gov_lv(level = level)

  # identifiers
  if(level==3)
    x$id <- id(x$atvk, iso = "LVA", ds = "gov_lv", level = level)

  # return
  return(x)
  
}

