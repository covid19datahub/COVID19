#' Diamond Princess
#'
#' Tidy format dataset of the 2019 Novel Coronavirus COVID-19 (2019-nCoV) epidemic.
#' Diamond Princess data.
#'
#' @param raw logical. Skip data cleaning? Default \code{FALSE}
#'
#' @details
#' See \href{https://github.com/emanuele-guidotti/COVID19}{data sources}
#'
#' @return Grouped \code{tibble} (\code{data.frame}). \href{https://github.com/emanuele-guidotti/COVID19}{More info}
#'
#' @examples
#' x <- diamond()
#'
#' @export
#'
diamond <- function(raw = FALSE){

  # download
  x <- jhuCSSE("global")

  # bindings
  country <- state <- NULL

  # subset
  x         <- x[x$country=="Diamond Princess",]
  dp        <- db("dp")
  dp$date   <- as.Date(dp$date, format = "%Y-%m-%d")
  idx       <- which(x$date %in% dp$date)
  x         <- x[-idx,]
  x         <- dplyr::bind_rows(x,dp) %>% tidyr::fill(country, state)
  x$pop     <- 3711

  # return
  return(covid19(x, raw = raw))

}
