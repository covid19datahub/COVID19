.onAttach <- function(libname, pkgname) {

  packageStartupMessage("The coronavirus situation is changing fast.\nCheck for package updates typing COVID19()")

}

#'
#'
#' @export
#'
COVID19 <- function(){
  print("Check for updates...")
  x <- try(devtools::install_github('emanuele-guidotti/COVID19', quiet = FALSE), silent = TRUE)
  if(class(x)!='try-error'){
    detach("package:COVID19", unload=TRUE)
    library(COVID19)
  }
}

#'
#'
#'
#'
#'
#'
#'
#' @importFrom dplyr %>%
#'
clean <- function(x){

  # bindings
  date <- lat <- lng <- id <- confirmed <- tests <- deaths <- NULL

  # create columns if missing
  col <- c('date','id','country','state','city','lat','lng','tests','confirmed','deaths')
  x[,col[!(col %in% colnames(x))]] <- NA
  x$id <- paste(x$country, x$state, x$city, sep = "|")

  # subset
  x <- x[,col]
  x <- subset(x, !is.na(date) & ((is.na(lat) & is.na(lng)) | !(lat==0 & lng==0)))

  # clean
  x <- x %>%
    dplyr::arrange(date) %>%
    dplyr::group_by(id) %>%
    tidyr::fill(confirmed, tests, deaths) %>%
    dplyr::mutate(confirmed_new = c(confirmed[1], diff(confirmed)),
                  tests_new     = c(tests[1], diff(tests)),
                  deaths_new    = c(deaths[1], diff(deaths))) %>%
    tidyr::replace_na(list(confirmed = 0, tests = 0, deaths = 0))

  # return
  return(x)

}


#'
#'
#'
#' @export
#'
#' @examples
#' \dontrun{
#'
#' x <- italy('region')
#'
#' f <- function(x, group){
#'   plot(x$confirmed~x$date, main = group)
#' }
#'
#' group_map(x, f)
#'
#' }
#'
group_map <- function(x, f){
  dplyr::group_map(x, f)
}





