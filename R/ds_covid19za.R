covid19za <- function(cache, level){
  # Author: Martin Benes
  
  #  Source: Data Science for Social Impact research group, University of Pretoria (Dr. Vukosi Marivate)
  # https://github.com/dsfsi/covid19za
  
  if(level==1){
    
    url <- "https://raw.githubusercontent.com/dsfsi/covid19za/master/data/covid19za_provincial_cumulative_timeline_confirmed.csv"
    x   <- read.csv(url, cache = cache)
    
    y <- x[,c('date','total')]
    
    url <- "https://raw.githubusercontent.com/dsfsi/covid19za/master/data/covid19za_timeline_testing.csv"
    x   <- read.csv(url, cache = cache)    
    
    x <- merge(x, y, by = "date", all = TRUE)
    
    colnames(x) <- mapvalues(colnames(x), c(
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
    
    url <- "https://raw.githubusercontent.com/dsfsi/covid19za/master/data/covid19za_provincial_cumulative_timeline_confirmed.csv"
    x   <- read.csv(url, cache = cache)
    
    code <- c("EC","FS","GP","KZN","LP","MP","NC","NW","WC")
    x <- x[,c('date',code)]
    
    by <- "date"
    x  <- x %>% 
      tidyr::pivot_longer(cols = -by, values_to = "confirmed", names_to = "code")
    
  }

  # date
  x$date <- as.Date(x$date, format = "%d-%m-%Y")
  
  # return
  return(x)
}

