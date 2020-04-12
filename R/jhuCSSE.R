jhuCSSE <- function(type){

  # data source
  repo <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/"

  # global
  if(type=="global")
    files = c(
      "confirmed" = "time_series_covid19_confirmed_global.csv",
      "deaths"    = "time_series_covid19_deaths_global.csv"
    )

  # US
  if(type=="US")
    files = c(
      "confirmed" = "time_series_covid19_confirmed_US.csv",
      "deaths"    = "time_series_covid19_deaths_US.csv"
    )


  # download data
  data <- NULL
  for(i in 1:length(files)){

    url    <- sprintf("%s/csse_covid_19_time_series/%s", repo, files[i])
    x      <- try(suppressWarnings(utils::read.csv(url)), silent = TRUE)

    if(class(x)=="try-error")
      next

    colnames(x) <- gsub(pattern = "_", replacement = ".", x = colnames(x), fixed = TRUE)
    colnames(x) <- gsub(pattern = "^.\\_\\_", replacement = "", x = colnames(x), fixed = FALSE)
    colnames(x) <- gsub(pattern = "^_", replacement = "", x = colnames(x), fixed = FALSE)
    colnames(x) <- gsub(pattern = "_$", replacement = "", x = colnames(x), fixed = FALSE)

    x$country <- x$Country.Region
    x$state   <- x$Province.State
    x$lat     <- x$Lat
    x$lng     <- x$Long
    x$pop     <- x$Population

    if(type=="US")
      x$city <- sapply(strsplit(as.character(x$Combined.Key), split = ',\\s*'), function(x) x[1])

    cn <- colnames(x)
    by <- c('country','state','city','lat','lng','pop')
    by <- by[by %in% cn]
    cn <- (cn %in% by) | !is.na(as.Date(cn, format = "X%m.%d.%y"))

    x      <- x[,cn] %>% tidyr::pivot_longer(cols = -by, values_to = names(files[i]), names_to = "date")
    x$date <- as.Date(x$date, format = "X%m.%d.%y")

    if(!is.null(data))
        data <- merge(data, x, all = TRUE, by = c(by[by %in% colnames(data)], "date"), suffixes = c("",".drop"))
    else
      data <- x


  }

  return(data)

}
