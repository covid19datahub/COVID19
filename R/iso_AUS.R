AUS <- function(level, cache){
  
  # fallback
  if(level>2)
    return(NULL)
  
  # download
  x <- covid19au_git(level = level, cache = cache)
  
  # level
  if(level==2){
  
    # id
    x$id <- id(x$administrative_area_level_2, iso = "AUS", ds = "covid19au_git", level = level)
      
  }
    
  # return
  return(x)
  
}