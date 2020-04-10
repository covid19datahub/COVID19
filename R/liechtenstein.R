#' Liechtenstein
#'
#' Tidy format dataset of the 2019 Novel Coronavirus COVID-19 (2019-nCoV) epidemic.
#' Liechtenstein data.
#'
#' @param raw logical. Skip data cleaning? Default \code{FALSE}.
#'
#' @details
#' See \href{https://github.com/emanuele-guidotti/COVID19}{data sources}
#'
#' @return Grouped \code{tibble} (\code{data.frame}). \href{https://github.com/emanuele-guidotti/COVID19}{More info}
#'
#' @examples
#' x <- liechtenstein()
#'
#' @export
#'
liechtenstein <- function(raw = FALSE){

  # bindings
  country <- NULL

  # download
  x <- openZH() %>%
    dplyr::filter(country=="Liechtenstein")

  # return
  return(covid19(x, raw = raw))

}

