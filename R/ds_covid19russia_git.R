covid19russia_git <- function(cache){
  
  # source
  repo <- "https://raw.githubusercontent.com/grwlf/COVID-19_plus_Russia/master/csse_covid_19_data/csse_covid_19_time_series/"
  url  <- "time_series_covid19_confirmed_RU.csv"
  
  # download
  url <- sprintf("%s/%s", repo, url)
  x   <- read.csv(url, cache = cache)
  
  #formatting
  x$country <- x$Country_Region
  x$state   <- x$Province_State
  x$lat     <- x$Lat
  x$lng     <- x$Long_
  
  # reshaping
  cn <- colnames(x)
  by <- c('country','state','lat','lng','Combined_Key')
  cn <- (cn %in% by) | !is.na(as.Date(cn, format = "X%m.%d.%y"))
  
  # date
  x      <- x[,cn] %>% tidyr::pivot_longer(cols = -by, values_to = "confirmed", names_to = "date")
  x$date <- as.Date(x$date, format = "X%m.%d.%y")
  
  # return
  return(x)
  
}
