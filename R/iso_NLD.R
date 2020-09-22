NLD <- function(level, cache) {
  
  # fallback
  if(level > 3) return(NULL)
  
  # download
  x <- rivm_nl(level, cache)
  
  # id
  if(level == 2)
    x$id <- id(x$province, iso = "NLD", ds = "rivm_nl", level = level)
  if(level == 3)
    x$id <- id(x$municipality, iso = "NLD", ds = "rivm_nl", level = level)
  
  # return
  return(x)
}