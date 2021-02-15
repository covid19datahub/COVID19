owidus_git <- function(cache){
  
  url <- "https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/vaccinations/us_state_vaccinations.csv"
  x   <- read.csv(url, cache = cache)
  
  # formatting
  x <- map_data(x, c(
    'date',
    'location'           = 'state',
    'total_vaccinations' = 'vaccines'
  ))
  
  # date
  x$date <- as.Date(x$date)
  
  # return
  return(x)
    
}

