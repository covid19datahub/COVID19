IND <- function(level, cache){
  # Author: Rijin Baby
  
  # fallback
  if(level>2)
    return(NULL)
  
  # download
  x <- covid19india_org(cache = cache, level = level) 

  # id  
  if(level==2)
    x$id <- id(x$state, iso = "IND", ds = "covid19india_org", level = level)

  # return
  return(x)
  
}
