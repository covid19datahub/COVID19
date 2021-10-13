THA <- function(level, ...) {
  # author: Martin Benes <martinbenes1996@gmail.com>
  
  # fallback
  if(level > 2) return(NULL)
  
  # download
  x <- go_th(level = level)
  
  # id
  if(level == 2)
    x$id <- id(x$province, iso = "THA", ds = "go_th", level = level)
  
  # return
  return(x)
  
}