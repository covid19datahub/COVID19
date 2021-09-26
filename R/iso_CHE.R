CHE <- function(level, cache){

  # fallback
  if(level>2)
    return(NULL)

  # download
  x <- admin_ch(id = "CH", level = level)
    
  # merge
  if(level==2){
    
    y <- openzh_git(id = "CH", cache = cache)
    y <- y[, c("code", "date", "recovered", "vent")]
      
    y$id <- id(y$code, iso = "CHE", ds = "openzh_git", level = level)
    x$id <- id(x$code, iso = "CHE", ds = "admin_ch", level = level)
  
    x <- merge(x, y, by = c("id", "date"), all = TRUE)
      
  }

  # return
  return(x)

}

