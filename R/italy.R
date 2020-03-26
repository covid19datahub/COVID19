#' Coronavirus COVID-19 Data - Italy
#'
#' Download the Italian COVID-19 dataset from the official repository of Dipartimento della Protezione Civile.
#'
#' @param type one of \code{"country"} (data by country), \code{"state"} (data by state) or \code{"city"} (data by city). Default \code{"country"}.
#'
#' @details See \url{https://github.com/pcm-dpc/COVID-19}
#'
#' @source \url{https://github.com/pcm-dpc/COVID-19}
#'
#' @return data.frame. See \url{https://github.com/pcm-dpc/COVID-19}
#'
#' @examples
#' \dontrun{
#'
#' # data by country
#' x <- italy()
#'
#' # data by state
#' x <- italy("state")
#'
#' # data by city
#' x <- italy("city")
#'
#' }
#'
#' @importFrom utils read.csv
#'
#' @export
#'
italy <- function(type = "state"){

  repo <- "https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/"

  if(type=="country")
    url <- "dati-andamento-nazionale/dpc-covid19-ita-andamento-nazionale.csv"
  else if(type=="state")
    url <- "dati-regioni/dpc-covid19-ita-regioni.csv"
  else if(type=="city")
    url <- "dati-province/dpc-covid19-ita-province.csv"
  else
    stop("type must be one of 'country', 'state', 'city'")

  url       <- sprintf("%s/%s", repo, url)
  data      <- read.csv(url)

  d <- as.Date(data$data, format = "%Y-%m-%d %H:%M:%S")
  if(all(is.na(d)))
    d <- as.Date(data$data, format = "%Y-%m-%dT%H:%M:%S")
  data$data <- d

  data$date      <- data$data
  data$country   <- data$stato
  data$state     <- data$denominazione_regione
  data$city      <- data$denominazione_provincia
  data$lat       <- data$lat
  data$lng       <- data$long
  data$tests     <- data$tamponi
  data$confirmed <- data$totale_casi
  data$deaths    <- data$deceduti

  return(clean(data))

}
