gouv_fr <- function(cache, level = 1){
  
  # source: https://www.data.gouv.fr/fr/datasets/synthese-des-indicateurs-de-suivi-de-lepidemie-covid-19/#_
  
  if(level == 1){
    
    # download
    url <- "https://www.data.gouv.fr/fr/datasets/r/f335f9ea-86e3-4ffa-9684-93c009d5e617"
    x <- read.csv(url, cache = cache)
    
    # formatting
    x <- map_data(x, c(
      "date" = "date",
      "hosp" = "hosp",
      "rea" = "icu",
      "rad" = "recovered",
      "dc_tot" = "deaths",
      "conf" = "confirmed"
    ))
    
  }
  else{
    
    # not used at the moment. 
    # url <- "https://www.data.gouv.fr/fr/datasets/r/5c4e1452-3850-4b59-b11c-3dd51d7fb8b5"
    # x <- read.csv(url, cache = cache)
    
  }
  
  # convert to date
  x$date <- as.Date(x$date)
  
  # return
  return(x)
  
}
