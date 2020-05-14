COL <- function(cache, level){
  # author: Federico Lo Giudice
  
  # fallback
  if(level>3)
    return(NULL)
  
  # get data
  x <- gov_co(cache = cache, level = level)
  
  # id
  if(level == 2)
    x$id <- id(x$state, iso = "COL", ds = "gov_co", level = level)
  if(level == 3)
    x$id <- id(x$city_code, iso = "COL", ds = "gov_co", level = level)

  # return
  return(x)
  
}

