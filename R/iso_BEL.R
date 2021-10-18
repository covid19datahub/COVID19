BEL <- function(level, ...){
  if(level > 3) return(NULL)
  
  x <- sciensano_be(level = level)
  
  if(level==2)
    x$id <- id(x$REGION, iso = "BEL", ds = "sciensano_be", level = level)
  if(level==3)
    x$id <- id(x$PROVINCE, iso = "BEL", ds = "sciensano_be", level = level)
  
  return(x)
  
}