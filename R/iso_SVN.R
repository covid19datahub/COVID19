SVN <- function(level, cache){
  # Author: Martin Benes
    
  # fallback
  if(level>1)
    return(NULL)
    
  # download
  x <- gov_si(cache = cache, level = level)
  
  # fill old data
  if(level==1)
    x <- covid19fill(x = x, iso = "SVN", level = level, cache = cache)
    
  # return
  return(x)
    
}

