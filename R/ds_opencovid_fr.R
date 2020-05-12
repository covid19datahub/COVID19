opencovid_fr <- function(cache, level = 1){
  # Montemurro Paolo 11 05 2020
  
  # Download data
  url <- "https://raw.githubusercontent.com/opencovid19-fr/data/master/dist/chiffres-cles.csv"
  x   <- read.csv(url, cache = cache) 
  
  # Formatting columns
  x$deces <- x$deces + x$deces_ehpad #Deaths + Deaths in elderly homes
  
  x <- map_data(x, c(
    'date',
    'depistes'      = 'tests',
    'cas_confirmes' = 'confirmed',
    'deces'         = 'deaths',
    'gueris'        = 'recovered',
    'hospitalises'  = 'hosp',
    'reanimation'   = 'icu',
    'granularite',
    'maille_code',
    'maille_nom'
  ))

  # Switch by level
  if(level==1)
    x<- x[x$granularite=="pays",]  
  if(level==2)
    x<- x[x$granularite %in% c("region", "collectivite-outremer"),]
  if(level==3)
    x<- x[x$granularite=="departement",]
  
  # Cleaning
  x <- x %>% 
    distinct(date, maille_code, .keep_all = TRUE) # Keep only one observation by date
  
  # Date
  x$date <- as.Date(x$date)
  
  # Done!
  return(x)
  
}
