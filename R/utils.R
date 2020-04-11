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


