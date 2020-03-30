jhuCSSE <- function(){

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
