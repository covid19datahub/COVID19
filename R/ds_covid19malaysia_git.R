covid19malaysia_git <- function(level, cache){
  # Author: Anant Sharma
  
  # download
  url <- "https://raw.githubusercontent.com/anant-procogia/covid-19-dataset/main/malaysia-covid19-dataset.csv"
  x   <- read.csv(url, cache = cache, na.strings = c("", "-")) 
  
  # formatting
  x <- map_data(x, c(
    'date' = 
    'total_tests'   =  'tests',
    'total_cases'   =  'confirmed',
    'total_deaths'  =  'deaths', 
    'recovered'     =  'recovered',
    'icu_patients'  =  'icu', 
    'vent_patients' =  'vent'
  ))
  
  # filter date
  x <- x[!is.na(x$date),]
  x$date <- as.Date(x$date, format = "%d/%m/%Y")
  
  # return
  return(x)
}

