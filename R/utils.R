#' @importFrom dplyr %>%
NULL



.onAttach <- function(libname, pkgname) {

  if(interactive() & requireNamespace('COVID19', quietly = TRUE)){

    packageStartupMessage("The coronavirus situation is changing fast. Checking for updates...")

    description <- readLines('https://raw.githubusercontent.com/emanuele-guidotti/COVID19/master/DESCRIPTION')
    id <- which(startsWith(prefix = "Version:", x = description))
    v  <- as.package_version(gsub(pattern = "^Version:\\s*", replacement = "", x = description[id]))

    if(v > utils::packageVersion(pkg = "COVID19")){

      yn <- utils::askYesNo("Package COVID19: new version available. Update now?")
      if(!is.na(yn)) if(yn)
        update()

    } else {

      packageStartupMessage("...up to date.")

    }

  }

}



update <- function(){

  detach("package:COVID19", unload=TRUE)
  x <- try(devtools::install_github('emanuele-guidotti/COVID19', quiet = FALSE, upgrade = FALSE), silent = TRUE)
  library(COVID19)

}



fill <- function(x){

  # subset
  x <- x[!is.na(x$date),]

  # full grid
  date <- seq(min(x$date), max(x$date), by = 1)
  id   <- unique(x$id)
  grid <- expand.grid(id = id, date = date)

  # fill
  x <- suppressWarnings(dplyr::bind_rows(x, grid))
  x <- x[!duplicated(x[,c("id","date")]),]

  # return
  return(x)

}


#' Process and Clean COVID-19 Raw Data
#'
#' Internal function used to clean the raw data. Provides a
#' unified and curated COVID-19 dataset across different sources.
#'
#' @param x COVID-19 \code{data.frame}
#' @param raw logical. Skip data cleaning? Default \code{FALSE}.
#'
#' @return Tidy format \code{tibble} (\code{data.frame}) grouped by id, containing the columns:
#' \describe{
#'  \item{id}{id in the form "country|state|city".}
#'  \item{date}{date.}
#'  \item{country}{administrative area level 1.}
#'  \item{state}{administrative area level 2.}
#'  \item{city}{administrative area level 3.}
#'  \item{lat}{latitude.}
#'  \item{lng}{longitude.}
#'  \item{deaths}{the number of deaths.}
#'  \item{confirmed}{the number of cases.}
#'  \item{tests}{the number of tests.}
#'  \item{deaths_new}{daily increase in the number of deaths.}
#'  \item{confirmed_new}{daily increase in the number of cases.}
#'  \item{tests_new}{daily increase in the number of tests.}
#'  \item{pop}{total population.}
#'  \item{pop_14}{population ages 0-14 (\% of total population). Except Switzerland: ages 0-19.}
#'  \item{pop_15_64}{population ages 15-64 (\% of total population). Except Switzerland: ages 20-64.}
#'  \item{pop_65}{population ages 65+ (\% of total population).}
#'  \item{pop_age}{median age of population.}
#'  \item{pop_density}{population density per km2.}
#'  \item{pop_death_rate}{population mortality rate.}
#' }
#'
covid19 <- function(x, raw = FALSE){

  # bindings
  id <- date <- country <- state <- city <- lat <- lng <- confirmed <- tests <- deaths <- NULL

  # create columns if missing
  col <- c('id','date','country','state','city','lat','lng','deaths','confirmed','tests','deaths_new','confirmed_new','tests_new','pop','pop_14','pop_15_64','pop_65','pop_age','pop_density','pop_death_rate')
  x[,col[!(col %in% colnames(x))]] <- NA
  x$id <- paste(x$country, x$state, x$city, sep = "|")

  # subset
  x <- x[,col]

  # fill
  x <- fill(x)

  # sort and group
  x <- x %>%
    dplyr::arrange(date) %>%
    dplyr::group_by(id)

  # clean
  if(!raw){

    x <- x %>%

      tidyr::fill(.direction = "downup",
                  'country', 'state', 'city',
                  'lat', 'lng',
                  'pop','pop_14','pop_15_64','pop_65',
                  'pop_age','pop_density',
                  'pop_death_rate') %>%

      tidyr::fill(.direction = "down",
                  'confirmed', 'tests', 'deaths') %>%

      tidyr::replace_na(list(confirmed = 0,
                             tests     = 0,
                             deaths    = 0)) %>%

      dplyr::mutate(confirmed_new = c(confirmed[1], pmax(0,diff(confirmed))),
                    tests_new     = c(tests[1],     pmax(0,diff(tests))),
                    deaths_new    = c(deaths[1],    pmax(0,diff(deaths))))

  }

  # return
  return(x)

}
