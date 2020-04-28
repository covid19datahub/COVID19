CHE <- function(level, cache){

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
    x <- openZH(cache = cache, id = "CH")
    
    # id
    x$id <- id(x$code)
    
  }

  # return
  return(x)

}

