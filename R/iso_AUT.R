AUT <- function(level, ...){
  if(level>3) return(NULL)
  
  x <- gv_at(level = level)
  
  if(level==2)
    x$id <- id(x$state_id, iso = "AUT", ds = "gv_at", level = level)
  if(level==3)
    x$id <- id(x$city_id, iso = "AUT", ds = "gv_at", level = level)
  
  return(x)
  
}

