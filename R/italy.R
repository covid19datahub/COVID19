#' Italy
#'
#' Tidy format dataset of the 2019 Novel Coronavirus COVID-19 (2019-nCoV) epidemic.
#' Italian data by country, state (regions) or city.
#'
#' @param type one of \code{country} (data by country), \code{state} (data by region) or \code{city} (data by city). Default \code{state}, data by region.
#' @param raw logical. Skip data cleaning? Default \code{FALSE}.
#'
#' @details
#' See \href{https://github.com/emanuele-guidotti/COVID19}{data sources}
#'
#' @return Grouped \code{tibble} (\code{data.frame}). \href{https://github.com/emanuele-guidotti/COVID19}{More info}
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
italy <- function(type = "state", raw = FALSE){

  # check
  if(!(type %in% c("country","state","city")))
    stop("type must be one of 'country', 'state', 'city'")

  # download
  x <- pcmdpc(type)

  # id: see https://github.com/emanuele-guidotti/COVID19/tree/master/inst/extdata/db
  x$id <- x[[type]]

  # return
  return(covid19(x, id = "it", type = type, raw = raw))

}
