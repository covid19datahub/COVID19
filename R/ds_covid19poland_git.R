covid19poland_git <- function(level, cache){
  
  # source
  repo    <- "https://raw.githubusercontent.com/martinbenes1996/covid19poland/master/data/"
  url     <- "data.csv"
  last30d <- "last30d.csv"
  
  # download
  url <- sprintf("%s/%s", repo, url)
  x   <- read.csv(url, cache = cache)
  
  # format
  x$date <- as.Date(x$date)
  
  # group
  x <- x <- map_data(x, c(
    "date"  = "date",
    "NUTS2" = "state",
    "NUTS3" = "district"
  ))
  
  if(level == 1)
    x <- x %>%
      dplyr::count(date, name="deaths")
  if(level == 2)
    x <- x %>%
      tidyr::drop_na(state) %>%
      dplyr::count(date,state, name="deaths")
  if(level == 3)
    x <- x %>%
      tidyr::drop_na(state, district) %>%
      dplyr::count(date,state,district, name="deaths")
    

  # return
  return(x)
  
}

covid19poland_git(3,F)
