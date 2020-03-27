#' Package Update
#'
#' Updates the package to the latest development version.
#'
#' @return install and require the latest development version of \code{COVID19}.
#'
#' @source \href{https://github.com/emanuele-guidotti/COVID19}{GitHub repository}
#'
#' @export
#'
COVID19 <- function(){
  x <- try(devtools::install_github('emanuele-guidotti/COVID19', quiet = FALSE, upgrade = FALSE), silent = TRUE)
  detach("package:COVID19", unload=TRUE)
  library(COVID19)
}
