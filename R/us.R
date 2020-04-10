#' United States
#'
#' Tidy format dataset of the 2019 Novel Coronavirus COVID-19 (2019-nCoV) epidemic.
#' US data by country or state.
#'
#' @param type one of \code{country} (data by country) or \code{state} (data by state). Default \code{state}, data by state.
#' @param raw logical. Skip data cleaning? Default \code{FALSE}.
#'
#' @details
#' See \href{https://github.com/emanuele-guidotti/COVID19}{data sources}
#'
#' @return Grouped \code{tibble} (\code{data.frame}). \href{https://github.com/emanuele-guidotti/COVID19}{More info}
#'
#' @examples
#' # data by country
#' x <- us("country")
#'
#' # data by state
#' x <- us("state")
#'
#' @export
#'
us <- function(type = "state", raw = FALSE){

  # check
  if(!(type %in% c("country","state")))
    stop("type must be one of 'country', 'state'")

  # download
  x <- jhuCSSE("US")

  # drop "Grand Princess" and "Diamond Princess"
  x <- x[!(x$state %in% c("Grand Princess","Diamond Princess")),]

  # bindings
  Combined_Key <- country <- state <- date <- lat <- lng <- confirmed <- deaths <- tests <- pop <- NULL

  # group by
  if(type=="country"){
    x <- x %>%
      dplyr::group_by(country, date)
  }
  if(type=="state"){
    x <- x %>%
      dplyr::group_by(Combined_Key, state, country, date)
  }

  # aggregate
  x <- x %>%
    dplyr::summarize(lat = mean(lat, na.rm = TRUE),
                     lng = mean(lng, na.rm = TRUE),
                     confirmed = sum(confirmed, na.rm = TRUE),
                     deaths = sum(deaths, na.rm = TRUE),
                     tests = sum(tests, na.rm = TRUE),
                     pop = sum(pop, na.rm = TRUE))


  # return
  return(covid19(x, raw = raw))

}
