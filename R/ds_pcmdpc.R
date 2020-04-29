pcmdpc <- function(cache, level){

  # source
  repo <- "https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/"
  urls <- c(
    "dati-andamento-nazionale/dpc-covid19-ita-andamento-nazionale.csv",
    "dati-regioni/dpc-covid19-ita-regioni.csv",
    "dati-province/dpc-covid19-ita-province.csv"
  )

  # download
  url <- sprintf("%s/%s", repo, urls[level])
  x   <- read.csv(url, cache = cache)

  # date
  d <- as.Date(x$data, format = "%Y-%m-%d %H:%M:%S")
  if(all(is.na(d)))
    d <- as.Date(x$data, format = "%Y-%m-%dT%H:%M:%S")
  x$date <- d

  # formatting
  x$state        <- x$denominazione_regione
  x$city         <- x$denominazione_provincia
  x$lat          <- x$lat
  x$lng          <- x$long
  x$tests        <- x$tamponi
  x$confirmed    <- x$totale_casi
  x$deaths       <- x$deceduti
  x$recovered    <- x$dimessi_guariti
  x$hosp         <- x$totale_ospedalizzati
  x$icu          <- x$terapia_intensiva

  # filter
  if(!is.null(x$lat) & !is.null(x$lng))
    x <- x[x$lat!=0 | x$lng!=0,]
  
  # return
  return(x)

}
