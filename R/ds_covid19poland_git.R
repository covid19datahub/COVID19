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
  x <- x <- map_data(x, c(
    "date"  = "date",
    "NUTS2" = "state",
    "NUTS3" = "district"
  ))
  x <- x %>% dplyr::arrange(date)
  
  # group
  if(level == 1) {
    x <- x %>%
      dplyr::group_by(date) %>%
      dplyr::tally(name = "deaths") %>%
      dplyr::mutate(deaths = cumsum(deaths))
  }
  if(level == 2) {
    x <- x %>%
      tidyr::drop_na(state) %>%
      dplyr::group_by(date, state) %>%
      dplyr::tally(name = "deaths") %>%
      dplyr::group_by(state) %>%
      dplyr::arrange(date) %>%
      dplyr::mutate(deaths = cumsum(deaths))
  }
  if(level == 3) {
    x <- x %>%
      tidyr::drop_na(state, district) %>%
      dplyr::group_by(date, state, district) %>%
      dplyr::tally(name = "deaths") %>%
      dplyr::group_by(state, district) %>%
      dplyr::arrange(date) %>%
      dplyr::mutate(deaths = cumsum(deaths))
  }

  # return
  return(x)
}
