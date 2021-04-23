UKR <- function(level, cache){
  
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
    x <- minshall_git(iso = "UKR", level = level)
    
    # id
    x$id <- id(x$admin2, iso = "UKR", ds = "minshall_git", level = level)
    
  }
  
  # return
  return(x)
  
}

