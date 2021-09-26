LIE <- function(level, cache){

  # fallback
  if(level>1)
    return(NULL)

  # download
  x <- admin_ch(id = "FL", level = 1)
  y <- openzh_git(id = "FL", cache = cache)
  
  # merge
  y <- y[,c("date", "hosp", "recovered")]
  x <- merge(x, y, by = c("date"), all = TRUE)
  
  # return
  return(x)

}

