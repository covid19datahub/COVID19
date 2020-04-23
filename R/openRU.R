openRU <- function(cache){
  
  # source
  repo <- "https://raw.githubusercontent.com/grwlf/COVID-19_plus_Russia/master/csse_covid_19_data/csse_covid_19_time_series/"
  url  <- "time_series_covid19_confirmed_RU.csv"
  
  # download
  url <- sprintf("%s/%s", repo, url)
  confirmed  <- read.csv(url, cache = cache)
  
  #formatting
  
  confirmed <- subset(confirmed, select = -c(UID,iso2,iso3,code3, FIPS,Admin2,Combined_Key))
  
  names(confirmed)[names(confirmed) == "Province_State"] <- "state"
  names(confirmed)[names(confirmed) == "Country_Region"] <- "country"
  names(confirmed)[names(confirmed) == "Lat"] <- "lat"
  names(confirmed)[names(confirmed) == "Long_"] <- "lng"
  
  #filtering
  
  confirmed <-confirmed[, colSums(confirmed != 0) > 0]
  
  #reshaping
  
  cnames <- (colnames(confirmed))
  const_names <- c("state", "country", "lat", "lng")
  var_names <- cnames[cnames != const_names]
  
  confirmed_ru <- reshape(data = confirmed, 
                          idvar = const_names,
                          varying = var_names,
                          v.names = "confirmed",
                          timevar = "date",
                          times = var_names,
                          direction ="long")

  row.names(confirmed_ru)<-NULL
  
  #date
  
  confirmed_ru$date <- as.Date(confirmed_ru$date, format = "X%m.%d.%y")
  
  # return
  return(confirmed_ru)
  
}
