#' Coronavirus COVID-19 data - Italy
#'
#' Tidy format dataset of the 2019 Novel Coronavirus COVID-19 (2019-nCoV) epidemic.
#' Italian data by country, state (regions) or city.
#' The data are downloaded in real-time, processed and merged with demographic indicators (\code{\link{IT}}).
#'
#' @seealso \code{\link{world}}, \code{\link{diamond}}, \code{\link{switzerland}}, \code{\link{liechtenstein}}
#'
#' @param type one of \code{country} (data by country), \code{state} (data by region) or \code{city} (data by city). Default \code{state}, data by region.
#'
#' @details
#' Data pulled from the \href{https://github.com/pcm-dpc/COVID-19}{repository} for the
#' 2019 Novel Coronavirus by Ministero della Salute, \href{http://www.protezionecivile.it/}{Dipartimento della Protezione Civile, Italia}.
#'
#' @return Return of the internal function \code{\link{covid19}}
#'
#' @examples
#' # data by country
#' x <- italy("country")
#'
#' # data by region
#' x <- italy("state")
#'
#' # data by city
#' x <- italy("city")
#'
#' @export
#'
italy <- function(type = "state"){

  # check
  if(!(type %in% c("country","state","city")))
    stop("type must be one of 'country', 'state', 'city'")

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
  x   <- utils::read.csv(url)

  # dates
  d <- as.Date(x$data, format = "%Y-%m-%d %H:%M:%S")
  if(all(is.na(d)))
    d <- as.Date(x$data, format = "%Y-%m-%dT%H:%M:%S")
  x$data <- d

  # formatting
  x$date      <- x$data
  x$country   <- factor("Italy")
  x$state     <- x$denominazione_regione
  x$city      <- x$denominazione_provincia
  x$lat       <- x$lat
  x$lng       <- x$long
  x$tests     <- x$tamponi
  x$confirmed <- x$totale_casi
  x$deaths    <- x$deceduti

  # filter latlng
  x <- x[!is.na(x$date),]
  if(!is.null(x$lat) & !is.null(x$lng))
    x <- x[x$lat!=0 | x$lng!=0,]

  # population info
  x <- merge(x, COVID19::IT, by.x = type, by.y = "id", all.x = TRUE)

  # return
  return(covid19(x))

}
