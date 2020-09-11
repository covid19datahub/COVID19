covid19poland_git <- function(level, cache){
  
  # source
  repo     <- "https://raw.githubusercontent.com/martinbenes1996/covid19poland/master/data/"
  url      <- "data.csv"
  test.url <- "tests.csv"
  
  # download
  url      <- sprintf("%s/%s", repo, url)
  test.url <- sprintf("%s/%s", repo, test.url)
  x        <- read.csv(url, cache = cache)
  x.test   <- read.csv(test.url, cache = cache)
  
  # format
  x$date <- as.Date(x$date)
  x <- map_data(x, c(
    "date"  = "date",
    "NUTS2" = "state",
    "NUTS3" = "district"
  ))
  x <- x %>% dplyr::arrange(date)
  # format test
  x.test$date <- as.Date(x.test$date)
  x.test <- map_data(x.test, c(
    "date"   = "date",
    "region" = "state",
    "tests"  = "tests"
  ))
  x.test <- x.test %>%
    dplyr::filter(!is.na(state)) %>%
    dplyr::arrange(date, state)
    
  
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
    
    x <- x %>%
      dplyr::full_join(x.test, by=c("date","state")) %>%
      dplyr::arrange(date, state)
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
