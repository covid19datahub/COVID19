GBR <- function(level, cache){
  
  # fallback
  if(level>3)
    return(NULL)
  
  # download
  x <- gov_uk(cache = cache, level = level)
  
  # level
  if(level==2){
  
    # id
    x$id <- id(x$code, iso = "GBR", ds = "gov_uk", level = level)
    
    # jhu
    y    <- jhucsse_git(file = "global", cache = cache, level = level, country = "United Kingdom") 
    y$id <- id(y$state, iso = "GBR", ds = "jhucsse_git", level = level)
  
    # add
    x <- dplyr::bind_rows(x, y)
      
  }
  if(level==3){
    
    # id
    x$id <- id(x$code, iso = "GBR", ds = "gov_uk", level = level)
    
  }
    
  # return
  return(x)
  
}