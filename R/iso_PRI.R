PRI <- function(level, cache){

  # fallback
  if(level>2)
    return(NULL)

  # level
  if(level==1){
   
    # download
    x <- nytimes_git(cache = cache, level = 2, fips = 72)
    
  }
  if(level==2){
    
    # download
    x <- jhucsse_git(file = "US", cache = cache, level = 3, country = "PRI")
    
    # id
    x$id <- id(x$fips, iso = "PRI", ds = "jhucsse_git", level = level)
    
  }
  
  # return
  return(x)

}
