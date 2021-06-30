sotho_tha <- function(level, cache) {
  
  # check unavailable
  w <- httr::GET("http://covid19.th-stat.com")
  if(w$status_code == 522)
    return(NULL)
  
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
    url <- "http://covid19.th-stat.com/api/open/cases"
    x   <- jsonlite::fromJSON(url, flatten=TRUE)$Data
    
    # parse
    x <- map_data(x, c(
      "ConfirmDate" = "date",
      "ProvinceId"  = "province"))
    x$date <- as.Date(x$date, "%Y-%m-%d")
    
    # cumulative counts by province 
    x <- x %>%
      dplyr::group_by(date, province) %>% 
      dplyr::tally(name = "confirmed") %>%
      dplyr::group_by(province) %>%
      dplyr::arrange(date) %>%
      dplyr::mutate(confirmed = cumsum(confirmed)) %>%
      dplyr::filter(province != 78) # unknown province record
    
  }
  
  # return
  return(x)
  
}