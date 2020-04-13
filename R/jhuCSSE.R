jhuCSSE <- function(file, cache, id = NULL){

  # source
  repo <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/"

  if(file=="global")
    urls = c(
      "recovered" = "time_series_covid19_recovered_global.csv",
      "confirmed" = "time_series_covid19_confirmed_global.csv",
      "deaths"    = "time_series_covid19_deaths_global.csv"
    )

  if(file=="US")
    urls = c(
      "confirmed" = "time_series_covid19_confirmed_US.csv",
      "deaths"    = "time_series_covid19_deaths_US.csv"
    )

  for(i in 1:length(urls)){

    # download
    url <- sprintf("%s/csse_covid_19_time_series/%s", repo, urls[i])
    xx  <- read.csv(url, cache = cache)

    if(class(xx)=="try-error")
      next

    # formatting
    colnames(xx) <- gsub(pattern = "_", replacement = ".", x = colnames(xx), fixed = TRUE)
    colnames(xx) <- gsub(pattern = "^.\\_\\_", replacement = "", x = colnames(xx), fixed = FALSE)
    colnames(xx) <- gsub(pattern = "^_", replacement = "", x = colnames(xx), fixed = FALSE)
    colnames(xx) <- gsub(pattern = "_$", replacement = "", x = colnames(xx), fixed = FALSE)

    xx$country <- xx$Country.Region
    xx$state   <- xx$Province.State
    xx$lat     <- xx$Lat
    xx$lng     <- xx$Long

    if(file=="US") {
      xx$country <- xx$iso3
      xx$city <- sapply(strsplit(as.character(xx$Combined.Key), split = ',\\s*'), function(x) x[1])
    }

    cn <- colnames(xx)
    by <- c('country','state','city','lat','lng')
    by <- by[by %in% cn]
    cn <- (cn %in% by) | !is.na(as.Date(cn, format = "X%m.%d.%y"))

    # date
    xx      <- xx[,cn] %>% tidyr::pivot_longer(cols = -by, values_to = names(urls[i]), names_to = "date")
    xx$date <- as.Date(xx$date, format = "X%m.%d.%y")

    # filter
    if(!is.null(id))
      xx <- xx[xx$country==id,,drop=FALSE]

    # merge
    if(i==1)
      x <- xx
    else
      x <- drop(merge(x, xx, all = TRUE, by = c(by[by %in% colnames(x)], "date"), suffixes = c("",".drop")))

  }

  # return
  return(x)

}
