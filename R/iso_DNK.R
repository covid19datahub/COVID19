DNK <- function(level, ...) {
 
  # fallback
  if(level==1)
    return(NULL)
  
  x <- ssi_dk(level = level)
  
  if(level==2)
    x$id <- id(x$region, iso = "DNK", ds = "ssi_dk", level = level)
  
  return(x)
  
}