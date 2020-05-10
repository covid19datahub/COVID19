USA <- function(level, cache){

  # fallback
  if(level>3)
    return(NULL)

  # level
  if(level==1){
    
    # fallback to worldwide data
    x <- NULL
    
  }
  if(level==2){

    # download
    x <- covidtracking_com(cache = cache, level = level) 
    
    # id
    x$id <- id(x$state, iso = "USA", ds = "covidtracking_com", level = level)
    
  }
  if(level==3){
    
    # download
    x <- jhucsse_git(file = "US", cache = cache, level = level, country = "USA")
    
    # id
    x$id <- id(x$id, iso = "USA", ds = "jhucsse_git", level = level)
    
  }
    
  # return
  return(x)

}
