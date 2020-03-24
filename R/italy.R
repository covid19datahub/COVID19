#' Coronavirus COVID-19 Data - Italy
#'
#' Download the Italian COVID-19 dataset from the official repository of Dipartimento della Protezione Civile.
#'
#' @param type one of \code{"country"} (data by country), \code{"region"} (data by region) or \code{"city"} (data by city). Default \code{"country"}.
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
#' # data by region
#' x <- italy("region")
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
italy <- function(type="country"){

  repo <- "https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/"

  if(type=="country")
    url <- "dati-andamento-nazionale/dpc-covid19-ita-andamento-nazionale.csv"
  else if(type=="region")
    url <- "dati-regioni/dpc-covid19-ita-regioni.csv"
  else if(type=="city")
    url <- "dati-province/dpc-covid19-ita-province.csv"
  else
    return(NULL)

  url       <- sprintf("%s/%s", repo, url)
  data      <- read.csv(url)
  data$data <- as.Date(data$data, format = "%Y-%m-%d %H:%M:%S")

  return(data)

}
