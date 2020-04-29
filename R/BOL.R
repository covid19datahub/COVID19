#Bolivia Code
BOL <- function(level, cache){
  #Author: Advait Thergaonkar
  
  # fallback
  if(level>1)
    return(NULL)
  
  # download
  bolivia_data <- openBOL(cache = cache, level = level)
  
  # id
  if(level==1)
    bolivia_data$id <- "BOL"
  
  # return
  return(bolivia_data)
  
}
