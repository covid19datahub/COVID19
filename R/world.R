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

  # drop "Taiwan*" and "Holy See"
  x <- x[!(x$country %in% c("Taiwan*","Holy See")),]

  # type
  if(type=="country"){

    # bindings
    country <- date <- lat <- lng <- confirmed <- deaths <- tests <- NULL

    # aggregate
    x <- x %>%
      dplyr::group_by(country, date) %>%
      dplyr::summarize(lat = mean(lat, na.rm = TRUE),
                       lng = mean(lng, na.rm = TRUE),
                       confirmed = sum(confirmed, na.rm = TRUE),
                       deaths = sum(deaths, na.rm = TRUE),
                       tests = sum(tests, na.rm = TRUE))

  }

  # merge
  x <- merge(x, db("wb"), by.x = "country", by.y = "id", all.x = TRUE)

  # return
  return(covid19(x, raw = raw))

}
