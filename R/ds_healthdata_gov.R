healthdata_gov <- function(cache, level){

  # hosp
  # TODO this code relies on the legacy API, which is soon to be retired... 
  # For now using legacy domain will make the code work...
  url <- "https://legacy.healthdata.gov/node/3565481/download"
  hosp <- read.csv(url, cache = cache, dec = ",")
  
  # format
  colnames(hosp)[1] <- "state"
  hosp <- map_data(hosp, c(
    "state",
    "date",
    "total_adult_patients_hospitalized_confirmed_and_suspected_covid" = "hosp",
    "staffed_icu_adult_patients_confirmed_and_suspected_covid" = "icu"
  ))
  
  # tests
  url <- "https://healthdata.gov/sites/default/files/covid-19_diagnostic_lab_testing_20210228_2203.csv"
  tests <- read.csv(url, cache = cache)
  
  # format
  colnames(tests)[1] <- "state"
  tests <- map_data(tests, c(
    "state",
    "date" = "date",
    "total_results_reported" = "tests"
  ))
  
  # compute total tests
  tests <- tests %>% 
    dplyr::group_by(date, state) %>%
    dplyr::summarise(tests = sum(tests))
  
  
  # merge
  x <- tests %>% 
    dplyr::full_join(hosp, by = c("state", "date"))
  
  # date
  x$date <- as.Date(x$date)
  
  # return
  return(x)
}

