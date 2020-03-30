#' Coronavirus COVID-19 data - Switzerland
#'
#' Tidy format dataset of the 2019 Novel Coronavirus COVID-19 (2019-nCoV) epidemic.
#' Swiss data by country or state (cantons).
#' The data are downloaded in real-time, processed and merged with demographic indicators (\code{\link{CH}}).
#'
#' @seealso \code{\link{world}}, \code{\link{diamond}}, \code{\link{italy}}, \code{\link{liechtenstein}}
#'
#' @param type one of \code{country} (data by country) or \code{state} (data by canton). Default \code{state}, data by canton.
#'
#' @details
#' Data pulled from \href{https://github.com/openZH/covid_19}{Open Government Data} which are communicated
#' by official Swiss canton's sources.
#'
#' @return Return of the internal function \code{\link{covid19}}
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
switzerland <- function(type = "state"){

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

  # population info
  x <- merge(x, COVID19::CH, by.x = "code", by.y = "id", all.x = TRUE)

  # return
  return(covid19(x))

}

