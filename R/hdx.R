
hdx <- function(cache, level){
  # author: Federico Lo Giudice
  
  # Provided by : HUMANITARIAN DATA EXCHANGE - https://data.humdata.org/dataset/haiti-covid-19-subnational-cases
  # Source : Ministry of Public Health and Population of Haiti
  
  # download
  url <- "https://proxy.hxlstandard.org/data/738954/download/haiti-covid-19-subnational-data.csv"
  x   <- read.csv(url, cache=cache, encoding = "UTF-8")[-1,]
  
  # date
  x$date <- as.Date(x$Date, format="%d-%m-%Y")
  
  if(level == 1) {
    # group
    xx <- x %>%
      dplyr::group_by(date,) %>%
      dplyr::summarise(
        confirmed = sum(as.integer(Confirmed.cases)),
        deaths    = sum(as.integer(Deaths)) ) %>%
      dplyr::arrange(date) %>%
      dplyr::mutate(
        confirmed = cumsum(confirmed),
        deaths    = cumsum(deaths) )
  }
  if(level == 2) {
    x$state <- x$`Département`
    # group
    xx <- x %>%
      dplyr::group_by(date,state) %>%
      dplyr::summarise(
        confirmed = sum(as.integer(Confirmed.cases)),
        deaths    = sum(as.integer(Deaths)) ) %>%
      dplyr::arrange(date) %>%
      dplyr::mutate(
        confirmed = cumsum(confirmed),
        deaths    = cumsum(deaths) )
  }
  
  # return
  return(xx)
  
}

