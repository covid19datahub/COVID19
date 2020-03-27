#' Coronavirus COVID-19 Data - Italy
#'
#' Tidy format dataset of the 2019 Novel Coronavirus COVID-19 (2019-nCoV) epidemic.
#' Italian data by country, state (regions) or city.
#' The data are downloaded in real-time, processed and merged with demographic indicators (\code{\link{IT}}).
#'
#' @seealso \code{\link{world}}, \code{\link{diamond}}, \code{\link{switzerland}}
#'
#' @param type one of \code{country} (data by country), \code{state} (data by region) or \code{city} (data by city). Default \code{state}, data by region.
#'
#' @details
#' Data pulled from the \href{https://github.com/pcm-dpc/COVID-19}{repository} for the
#' 2019 Novel Coronavirus by Ministero della Salute, \href{http://www.protezionecivile.it/}{Dipartimento della Protezione Civile, Italia}.
#'
#' @return Tidy format \code{tibble} (\code{data.frame}) grouped by id:
#' \describe{
#'  \item{id}{id in the form "country|state|city".}
#'  \item{date}{date.}
#'  \item{country}{administrative area level 1.}
#'  \item{state}{administrative area level 2.}
#'  \item{city}{administrative area level 3.}
#'  \item{lat}{latitude.}
#'  \item{lng}{longitude.}
#'  \item{deaths}{the number of deaths.}
#'  \item{confirmed}{the number of cases.}
#'  \item{tests}{the number of tests.}
#'  \item{deaths_new}{daily increase in the number of deaths.}
#'  \item{confirmed_new}{daily increase in the number of cases.}
#'  \item{tests_new}{daily increase in the number of tests.}
#'  \item{pop}{total population.}
#'  \item{pop_14}{population ages 0-14 (\% of total population).}
#'  \item{pop_15_64}{population ages 15-64 (\% of total population).}
#'  \item{pop_65}{population ages 65+ (\% of total population).}
#'  \item{pop_age}{median age of population.}
#'  \item{pop_density}{population density per km2.}
#'  \item{pop_death_rate}{population mortality rate.}
#' }
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
  url       <- sprintf("%s/%s", repo, url)
  data      <- utils::read.csv(url)

  # dates
  d <- as.Date(data$data, format = "%Y-%m-%d %H:%M:%S")
  if(all(is.na(d)))
    d <- as.Date(data$data, format = "%Y-%m-%dT%H:%M:%S")
  data$data <- d

  # formatting
  data$date      <- data$data
  data$country   <- factor("Italy")
  data$state     <- data$denominazione_regione
  data$city      <- data$denominazione_provincia
  data$lat       <- data$lat
  data$lng       <- data$long
  data$tests     <- data$tamponi
  data$confirmed <- data$totale_casi
  data$deaths    <- data$deceduti

  # population info
  data <- merge(data, COVID19::IT, by.x = type, by.y = "id", all.x = TRUE)

  # return
  return(clean(data))

}
