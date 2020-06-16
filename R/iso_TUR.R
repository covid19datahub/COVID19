TUR <- function(level, cache){
  # Author: Muhammed Seehan Pengatkundil
  
  # fallback
  if(level>1)
    return(NULL)
  
  # download
  x <- covid19turkey_git(level = level, cache = cache) 
  
  # return
  return(x)
  
}
