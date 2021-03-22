healthdata_gov <- function(cache, level){

  # hosp: https://healthdata.gov/Hospital/COVID-19-Reported-Patient-Impact-and-Hospital-Capa/g62h-syeh
  url <- "https://healthdata.gov/resource/g62h-syeh.csv"
  hosp <- read.csv(url, cache = cache, dec = ",")
  
  # format
  colnames(hosp)[1] <- "state"
  hosp <- map_data(hosp, c(
    "state",
    "date",
    "total_adult_patients_hospitalized_confirmed_and_suspected_covid" = "hosp",
    "staffed_icu_adult_patients_confirmed_and_suspected_covid" = "icu"
  ))
  
  # tests: https://healthdata.gov/dataset/COVID-19-Diagnostic-Laboratory-Testing-PCR-Testing/j8mb-icvb
  url <- "https://healthdata.gov/resource/j8mb-icvb.csv"
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

