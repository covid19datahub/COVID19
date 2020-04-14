pcmdpc <- function(cache, file){

  # source
  repo <- "https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/"

  if(file=="nazione")
    url <- "dati-andamento-nazionale/dpc-covid19-ita-andamento-nazionale.csv"
  else if(file=="regioni")
    url <- "dati-regioni/dpc-covid19-ita-regioni.csv"
  else if(file=="province")
    url <- "dati-province/dpc-covid19-ita-province.csv"
  else
    stop("file not supported")

  # download
  url <- sprintf("%s/%s", repo, url)
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

  # return
  return(x)

}
