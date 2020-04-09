jhuCSSE <- function(type = "global"){

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
    colnames(x)[cn=="Population"]               <- "pop"

    return(x)

  }

  # global
  if(type=="global"){
    files = c(
      "confirmed" = "time_series_covid19_confirmed_global.csv",
      "deaths"    = "time_series_covid19_deaths_global.csv"
    )
  }

  # US
  if(type=="US"){
    files = c(
      "confirmed" = "time_series_covid19_confirmed_US.csv",
      "deaths"    = "time_series_covid19_deaths_US.csv"
    )
  }


  # download data
  data <- NULL
  for(i in 1:length(files)){

    url    <- sprintf("%s/csse_covid_19_time_series/%s", repo, files[i])
    x      <- try(suppressWarnings(utils::read.csv(url)), silent = TRUE)

    if(class(x)=="try-error")
      next

    x      <- clean_colnames(x)
    cn     <- colnames(x)
    id     <- c("Combined_Key", "state", "country", "lat", "lng", "pop")
    id     <- id[id %in% cn]
    cn     <- (cn %in% id) | !is.na(as.Date(cn, format = "X%m_%d_%y"))

    x      <- reshape2::melt(x[,cn], id = id, value.name = names(files[i]), variable.name = "date")
    x$date <- as.Date(x$date, format = "X%m_%d_%y")

    if(!is.null(data)){
      if(type=="global")
        data <- merge(data, x, all = TRUE, by = c("state", "country", "date"), suffixes = c("",".y"))
      if(type=="US")
        data <- merge(data, x, all = TRUE, by = c("Combined_Key", "date"), suffixes = c("",".y"))
    }
    else {
      data <- x
    }

  }

  return(data)

}
