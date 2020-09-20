covid19chile_git <- function(level, cache) {
  
  # download
  url <- "https://raw.githubusercontent.com/ivanMSC/COVID19_Chile/master/covid19_comunas_informeEpidemiologico.csv"
  x   <- read.csv(url, cache = cache)
  
  # parse
  x <- map_data(x, c(
    "Fecha"             = "date",
    "Region"            = "region",
    "Comuna"            = "commune",
    "Casos.Confirmados" = "confirmed"))
  x$date <- as.Date(x$date, "%d-%m-%Y")
  
  # sanitize
  x$region  <- trimws(x$region)
  x$commune <- trimws(x$commune)
  
  # level
  if(level == 2) {
    x <- x %>%
      dplyr::group_by(date, region) %>%
      dplyr::summarise(confirmed = sum(confirmed), .groups = 'drop')
  }
  if(level == 3) {
    x <- x %>%
      dplyr::group_by(date, region, commune) %>%
      dplyr::summarise(confirmed = sum(confirmed), .groups = 'drop')
  }
  
  # return
  return(x)
}