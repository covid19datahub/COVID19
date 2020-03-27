#' @importFrom dplyr %>%
NULL



.onAttach <- function(libname, pkgname) {

  if(requireNamespace('COVID19', quietly = TRUE)){

    packageStartupMessage("The coronavirus situation is changing fast. Check for updates...")

    description <- readLines('https://raw.githubusercontent.com/emanuele-guidotti/COVID19/master/DESCRIPTION')
    id <- which(startsWith(prefix = "Version:", x = description))
    v  <- as.package_version(gsub(pattern = "^Version:\\s*", replacement = "", x = description[id]))

    if(v > utils::packageVersion(pkg = "COVID19")){
      packageStartupMessage(sprintf("...new version %s available!\nUpdate the package typing: COVID19()", v))
    } else {
      packageStartupMessage("...up to date.")
    }

  }

}



juhcsse <- function(){

  # data source
  repo <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/"

  # clean column names
  clean_colnames <- function(x){

    colnames(x) <- gsub(pattern = ".", replacement = "_", x = colnames(x), fixed = TRUE)
    colnames(x) <- gsub(pattern = "^.\\_\\_", replacement = "", x = colnames(x), fixed = FALSE)
    colnames(x) <- gsub(pattern = "^_", replacement = "", x = colnames(x), fixed = FALSE)
    colnames(x) <- gsub(pattern = "_$", replacement = "", x = colnames(x), fixed = FALSE)

    cn <- colnames(x)
    colnames(x)[cn=="Last_Update"]              <- "date"
    colnames(x)[cn %in% c("Latitude","Lat")]    <- "lat"
    colnames(x)[cn %in% c("Longitude", "Long")] <- "lng"
    colnames(x)[cn=="Province_State"]           <- "state"
    colnames(x)[cn=="Country_Region"]           <- "country"

    return(x)

  }

  # files
  files = c(
    "confirmed" = "time_series_covid19_confirmed_global.csv",
    "deaths"    = "time_series_covid19_deaths_global.csv",
    "tests"     = "time_series_covid19_testing_global.csv"
  )

  # download data
  data <- NULL
  for(i in 1:length(files)){

    url    <- sprintf("%s/csse_covid_19_time_series/%s", repo, files[i])
    x      <- try(suppressWarnings(utils::read.csv(url)), silent = TRUE)

    if(class(x)=="try-error")
      next

    x      <- clean_colnames(x)
    x      <- reshape2::melt(x, id = c("state", "country", "lat", "lng"), value.name = names(files[i]), variable.name = "date")
    x$date <- as.Date(x$date, format = "X%m_%d_%y")

    if(!is.null(data))
      data <- merge(data, x, all = TRUE, by = c("state", "country", "lat", "lng", "date"))
    else
      data <- x

  }

  return(data)

}



clean <- function(x, diamond = FALSE){

  # bindings
  country <- date <- lat <- lng <- id <- confirmed <- tests <- deaths <- NULL

  # create columns if missing
  col <- c('id','date','country','state','city','lat','lng','deaths','confirmed','tests','deaths_new','confirmed_new','tests_new','pop','pop_14','pop_15_64','pop_65','pop_age','pop_density','pop_death_rate')
  x[,col[!(col %in% colnames(x))]] <- NA
  x$id <- paste(x$country, x$state, x$city, sep = "|")

  # subset
  x <- x[,col]
  if(diamond)
    x <- subset(x, !is.na(date) & country=="Diamond Princess")
  else
    x <- subset(x, !is.na(date) & ((is.na(lat) & is.na(lng)) | !(lat==0 & lng==0)))

  # clean
  x <- x %>%
    dplyr::arrange(date) %>%
    dplyr::group_by(id) %>%
    tidyr::fill(confirmed, tests, deaths) %>%
    tidyr::replace_na(list(confirmed = 0, tests = 0, deaths = 0)) %>%
    dplyr::mutate(confirmed_new = c(confirmed[1], diff(confirmed)),
                  tests_new     = c(tests[1], diff(tests)),
                  deaths_new    = c(deaths[1], diff(deaths)))

  # return
  return(x)

}




