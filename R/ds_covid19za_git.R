covid19za_git <- function(cache, level){
  # Author: Martin Benes
  
  #  Source: Data Science for Social Impact research group, University of Pretoria (Dr. Vukosi Marivate)
  # https://github.com/dsfsi/covid19za
  
  if(level==1){
    
    # download
    url <- "https://raw.githubusercontent.com/dsfsi/covid19za/master/data/covid19za_provincial_cumulative_timeline_confirmed.csv"
    x1  <- read.csv(url, cache = cache)
    
    url <- "https://raw.githubusercontent.com/dsfsi/covid19za/master/data/covid19za_timeline_testing.csv"
    x2   <- read.csv(url, cache = cache)    
    
    # formatting
    x <- merge(x1, x2, by = "date", all = TRUE)
    x <- map_data(x, c(
      'date'             = 'date',
      'cumulative_tests' = 'tests',
      'recovered'        = 'recovered',
      'hospitalisation'  = 'hosp',
      'critical_icu'     = 'icu',
      'ventilation'      = 'vent',
      'deaths'           = 'deaths',
      'total'            = 'confirmed'
    )) 
    
  }
  if(level==2){
    
    # download
    url <- "https://raw.githubusercontent.com/dsfsi/covid19za/master/data/covid19za_provincial_cumulative_timeline_confirmed.csv"
    x   <- read.csv(url, cache = cache)
    
    # map_data
    x <- map_data(x, c("date","EC","FS","GP","KZN","LP","MP","NC","NW","WC"))
    
    # pivot
    by <- "date"
    x  <- x %>% 
      tidyr::pivot_longer(cols = -by, values_to = "confirmed", names_to = "code")
    
  }

  # date
  x$date <- as.Date(x$date, format = "%d-%m-%Y")
  
  # return
  return(x)
}

