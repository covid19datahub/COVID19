DPC <- function(level, cache){

  # fallback
  if(level>1)
    return(NULL)

  # download
  x <- jhuCSSE(file = "global", cache = cache, level = level, id = "Diamond Princess")

  # wikipedia data
  x$date <- as.character(x$date)
  x <- x %>% dplyr::bind_rows(fix('DPC'))
  x <- x[!duplicated(x$date, fromLast = TRUE),]
  x <- tidyr::fill(x, "country", .direction = "downup")
  x$date <- as.Date(x$date)

  # return
  return(x)

}
