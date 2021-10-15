CUW <- function(level, ...){
  
  if(level>1) return(NULL)
  
  x <- jhucsse_git(file = "global", cache = TRUE, level = 2, state = "Curacao")
  
  return(x)
  
}