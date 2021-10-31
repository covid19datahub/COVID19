PAK <- function(level, ...){
  
  # fallback
  if(level>2)
    return(NULL)
  
  # fallback to worldwide data
  if(level==1)
    x <- NULL
  
  # download already with ids
  if(level==2)
    x <- github.cssegisanddata.covid19unified(iso = "PAK", level = level)
  
  # return
  return(x)
  
}
