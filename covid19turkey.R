covid19turkey <- function(level, cache){
  
  url <- "https://raw.githubusercontent.com/ozanerturk/covid19-turkey-api/master/dataset/timeline.csv"
  
  x   <- read.csv(url) 
  x <- x[ , -which(names(x)%in%c("tests", "cases", "deaths", "recovered"))]
  
  covid19turkey <- covid19turkey[ ,c(1 ,2 ,3 ,4 ,7 ,6 ,5 )]
  
  # formatting
  x <- map_data(x, c( 
    'date',              
    'totalTests'         = 'tests',
    'totalCases'         = 'confirmed',
    'totalDeaths'        = 'deaths',
    'totalRecovered'     = 'recovered',
    'totalIntensiveCare' = 'icu',
    'totalIntubated'     = 'vent'
  ))
  
  # filter date
  x <- x[!is.na(x$date),]
  #x$date <- as.Date(x$date, format = "%d/%m/%Y")
  
  return(x)
}
