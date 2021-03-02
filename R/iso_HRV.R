HRV <- function(level, cache) {
  # Author: Martin Benes
  
  # fallback
  if(level!=2)
    return(NULL)
  
  # download (may fail due to DDOS protection by Cloudflare)
  x <- try(gov_hr(level = level, cache = cache))
  if(class(x)=="try-error")
    return(NULL)
  
  # id
  if(level == 2) {
    
    x$id <- id(x$region, iso = "HRV", ds = "gov_hr", level = level)
  
  }
  
  # return
  return(x)
  
}
