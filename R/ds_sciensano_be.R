sciensano_be <- function(cache, level){

  # download
  url <- "https://epistat.sciensano.be/Data/COVID19BE.xlsx"
  x   <- read.excel(url, cache = cache)  
  
  # date
  x <- lapply(x, function(x){
    
    if("DATE" %in% colnames(x)){
      
      x$date <- as.Date(x$DATE)
      x$DATE <- NULL  
      
      x <- x %>% 
        dplyr::filter(!is.na(date)) %>% 
        dplyr::arrange(date)
      
    }
    
    return(x)
    
  })
  
  if(level==1){
    
    # confirmed
    confirmed <- x$CASES_AGESEX %>% 
      dplyr::group_by(date) %>% 
      dplyr::summarise(confirmed = sum(CASES, na.rm = TRUE)) %>%
      dplyr::mutate(confirmed = cumsum(confirmed))
    
    # hosp
    hosp <- x$HOSP %>%
      dplyr::group_by(date) %>%
      dplyr::summarise(hosp = sum(TOTAL_IN, na.rm = TRUE),
                       icu  = sum(TOTAL_IN_ICU, na.rm = TRUE),
                       vent = sum(TOTAL_IN_RESP, na.rm = TRUE))
    
    # deaths
    deaths <- x$MORT %>%
      dplyr::group_by(date) %>%
      dplyr::summarise(deaths = sum(DEATHS, na.rm = TRUE)) %>%
      dplyr::mutate(deaths = cumsum(deaths))
    
    # tests 
    tests <- x$TESTS %>%
      dplyr::group_by(date) %>%
      dplyr::summarise(tests = sum(TESTS_ALL, na.rm = TRUE)) %>%
      dplyr::mutate(tests = cumsum(tests))
    
    # vaccines
    vaccines <- x$VACC %>%
      dplyr::group_by(date) %>%
      dplyr::summarise(vaccines = sum(COUNT, na.rm = TRUE)) %>%
      dplyr::mutate(vaccines = cumsum(vaccines))
    
    # merge
    x <- merge(confirmed, hosp, all = TRUE)
    x <- merge(x, deaths, all = TRUE)
    x <- merge(x, tests, all = TRUE)
    x <- merge(x, vaccines, all = TRUE)
    
  }
  if(level==2){
    
    # confirmed
    confirmed <- x$CASES_AGESEX %>%
      dplyr::filter(!is.na(REGION)) %>%
      dplyr::group_by(date, REGION) %>% 
      dplyr::summarise(confirmed = sum(CASES, na.rm = TRUE)) %>%
      dplyr::group_by(REGION) %>% 
      dplyr::mutate(confirmed = cumsum(confirmed))
    
    # hosp
    hosp <- x$HOSP %>%
      dplyr::filter(!is.na(REGION)) %>%
      dplyr::group_by(date, REGION) %>%
      dplyr::summarise(hosp = sum(TOTAL_IN, na.rm = TRUE),
                       icu  = sum(TOTAL_IN_ICU, na.rm = TRUE),
                       vent = sum(TOTAL_IN_RESP, na.rm = TRUE))
    
    # deaths
    deaths <- x$MORT %>%
      dplyr::filter(!is.na(REGION)) %>%
      dplyr::group_by(date, REGION) %>%
      dplyr::summarise(deaths = sum(DEATHS, na.rm = TRUE)) %>%
      dplyr::group_by(REGION) %>% 
      dplyr::mutate(deaths = cumsum(deaths))
    
    # tests
    tests <- x$TESTS %>%
      dplyr::filter(!is.na(REGION)) %>%
      dplyr::group_by(date, REGION) %>%
      dplyr::summarise(tests = sum(TESTS_ALL, na.rm = TRUE)) %>%
      dplyr::group_by(REGION) %>% 
      dplyr::mutate(tests = cumsum(tests))
    
    # vaccines
    vaccines <- x$VACC %>%
      dplyr::filter(!is.na(REGION)) %>%
      dplyr::group_by(date, REGION) %>%
      dplyr::summarise(vaccines = sum(COUNT, na.rm = TRUE)) %>%
      dplyr::group_by(REGION) %>% 
      dplyr::mutate(vaccines = cumsum(vaccines))
    
    # merge
    x <- merge(confirmed, hosp, all = TRUE)
    x <- merge(x, deaths, all = TRUE)
    x <- merge(x, tests, all = TRUE)
    x <- merge(x, vaccines, all = TRUE)

  }
 
  if(level==3){
    
    # confirmed
    confirmed <- x$CASES_AGESEX %>%
      dplyr::filter(!is.na(REGION) & !is.na(PROVINCE)) %>%
      dplyr::group_by(date, REGION, PROVINCE) %>% 
      dplyr::summarise(confirmed = sum(CASES, na.rm = TRUE)) %>%
      dplyr::group_by(REGION, PROVINCE) %>% 
      dplyr::mutate(confirmed = cumsum(confirmed))
    
    # hosp
    hosp <- x$HOSP %>%
      dplyr::filter(!is.na(REGION) & !is.na(PROVINCE)) %>%
      dplyr::group_by(date, REGION, PROVINCE) %>%
      dplyr::summarise(hosp = sum(TOTAL_IN, na.rm = TRUE),
                       icu  = sum(TOTAL_IN_ICU, na.rm = TRUE),
                       vent = sum(TOTAL_IN_RESP, na.rm = TRUE))
    
    # tests
    tests <- x$TESTS %>%
      dplyr::filter(!is.na(REGION) & !is.na(PROVINCE)) %>%
      dplyr::group_by(date, REGION, PROVINCE) %>%
      dplyr::summarise(tests = sum(TESTS_ALL, na.rm = TRUE)) %>%
      dplyr::group_by(REGION, PROVINCE) %>% 
      dplyr::mutate(tests = cumsum(tests))
    
    # merge
    x <- merge(confirmed, hosp, all = TRUE)
    x <- merge(x, tests, all = TRUE)
    
  }
  
  return(x)
  
}