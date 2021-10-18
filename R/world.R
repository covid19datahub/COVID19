world <- function(level, cache){
  
  if(level>1) return(NULL)

  # download
  x <- jhucsse_git(file = "global", cache = cache, level = level)
  
  # iso
  x$iso_alpha_3 <- id(x$country, iso = "ISO", ds = "jhucsse_git", level = 1)
  
  # id
  x$id <- x$iso_alpha_3
  
  # tests
  o <- ourworldindata_org()  
  x <- merge(x, o, by = c('date','iso_alpha_3'), all.x = TRUE)

  # return
  return(x)

}
