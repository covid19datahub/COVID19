who_int <- function(cache, iso_alpha_2 = NULL){

  # source
  url  <- "https://covid19.who.int/WHO-COVID-19-global-data.csv"

  # download
  x   <- read.csv(url, cache = cache)
  
  # formatting
  x <- map_data(x, c(
    'Date_reported'     = 'date',
    'Country_code'      = 'iso_alpha_2',
    'Country'           = 'country',
    'Cumulative_cases'  = 'confirmed',
    'Cumulative_deaths' = 'deaths'
  ))
  
  # date
  x$date <- as.Date(x$date, format = "%Y-%m-%d")

  # filter
  if(!is.null(iso_alpha_2))
    x <- x[which(x$iso_alpha_2==iso_alpha_2),]
  
  # return
  return(x)

}
