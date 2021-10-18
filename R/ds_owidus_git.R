owidus_git <- function(level){
  if(level>2) return(NULL)
  
  # download
  url <- "https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/vaccinations/us_state_vaccinations.csv"
  x   <- read.csv(url)
  
  # formatting
  x <- map_data(x, c(
    'date',
    'location'           = 'state',
    'total_vaccinations' = 'vaccines'
  ))
  
  # drop
  x <- x[which(!x$state %in% c(
    "Bureau of Prisons", "Dept of Defense", "Federated States of Micronesia", 
    "Indian Health Svc", "Long Term Care", "Marshall Islands", "Republic of Palau", 
    "United States", "Veterans Health")),]
  
  # date
  x$date <- as.Date(x$date)
  
  # return
  return(x)
    
}

