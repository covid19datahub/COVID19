#' Coronavirus COVID-19 data - Liechtenstein
#'
#' Tidy format dataset of the 2019 Novel Coronavirus COVID-19 (2019-nCoV) epidemic.
#' Liechtenstein data.
#' The data are downloaded in real-time.
#'
#' @seealso \code{\link{world}}, \code{\link{diamond}}, \code{\link{italy}}, \code{\link{switzerland}}
#'
#' @details
#' Data pulled from \href{https://github.com/openZH/covid_19}{Open Government Data} which are communicated by official
#' Principality of Liechtenstein's sources.
#'
#' @return Return of the internal function \code{\link{covid19}}
#'
#' @examples
#' x <- liechtenstein()
#'
#' @export
#'
liechtenstein <- function(){

  # bindings
  country <- NULL

  # download
  x <- openZH() %>%
    dplyr::filter(country=="Liechtenstein")

  # population info
  # x <- merge(x, COVID19::CH, by.x = "code", by.y = "id", all.x = TRUE)

  # return
  return(covid19(x))

}

