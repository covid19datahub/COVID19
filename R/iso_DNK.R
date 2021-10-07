DNK <- function(level, ...) {
 
  # fallback
  if(level==1)
    return(NULL)
  
  # download
  x <- ssi_dk(level = level)
  
  # identifiers
  if(level==2)
    x$id <- id(x$region, iso = "DNK", ds = "ssi_dk", level = level)
  if(level==3)
    x$id <- id(x$municipality, iso = "DNK", ds = "ssi_dk", level = level)
  
  # return
  return(x)
  
}