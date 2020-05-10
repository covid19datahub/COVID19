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
    x <- covid19russia_git(cache = cache)
    
    # id
    x$id <- id(x$state, iso = "RUS", ds = "covid19russia_git", level = level)
    
  }
  
  # return
  return(x)
  
}

