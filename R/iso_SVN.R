SVN <- function(level, cache){
  # Author: Martin Benes
    
  # fallback
  if(level>1)
    return(NULL)
    
  # download
  x <- ministrstvoZaZdravje(cache = cache, level = level)
    
  # return
  return(x)
    
}

