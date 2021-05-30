gov_tw <- function(level, cache) {
  # author: Lim Jone Keat <jonekeat@gmail.com>
  
  # download
  url <- "https://od.cdc.gov.tw/eic/Day_Confirmation_Age_County_Gender_19CoV.csv"
  x   <- read.csv(url, cache = cache, encoding = "UTF-8")
  
  # map data
  x <- x[,-1]
  colnames(x) <- c("date", "county", "city", "gender", "imported", "age_group", "confirmed")
  
  # turn date into Date
  if(is.character(x$date))
    x$date <- as.Date(x$date, "%Y/%m/%d")
  else
    x$date <- as.Date(as.character(x$date), "%Y%m%d")
  
  # cumulative counts by date and county
  if(level == 1) {
    
    # download tests
    # Description: https://data.gov.tw/dataset/120451
    url.tests <- "https://od.cdc.gov.tw/eic/covid19/covid19_tw_specimen.csv"
    x.tests   <- read.csv(url.tests, cache = cache, encoding = "UTF-8")
    
    # parse
    colnames(x.tests) <- c("date", "notification", "home quarantine", "monitoring", "total")
    x.tests <- x.tests %>%
      dplyr::mutate(date  = as.Date(date, "%Y/%m/%d")) %>%
      dplyr::arrange(date) %>%
      dplyr::mutate(tests = cumsum(total)) %>%
      dplyr::select(date, tests) %>%
      dplyr::filter(!is.na(tests))
    
    x <- x %>% 
      dplyr::group_by_at("date") %>%
      dplyr::summarise(confirmed = sum(confirmed)) %>%
      dplyr::arrange_at("date") %>%
      dplyr::mutate(confirmed = cumsum(confirmed)) %>%
      # add tests
      dplyr::full_join(x.tests, by = "date")
    
  }
  if(level == 2) {
    
    miss <- which(x$county=="空值")
    if(length(miss)) 
      x <- x[-miss,]
    
    x <- x %>% 
      dplyr::group_by_at(c("date","county")) %>%
      dplyr::summarise(confirmed = sum(confirmed)) %>%
      dplyr::group_by_at("county") %>%
      dplyr::arrange_at("date") %>%
      dplyr::mutate(confirmed = cumsum(confirmed))
    
  }
    
  # return
  return(x)
}
