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



db <- function(id, type = NULL){

  if(!is.null(type)){
    map <- c('country' = 1, 'state' = 2, 'city' = 3)
    id  <- paste0(id,"-",map[type])
  }

  utils::read.csv(system.file("extdata", "db", paste0(id,".csv"), package = "COVID19"))

}



csv <- function(x, id = "", type = ""){

  # bindings
  . <- NULL

  x <- x[,c("id",vars("slow"))]
  x <- x[!duplicated(x),]

  if(id!="" & type!="")
    x <- merge(x, db(id = id, type = type), by = 'id', all = TRUE, suffixes = c('.x',''))

  col <- c('id',vars("slow"))
  x   <- x[,col] %>%
    dplyr::arrange(-rowSums(is.na(.)), .$id)

  if(type=="country"){
    x$state <- NULL
    x$city  <- NULL
  }

  if(type=="state"){
    x$city  <- NULL
  }

  return(x)

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



vars <- function(type = "all"){

  fast <- c('deaths','confirmed','tests')

  slow <- c('country','state','city','lat','lng',
            'pop','pop_14','pop_15_64','pop_65',
            'pop_age','pop_density','pop_death_rate')

  all  <- unique(c(
            'country','state','city',
            'deaths','deaths_new',
            'confirmed','confirmed_new',
            'tests','tests_new',
            fast,
            slow))

  if(type=="slow")
    return(slow)

  if(type=="fast")
    return(fast)

  return(all)

}


#' Internal function - Check
#'
#' Identify which variables are missing for a given country/state/city.
#'
#' @param x \code{data.frame}
#'
#' @return \code{data.frame} of \code{logical}.
#' Rows: country/state/city.
#' Columns: Variables.
#' \code{TRUE}: ok.
#' \code{FALSE}: missing values.
#'
#' @examples
#' \dontrun{
#' x <- world(raw = TRUE)
#' y <- COVID19:::check(x)
#' View(y)
#' }
#'
#' @keywords internal
#'
check <- function(x){

  ok <- dplyr::group_map(x, function(x, g) apply(x, 2, function(x) any(!is.na(x))))
  ok <- t(sapply(ok, function(x) x))
  rownames(ok) <- dplyr::group_keys(x)$id

  return(ok)

}
