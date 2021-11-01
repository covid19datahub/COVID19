#' U.S. Department of Health & Human Services
#'
#' Data source for: United States
#'
#' @param level 2
#'
#' @section Level 2:
#' - tests
#' - hospitalizations
#' - intensive care
#'
#' @source https://healthdata.gov/browse?tags=hhs+covid-19
#'
#' @keywords internal
#'
healthdata.gov <- function(level){
  if(level!=2) return(NULL)
  
  # hospitalizations
  # see https://healthdata.gov/d/g62h-syeh
  url <- "https://healthdata.gov/api/views/g62h-syeh/rows.csv?accessType=DOWNLOAD"
  x.hosp <- read.csv(url)
  
  # format
  x.hosp <- map_data(x.hosp, c(
    "state" = "state",
    "date" = "date",
    "total_adult_patients_hospitalized_confirmed_and_suspected_covid" = "hosp",
    "staffed_icu_adult_patients_confirmed_and_suspected_covid" = "icu"
  ))
  
  # tests
  # see https://healthdata.gov/d/j8mb-icvb
  url <- "https://healthdata.gov/api/views/j8mb-icvb/rows.csv?accessType=DOWNLOAD"
  x.tests <- read.csv(url)
  
  # format
  x.tests <- map_data(x.tests, c(
    "state" = "state",
    "date" = "date",
    "total_results_reported" = "tests"
  ))
  
  # compute total tests
  x.tests <- x.tests %>% 
    group_by(date, state) %>%
    summarise(tests = sum(tests))
  
  # merge
  x <- full_join(x.tests, x.hosp, by = c("state", "date"))
  
  # drop Marshall Islands
  x <- x[which(x$state != "MH"),]
  
  # convert date
  x$date <- as.Date(x$date)
  
  return(x)
}
