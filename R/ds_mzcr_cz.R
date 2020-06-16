mzcr_cz <- function(level, cache){
  # Author: Martin Benes
  
  # mzcr - Ministery of Health of Czech Republic
  mzcr.covid.api <- "https://onemocneni-aktualne.mzcr.cz/api/v1/covid-19"
  mzcr.covid.url <- "https://onemocneni-aktualne.mzcr.cz/covid-19"
  
  if(level == 1) {
    # number of tests
    url   <- sprintf("%s/testy.csv", mzcr.covid.api)
    tests <- read.csv(file = url, cache = cache)
    
    # number of infected
    url       <- sprintf("%s/nakaza.csv", mzcr.covid.api)
    confirmed <- read.csv(url, cache = cache)
    
    # date
    tests$date     <- as.Date(tests[,1])
    confirmed$date <- as.Date(confirmed[,1]) 
    # select columns
    tests     <- map_data(tests, c("date", "testy_celkem" = "tests"))
    confirmed <- map_data(confirmed, c("date", "pocet_celkem" = "confirmed")) 
    
    # formatting
    x <- merge(tests, confirmed, by = "date", all = TRUE)

  }
  # levels 2,3
  if(level >= 2) {
    # people confirmed/deaths/recovered (by districts)
    url    <- 'https://onemocneni-aktualne.mzcr.cz/api/v2/covid-19/kraj-okres-nakazeni-vyleceni-umrti.csv'
    x      <- read.csv(url, cache = cache)
    x$date <- as.Date(x[,1])
    
    x <- map_data(x, c(
      "date",
      "kraj_nuts_kod" = "state",
      "okres_lau_kod" = "district",
      "kumulativni_pocet_nakazenych" = "confirmed",
      "kumulativni_pocet_vylecenych" = "recovered",
      "kumulativni_pocet_umrti"      = "deaths"
    ))
  }
  
  if(level == 2) {
    x <- x %>%
      dplyr::group_by(date,state) %>%
      dplyr::summarise(
        confirmed = sum(confirmed),
        recovered = sum(recovered),
        deaths    = sum(deaths))
  }
  
  if(level == 3) {
   # nothing to do 
  }
  
  # return
  return(x)
  
}