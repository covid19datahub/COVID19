apple <- function(cache){

  # download
  file <- "https://covid19-static.cdn-apple.com/covid19-mobility-data/2005HotfixDev14/v1/en-us/applemobilitytrends-2020-04-14.csv"
  x    <- read.csv(file, cache = cache)

  # date and additional columns
  by <- c("geo_type", "region", "transportation_type")
  x <- x %>%
    tidyr::pivot_longer(cols = -by, values_to = "value", names_to = "date") %>%
    tidyr::pivot_wider(names_from = "transportation_type", values_from = "value") %>%
    dplyr::mutate(date = as.Date(date, format = "X%Y.%m.%d"))

  # return
  return(x)

}

