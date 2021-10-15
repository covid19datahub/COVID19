UKR <- function(level, ...){
  
  # fallback
  if(level>2)
    return(NULL)
  
  # fallback to worldwide data
  if(level==1)
    x <- NULL
  
  # download already with ids
  if(level==2)
    x <- jhunified_git(iso = "UKR", level = level)
  
  # return
  return(x)
  
}
