#' Switzerland
#'
#' Tidy format dataset of the 2019 Novel Coronavirus COVID-19 (2019-nCoV) epidemic.
#' Swiss data by country or state (cantons).
#'
#' @param type one of \code{country} (data by country) or \code{state} (data by canton). Default \code{state}, data by canton.
#' @param raw logical. Skip data cleaning? Default \code{FALSE}.
#'
#' @details
#' See \href{https://github.com/emanuele-guidotti/COVID19}{data sources}
#'
#' @return Grouped \code{tibble} (\code{data.frame}). \href{https://github.com/emanuele-guidotti/COVID19}{More info}
#'
#' @examples
#' # data by country
#' x <- switzerland("country")
#'
#' # data by canton
#' x <- switzerland("state")
#'
#' @export
#'
switzerland <- function(type = "state", raw = FALSE){

  # bindings
  country <- date <- confirmed <- deaths <- tests <- recovered <- hosp <- hosp_icu <- hosp_vent <- NULL

  # check
  if(!(type %in% c("country","state")))
    stop("type must be one of 'country', 'state'")

  # download
  x <- openZH() %>%
    dplyr::filter(country=="Switzerland")

  # aggregate
  if(type=="country"){
    x <- x %>%
      dplyr::group_by(country, date) %>%
      dplyr::summarize(code      = "CH",
                       confirmed = sum(confirmed, na.rm = TRUE),
                       deaths    = sum(deaths, na.rm = TRUE),
                       tests     = sum(tests, na.rm = TRUE),
                       recovered = sum(recovered, na.rm = TRUE),
                       hosp      = sum(hosp, na.rm = TRUE),
                       hosp_icu  = sum(hosp_icu, na.rm = TRUE),
                       hosp_vent = sum(hosp_vent, na.rm = TRUE))
  }

  # merge
  x <- merge(x, db("ch"), by.x = "code", by.y = "id", all.x = TRUE)

  # return
  return(covid19(x, raw = raw))

}

