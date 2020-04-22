
OpenIND <- function(cache){
  
  # source
  res = httr::GET("https://api.covid19india.org/data.json")
  
  #data
  rawToChar(res$content)
  data = jsonlite::fromJSON(rawToChar(res$content))
  
  #View(data[["cases_time_series"]])
  
  ind_data <- as.data.frame(data[["cases_time_series"]])
  
  #formatting
  ind_data$date <- paste(ind_data$date,"2020")
  ind_data$date <- lubridate::parse_date_time2(ind_data$date, orders = "dmY")
  ind_data$date <- as.Date(ind_data$date)
  
  #final dataframe
  final_ind <-ind_data[,c("date","dailydeceased","dailyconfirmed","dailyrecovered")] 
  colnames(final_ind) <- c("date","deaths","confirmed","recovered")
  
  final_ind$id <- "IND"
  final_ind$tests <- NA 
  final_ind <- final_ind[,c("id","date","deaths","confirmed","tests","recovered")]
  
  final_ind$hosp <- NA
  final_ind$icu <- NA
  final_ind$vent <- NA
  final_ind$driving <- NA
  final_ind$walking <- NA
  final_ind$transit <- NA
  
  final_ind$country <- "India"
  
  final_ind$state <- NA
  final_ind$city <- NA
  final_ind$lat <- NA
  final_ind$lng <- NA
  final_ind$pop <- NA
  final_ind$pop_14 <- NA
  final_ind$pop_15_64 <- NA
  final_ind$pop_65 <- NA
  final_ind$pop_age <- NA
  final_ind$pop_density <- NA
  final_ind$pop_death_rate <- NA
  
  #return
  return(final_ind)
  
}
