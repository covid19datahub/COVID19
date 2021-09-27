FRA <- function(level, cache){
  
  # fallback
  if(level > 3)
    return(NULL)

  # download  
  x <- gouv_fr(level = level)
  
  # id
  if(level==2)
    x$id <- id(x$reg, iso = "FRA", ds = "gouv_fr", level = level)
  if(level==3)
    x$id <- id(x$dep, iso = "FRA", ds = "gouv_fr", level = level)
  
  # return
  return(x)
  
}
