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
    x <- covidtracking_com(cache = cache) 
    
    # id
    x$id <- id(x$state, iso = "USA", ds = "covidtracking_com", level = level)
    
  }
  if(level==3){
    
    # JHU
    x <- jhucsse_git(file = "US", cache = cache, level = level, country = "USA")
    x$id <- id(x$id, iso = "USA", ds = "jhucsse_git", level = level)
    
    # NyTimes
    y <- nytimes_git(cache = cache, level = level)
    y$id <- id(y$fips, iso = "USA", ds = "nytimes_git", level = level)
    
    # combine
    x <- x[!(x$fips %in% y$fips),]
    x <- bind_rows(x, y)
    
  }
    
  # return
  return(x)

}
