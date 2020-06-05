ceeds_git <- function(cache){

  # source
  url  <- "https://raw.githubusercontent.com/CEEDS-DEMM/COVID-Pro-Dataset/master/deathsItaProv.csv"

  # download
  x   <- read.csv(url, cache = cache)
  
  # formatting
  x <- map_data(x, c(
    'Date'       = 'date',
    'id_prov'    = 'city_code',
    'Tot_deaths' = 'deaths'
  ))
  
  # date
  x$date <- as.Date(x$date, format = "%Y-%m-%d")

  # return
  return(x)

}
