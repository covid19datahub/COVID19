GPC <- function(level, cache){

  # fallback
  if(level>1)
    return(NULL)

  # download
  x <- jhuCSSE(file = "global", cache = cache)

  # clean
  x <- x[which(x$state=="Grand Princess"),]
  x$country <- "Grand Princess"
  x$state   <- NA

  # return
  return(x)

}
