DPC <- function(level, cache){

  # fallback
  if(level>1)
    return(NULL)

  # download
  x <- jhucsse_git(file = "global", cache = cache, level = level, country = "Diamond Princess")

  # wikipedia data
  x <- fix(x, iso = "DPC")

  # return
  return(x)

}
