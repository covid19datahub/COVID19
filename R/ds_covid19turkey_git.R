covid19turkey_git <- function(level, cache){
  # Author: Muhammed Seehan Pengatkundil
  
  # download
  url <- "https://raw.githubusercontent.com/ozanerturk/covid19-turkey-api/master/dataset/timeline.csv"
  x   <- read.csv(url, cache = cache, na.strings = c("", "-")) 
  
  # formatting
  x <- map_data(x, c(
    'date'               = 'date',
    'totalTests'         = 'tests',
    'totalCases'         = 'confirmed',
    'totalDeaths'        = 'deaths',
    'totalRecovered'     = 'recovered',
    'totalIntensiveCare' = 'icu',
    'totalIntubated'     = 'vent'
  ))
  
  # filter date
  x <- x[!is.na(x$date),]
  x$date <- as.Date(x$date, format = "%d/%m/%Y")
  
  # return
  return(x)
}

