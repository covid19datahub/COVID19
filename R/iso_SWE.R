SWE <- function(level, cache){
  # Author: Martin Benes
  
  # fallback
  if(level>2)
    return(NULL)

  # download
  x <- oppnadata_se(cache = cache, level = level)

  # id
  if(level==2)
    x$id <- id(x$state, iso = "SWE", ds = "oppnadata_se", level = level) 
  
  # return
  return(x)
  
}

