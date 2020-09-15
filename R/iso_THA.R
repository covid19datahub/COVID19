THA <- function(level, cache) {
  # author: Martin Benes <martinbenes1996@gmail.com>
  
  # fallback
  if(level > 2) return(NULL)
  
  # download
  x <- sotho_tha(level, cache)
  
  # id
  if(level == 2)
    x$id <- id(x$province, iso = "THA", ds = "sotho_tha", level = level)
  
  # return
  return(x)
  
}