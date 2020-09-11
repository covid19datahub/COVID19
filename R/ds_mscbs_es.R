mscbs_es <- function(level, cache) {
  # Author: Martin Benes 07/09/2020 - martinbenes1996@gmail.com
  
  if(level == 2) {
    
    # download
    url <- 'https://cnecovid.isciii.es/covid19/resources/datos_ccaas.csv'
    x   <- read.csv(url, cache = cache)
    
    # format
    x <- map_data(x, c(
      "fecha"     = "date",
      "ccaa_iso"  = "state",
      "num_casos" = "confirmed")) 
    
    # cumulate
    x <- x %>%
      dplyr::group_by(state) %>%
      dplyr::arrange(date) %>%
      dplyr::mutate(confirmed = cumsum(confirmed))
    
    # date
    x$date <- as.Date(x$date, "%Y-%m-%d")
    
  }
  if(level == 3) {
    
    # download
    url <- 'https://cnecovid.isciii.es/covid19/resources/datos_provincias.csv'
    x   <- read.csv(url, cache = cache)
    
    # format
    x <- map_data(x, c(
      "fecha"         = "date",
      "provincia_iso" = "district",
      "num_casos"     = "confirmed")) 
    
    # cumulate
    x <- x %>%
      dplyr::group_by(district) %>%
      dplyr::arrange(date) %>%
      dplyr::mutate(confirmed = cumsum(confirmed))
    
    # fix
    # x[which(x$district == "CE"),"district"] <- "CE3"
    
    # date
    x$date <- as.Date(x$date, "%Y-%m-%d")
    
  }
  
  # return
  return(x)
  
}