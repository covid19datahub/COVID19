JPN <- function(level, cache){

  # fallback
  if(level>2)
    return(NULL)

  # level
  if(level==1){
  
    # download
    x <- covid19jp_git(cache = cache, level = level)
    
  }
  if(level==2){
    
    # download
    x <- covid19jp_git(cache = cache, level = level)
    
    # id
    x$id <- id(x$jis_code, iso = "JPN", ds = "covid19jp_git", level = level)
    
  }

  # return
  return(x)

}

