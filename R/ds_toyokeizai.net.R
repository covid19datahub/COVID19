#' Toyo Keizai
#'
#' Data source for: Japan
#'
#' @param level 1, 2
#'
#' @section Level 1:
#' - confirmed cases
#' - deaths
#' - recovered
#' - tests
#' - hospitalizations
#' - intensive care
#'
#' @section Level 2:
#' - confirmed cases
#' - deaths
#' - recovered
#' - tests
#' - hospitalizations
#' - intensive care
#'
#' @source https://toyokeizai.net/sp/visual/tko/covid19/
#'
#' @keywords internal
#'
toyokeizai.net <- function(level) {
  if(!level %in% 1:2) return(NULL)

  if(level == 1){
    
    # confirmed cases
    url <- "https://toyokeizai.net/sp/visual/tko/covid19/csv/pcr_positive_daily.csv"
    x.cases <- read.csv(url)
    colnames(x.cases) <- c("date", "confirmed")
    
    # deaths 
    url <- "https://toyokeizai.net/sp/visual/tko/covid19/csv/death_total.csv"
    x.deaths <- read.csv(url)
    colnames(x.deaths) <- c("date", "deaths")
    
    # recovered
    url <- "https://toyokeizai.net/sp/visual/tko/covid19/csv/recovery_total.csv"
    x.recovered <- read.csv(url)
    colnames(x.recovered) <- c("date", "recovered")
    
    # tests
    url <- "https://toyokeizai.net/sp/visual/tko/covid19/csv/pcr_tested_daily.csv"
    x.tests <- read.csv(url)
    colnames(x.tests) <- c("date", "tests")
    
    # hosp
    url <- "https://toyokeizai.net/sp/visual/tko/covid19/csv/cases_total.csv"
    x.hosp <- read.csv(url)
    colnames(x.hosp) <- c("date", "hosp")
    
    # icu
    url <- "https://toyokeizai.net/sp/visual/tko/covid19/csv/severe_daily.csv"
    x.icu <- read.csv(url)
    colnames(x.icu) <- c("date", "icu")
    
    # merge
    x <- x.cases %>%
      full_join(x.deaths, by = "date") %>%
      full_join(x.recovered, by = "date") %>%
      full_join(x.tests, by = "date") %>%
      full_join(x.hosp, by = "date") %>%
      full_join(x.icu, by = "date") 
    
    # convert to date and cumulate
    x <- x %>%
      mutate(date = as.Date(date, format = "%Y/%m/%d")) %>%
      arrange(date) %>%
      mutate(confirmed = cumsum(confirmed),
             tests = cumsum(tests))
    
  }
  
  if(level == 2){

    # read data    
    url <- "https://toyokeizai.net/sp/visual/tko/covid19/csv/prefectures.csv"
    x <- read.csv(url)
  
    # convert to date
    x$date <- as.Date(paste(x$year, x$month, x$date, sep = "-"))
    
    # formatting
    x <- map_data(x, c(
      "date" = "date",
      "prefectureNameE" = "prefecture",
      "testedPositive" = "confirmed",
      "peopleTested" = "tests",
      "hospitalized" = "hosp",
      "serious" = "icu",
      "discharged" = "recovered",
      "deaths" = "deaths"
    ))
    
  }
  
  return(x)
}
