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
  x <- try(remotes::install_github('emanuele-guidotti/COVID19', quiet = FALSE, upgrade = FALSE), silent = TRUE)
  library(COVID19)

}



db <- function(id){
  utils::read.csv(system.file("extdata", "db", paste0(id,".csv"), package = "COVID19"))
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

  # clean
  x <- x %>%
    dplyr::arrange(date) %>%
    dplyr::group_by(id)  %>%
    tidyr::fill(.direction = "downup",
                'country', 'state', 'city',
                'lat', 'lng',
                'pop','pop_14','pop_15_64','pop_65',
                'pop_age','pop_density',
                'pop_death_rate')

  if(!raw)
    x <- x %>%
      tidyr::fill(.direction = "down",
                  'confirmed', 'tests', 'deaths') %>%
      tidyr::replace_na(list(confirmed = 0,
                             tests     = 0,
                             deaths    = 0))

  x <- x %>%
    dplyr::mutate(confirmed_new = c(confirmed[1], pmax(0,diff(confirmed))),
                  tests_new     = c(tests[1],     pmax(0,diff(tests))),
                  deaths_new    = c(deaths[1],    pmax(0,diff(deaths))))

  # convert
  x$date <- as.Date(x$date)
  for(i in c('id','country','state','city'))
    x[[i]] <- as.character(x[[i]])

  # return
  return(x)

}
