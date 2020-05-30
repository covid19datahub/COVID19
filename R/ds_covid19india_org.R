covid19india_org <- function(cache, level){
  # Author: Rijin Baby
  
  if(level==1){

    # reading source data
    # https://www.covid19india.org/
    url <- "https://api.covid19india.org/csv/latest/case_time_series.csv"
    x   <- read.csv(url, cache = cache)
    
    # formatting
    x <- map_data(x, c(
      "Date"            = "date",
      "Total.Deceased"  = "deaths",
      "Total.Confirmed" = "confirmed",
      "Total.Recovered" = "recovered"
    ))
    
    # filter date
    x <- x[!is.na(x$date),]
    
    # convert date
    Sys.setlocale("LC_TIME", "C")
    x$date <- as.Date(x$date, format = "%d %B")
        
  }
  if(level==2){

    # reading source data
    # https://www.covid19india.org/
    url <- "https://api.covid19india.org/csv/latest/state_wise_daily.csv"
    x   <- read.csv(url, cache = cache)
    
    # drop total and unassigned
    x <- x[,!(colnames(x) %in% c("TT","UN"))]
    
    # filter date
    colnames(x)[1] <- "date"
    x <- x[!is.na(x$date),]
    
    # convert date
    Sys.setlocale("LC_TIME", "C")
    x$date <- as.Date(x$date, format = "%d-%b-%y")
    
    # cumulative 
    x <- x %>% 
      dplyr::group_by(Status) %>%
      dplyr::arrange(date) %>%
      dplyr::group_map(.keep = TRUE, function(x,g) {
        c(x[,1:2], cumsum(x[,-(1:2)], na.rm = TRUE))
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
