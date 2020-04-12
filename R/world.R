#' World
#'
#' Tidy format dataset of the 2019 Novel Coronavirus COVID-19 (2019-nCoV) epidemic.
#' Global data by country or state.
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
#' x <- world("country")
#'
#' # data by state
#' x <- world("state")
#'
#' @export
#'
world <- function(type = "state", raw = FALSE){

  # check
  if(!(type %in% c("country","state")))
    stop("type must be one of 'country', 'state'")

  # download
  x <- jhuCSSE("global")

  # clean
  x <- x[!(x$country %in% c("Taiwan*","Holy See","Diamond Princess")),]

  # aggregate
  if(type=="country"){

    # bindings
    country <- date <- confirmed <- deaths <- tests <- NULL

    # aggregate
    x <- x %>%
      dplyr::group_by(country, date) %>%
      dplyr::summarize(confirmed = sum(confirmed, na.rm = TRUE),
                       deaths    = sum(deaths, na.rm = TRUE),
                       tests     = sum(tests, na.rm = TRUE))

  }

  # id: see https://github.com/emanuele-guidotti/COVID19/tree/master/inst/extdata/db
  if(type=="state"){
    x$id <- paste(x$state, x$country, sep = ", ")
    x$id <- gsub(x$id, pattern = "^, ", replacement = "")
  }
  if(type=="country"){
    x$id <- x$country
  }

  # return
  return(covid19(x, id = "wb", type = type, raw = raw))

}
