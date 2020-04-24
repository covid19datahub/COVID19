covid19za <- function(cache, level){
  # Author: Martin Benes
  
  #  Source: Data Science for Social Impact research group, University of Pretoria (Dr. Vukosi Marivate)
  # https://github.com/dsfsi/covid19za
  confirmed.url <- "https://raw.githubusercontent.com/dsfsi/covid19za/master/data/covid19za_provincial_cumulative_timeline_confirmed.csv"
  tests.url <- "https://raw.githubusercontent.com/dsfsi/covid19za/master/data/covid19za_timeline_testing.csv"
  # records of died
  #deaths.url <- "https://raw.githubusercontent.com/dsfsi/covid19za/master/data/covid19za_timeline_deaths.csv"
  
  # download
  confirmed <- read.csv(confirmed.url, cache = cache)
  tests <- read.csv(tests.url, cache = cache)
  #deaths <- read.csv(deaths.url, cache = cache)
  
  # formatting
  colnames(confirmed) <- mapvalues(colnames(confirmed), c(
    'date'  = 'date',
    'total' = 'confirmed'
  ))
  colnames(tests) <- mapvalues(colnames(tests), c(
    'date'             = 'date',
    'cumulative_tests' = 'tests',
    'recovered'        = 'recovered',
    'hospitalisation'  = 'hospitalized',
    'critical_icu'     = 'icu',
    'ventilation'      = 'vent',
    'deaths'           = 'deaths'
  )) # contains other more interesting variables, but mostly empty
  
  # date
  confirmed$date <- as.Date(confirmed$date, format="%d-%m-%Y")
  tests$date <- as.Date(tests$date, format="%d-%m-%Y")
  # join by date
  x <- merge(confirmed,tests,by=c("date"), all=T)
  
  
  # switch level
  if(level==1){
    x$country <- "ZAF"
  }
  if(level==2){
    # remove country columns
    x <- subset(x,select=-c(tests,recovered,hospitalized,icu,deaths,vent))
    
    # state to single column
    x <- x %>% tidyr::gather(state, confirmed, EC:WC)
    # sort date
    x <- x %>% dplyr::arrange(date)
    # drop NAs
    x <- x[which(!is.na(x$confirmed)),]
    x[which(x$state == "NW"),]
    
  }
  
  x$country <- "ZAF"

  x$date <- as.Date(x$date, format = "%Y-%m-%d")
  
  # return
  return(x)
}

