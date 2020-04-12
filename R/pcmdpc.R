pcmdpc <- function(type){

  # source
  repo <- "https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/"

  if(type=="country")
    url <- "dati-andamento-nazionale/dpc-covid19-ita-andamento-nazionale.csv"
  else if(type=="state")
    url <- "dati-regioni/dpc-covid19-ita-regioni.csv"
  else if(type=="city")
    url <- "dati-province/dpc-covid19-ita-province.csv"

  # download
  url <- sprintf("%s/%s", repo, url)
  data   <- utils::read.csv(url)

  # dates
  d <- as.Date(data$data, format = "%Y-%m-%d %H:%M:%S")
  if(all(is.na(d)))
    d <- as.Date(data$data, format = "%Y-%m-%dT%H:%M:%S")
  data$data <- d

  # formatting
  data$date      <- data$data
  data$country   <- "Italy"
  data$state     <- data$denominazione_regione
  data$city      <- data$denominazione_provincia
  data$lat       <- data$lat
  data$lng       <- data$long
  data$tests     <- data$tamponi
  data$confirmed <- data$totale_casi
  data$deaths    <- data$deceduti

  # filter latlng
  data <- data[!is.na(data$date),]
  if(!is.null(data$lat) & !is.null(data$lng))
    data <- data[data$lat!=0 | data$lng!=0,]

  # return
  return(data)

}
