ITA <- function(level, cache){

  # fallback
  if(level>3)
    return(NULL)

  # download
  x <- pcmdpc_git(cache = cache, level = level)

  # id
  if(level==2){
    
    x$id <- id(x$state, iso = "ITA", ds = "pcmdpc_git", level = level)
    
  }
  if(level==3){
    
    y <- ceeds_git(cache = cache) 
    x <- merge(x, y, by = c("date", "city_code"), all = TRUE)
    
    x$id <- id(x$city, iso = "ITA", ds = "pcmdpc_git", level = level)
    
  }
  
  # return
  return(x)

}
