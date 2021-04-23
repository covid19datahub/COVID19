LTU <- function(level, cache){
  
  # download
  x <- covid19lt_git(cache = cache, level = level)

  # id  
  if(level==2)
    x$id <- id(x$admin2, iso = "LTU", ds = "covid19lt_git", level = level)
  if(level==3)
    x$id <- id(x$admin3, iso = "LTU", ds = "covid19lt_git", level = level)
  
  # return
  return(x)
  
}

