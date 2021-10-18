AUS <- function(level, ...){
  if(level>2) return(NULL)
  
  x <- covid19au_git(level = level)

  if(level==2)
    x$id <- id(x$administrative_area_level_2, iso = "AUS", ds = "covid19au_git", level = level)
    
  return(x)
  
}