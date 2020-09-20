gov_tw <- function(level, cache) {
  # author: Lim Jone Keat <jonekeat@gmail.com>
  
  # download
  url <- "https://od.cdc.gov.tw/eic/Day_Confirmation_Age_County_Gender_19CoV.csv"
  x   <- read.csv(url, cache = cache, encoding = "UTF-8")
  
  # map data
  x <- x[,-1]
  colnames(x) <- c("date", "county", "gender", "imported", "age_group", "confirmed")
  
  # turn date into Date
  x$date <- as.Date(x$date, "%Y/%m/%d")
  
  # cumulative counts by date and county
  if(level==1){
    x <- x %>% 
      dplyr::group_by_at("date") %>%
      dplyr::summarise(confirmed = sum(confirmed)) %>%
      dplyr::arrange_at("date") %>%
      dplyr::mutate(confirmed = cumsum(confirmed))
  }
  if(level==2){
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
