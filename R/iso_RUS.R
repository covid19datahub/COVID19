RUS <- function(level, cache){
  
  # fallback
  if(level>2)
    return(NULL)
  
  # level
  if(level==1){
   
    # fallback to worldwide data
    x <- NULL
     
  }
  if(level==2){

    # download
    x <- openRU(cache = cache)
    
    # id
    x$id <- x$state
    
  }
  
  # return
  return(x)
  
}

