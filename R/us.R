#' United States
#'
#' Tidy format dataset of the 2019 Novel Coronavirus COVID-19 (2019-nCoV) epidemic.
#' US data by country or state.
#'
#' @param type one of \code{country} (data by country), \code{state} (data by state), \code{city} (data by city). Default \code{state}, data by state.
#' @param raw logical. Skip data cleaning? Default \code{FALSE}.
#'
#' @details
#' See \href{https://github.com/emanuele-guidotti/COVID19}{data sources}
#'
#' @return Grouped \code{tibble} (\code{data.frame}). \href{https://github.com/emanuele-guidotti/COVID19}{More info}
#'
#' @examples
#' \dontrun{
#' # data by country
#' x <- us("country")
#'
#' # data by state
#' x <- us("state")
#'
#' #' # data by city
#' x <- us("city")
#' }
#' @export
#'
us <- function(type = "state", raw = FALSE){

  # check
  if(!(type %in% c("country","state","city")))
    stop("type must be one of 'country', 'state', 'city'")

  # download
  x <- jhuCSSE("US")

  # clean
  x <- x[!(x$state %in% c("Grand Princess","Diamond Princess")),]

  # bindings
  country <- state <- date <- confirmed <- deaths <- tests <- NULL

  # group by
  if(type=="country"){
    x <- x %>%
      dplyr::group_by(country, date)
  }
  if(type=="state"){
    x <- x %>%
      dplyr::group_by(country, state, date)
  }

  # aggregate
  if(type %in% c("country","state")){

    x <- x %>%
      dplyr::summarize(confirmed = sum(confirmed, na.rm = TRUE),
                       deaths = sum(deaths, na.rm = TRUE),
                       tests = sum(tests, na.rm = TRUE))

  }

  # id: see https://github.com/emanuele-guidotti/COVID19/tree/master/inst/extdata/db
  if(type=="city")
    x$id <- paste(x$city, x$state, x$country, sep = ", ")
  else
    x$id <- x[[type]]

  # return
  return(covid19(x, id = "us", type = type, raw = raw))

}
