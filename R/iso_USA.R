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
    x <- covidtracking(cache = cache, level = level) 
    
    # id
    x$id <- id(x$state)
    
  }
  if(level==3){
    
    # download
    x <- jhuCSSE(file = "US", cache = cache, level = level, id = "USA")
    
    # id
    x$id <- id(x$state, x$city)
    
  }
    
  # return
  return(x)

}
