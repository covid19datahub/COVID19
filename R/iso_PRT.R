PRT <- function(level, cache) {
  # author: Martin Benes <martinbenes1996@gmail.com>
  
  # fallback
  if(level > 2) 
    return(NULL) 
  
  # download
  x <- dssg_pt(level = level, cache = cache)
  
  # id
  if(level == 2) {
    x$id <- id(x$region, iso = "PRT", ds = "dssg_pt", level = level)
  }
  
  # return
  return(x)
}