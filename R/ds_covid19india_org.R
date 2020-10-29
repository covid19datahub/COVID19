covid19india_org <- function(cache, level){
  # Author: Rijin Baby
  
  if(level==1){

    # reading source data
    # https://www.covid19india.org/
    url <- "https://api.covid19india.org/csv/latest/case_time_series.csv"
    x   <- read.csv(url, cache = cache)
    
    # formatting
    x <- map_data(x, c(
      "Date_YMD"        = "date",
      "Total.Deceased"  = "deaths",
      "Total.Confirmed" = "confirmed",
      "Total.Recovered" = "recovered"
    ))
    
    # convert and filter date
    x$date <- as.Date(x$date)
    x <- x[!is.na(x$date),]
    
  }
  if(level==2){

    # reading source data
    # https://www.covid19india.org/
    url <- "https://api.covid19india.org/csv/latest/state_wise_daily.csv"
    x   <- read.csv(url, cache = cache)
    
    # drop total and unassigned
    x <- x[,!(colnames(x) %in% c("TT","UN"))]
    
    # convert and filter date
    colnames(x)[1] <- "date"
    x$date <- as.Date(x$Date_YMD)
    x <- x[!is.na(x$date),]
    
    # cumulative 
    x <- x %>% 
      dplyr::group_by(Status) %>%
      dplyr::arrange(date) %>%
      dplyr::group_map(.keep = TRUE, function(x,g) {
        c(x[,c(1,3)], cumsum(x[,-c(1:3)], na.rm = TRUE))
      }) %>%
      dplyr::bind_rows()
    
    # formatting
    x <- x %>% 
      tidyr::pivot_longer(-(1:2), names_to = "state", values_to = "value") %>%
      tidyr::pivot_wider(names_from = "Status")
    
    x <- map_data(x, c(
      'date',
      'state',
      'Confirmed' = 'confirmed',
      'Deceased'  = 'deaths',
      'Recovered' = 'recovered'
    ))
    
  }
  
  # return
  return(x)
  
}
