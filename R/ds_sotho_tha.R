sotho_tha <- function(level, cache) {
  
  if(level == 1) {
    
    # download
    url.daily <- "http://covid19.th-stat.com/api/open/timeline"
    x.daily   <- jsonlite::fromJSON(url.daily, flatten=TRUE)$Data
    
    # parse
    x <- map_data(x.daily, c(
      "Date"         = "date",
      "Confirmed"    = "confirmed",
      "Recovered"    = "recovered",
      "Hospitalized" = "hosp",
      "Deaths"       = "deaths"))
    x$date <- as.Date(x$date, "%m/%d/%Y")
    
  }
  if(level == 2) {
    
    # download
    url.cases <- "http://covid19.th-stat.com/api/open/cases"
    x.cases   <- jsonlite::fromJSON(url.cases, flatten=TRUE)$Data
    
    # parse
    x <- map_data(x.cases, c(
      "ConfirmDate" = "date",
      "ProvinceId"  = "province")) #"District"    = "district"
    x <- x %>%
      dplyr::group_by(date, province) %>% # , district (level 3)
      dplyr::tally(name = "confirmed") %>%
      dplyr::group_by(province) %>%
      dplyr::arrange(date) %>%
      dplyr::mutate(date      = as.Date(date, "%Y-%m-%d %H:%M:%S"),
                    confirmed = cumsum(confirmed)) %>%
      dplyr::filter(province != 78) # unknown province record
  }
  
  # return
  return(x)
  
}