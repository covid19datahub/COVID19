
COL <- function(cache, level){
  
  #author: Federico Lo Giudice
  
  
  # fallback
  if(level>3)
    return(NULL)
  
  # level
  if(level==1){
    
    # fallback to worldwide data
    x <- NULL
    
  }
  
  x <- msps(cache = cache, level = level)
  

  
  # return
  return(x)
  
}

