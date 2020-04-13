openZH <- function(cache, id = NULL){

  # source
  repo <- "https://raw.githubusercontent.com/openZH/covid_19/master/"
  url  <- "COVID19_Fallzahlen_CH_total_v2.csv"

  # download
  url <- sprintf("%s/%s", repo, url)
  x   <- read.csv(url, cache = cache)

  # date
  x$date <- as.Date(x$date, format = "%Y-%m-%d")

  # formatting
  x$code      <- x$abbreviation_canton_and_fl
  x$confirmed <- x$ncumul_conf
  x$tests     <- x$ncumul_tested
  x$deaths    <- x$ncumul_deceased
  x$recovered <- x$ncumul_released
  x$hosp      <- x$current_hosp
  x$icu       <- x$current_icu
  x$vent      <- x$current_vent

  # filter
  if(!is.null(id)){
    if(id=="FL")
      x <- x[x$code=="FL",,drop=FALSE]
    if(id=="CH")
      x <- x[x$code!="FL",,drop=FALSE]
  }

  # return
  return(x)

}
