openzh_git <- function(cache, id = NULL){

  # source
  repo <- "https://raw.githubusercontent.com/openZH/covid_19/master/"
  url  <- "COVID19_Fallzahlen_CH_total_v2.csv"

  # download
  url <- sprintf("%s/%s", repo, url)
  x   <- read.csv(url, cache = cache)

  # date
  d <- as.Date(x$date, format = "%Y-%m-%d")
  if(any(na <- is.na(d)))
    d[na] <- as.Date(x$date[na], format = "%d.%m.%Y")
  x$date <- d

  # formatting
  x <- map_data(x, c(
    'date',
    'abbreviation_canton_and_fl' = 'code',
    'ncumul_conf'                = 'confirmed',
    'ncumul_tested'              = 'tests',
    'ncumul_deceased'            = 'deaths',
    'ncumul_released'            = 'recovered',
    'current_hosp'               = 'hosp',
    'current_icu'                = 'icu',
    'current_vent'               = 'vent'  
  ))

  # filter
  if(!is.null(id)){
    if(id=="FL")
      x <- x[which(x$code=="FL"),]
    if(id=="CH")
      x <- x[which(x$code!="FL"),]
  }

  # return
  return(x)

}
