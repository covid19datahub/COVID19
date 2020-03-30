openZH <- function(){

  # bindings
  code <- NULL

  # data source
  repo <- "https://raw.githubusercontent.com/openZH/covid_19/master/"

  # download
  url   <- "COVID19_Fallzahlen_CH_total.csv"
  url   <- sprintf("%s/%s", repo, url)
  data  <- utils::read.csv(url)

  # dates
  d <- as.Date(data$date, format = "%Y-%m-%d")
  data$date <- d

  # formatting
  data$code      <- data$abbreviation_canton_and_fl
  data$confirmed <- data$ncumul_conf
  data$tests     <- data$ncumul_tested
  data$deaths    <- data$ncumul_deceased
  data$recovered <- data$ncumul_released
  data$hosp      <- data$ncumul_hosp   # current, not cumulative numbers: https://github.com/openZH/covid_19
  data$hosp_icu  <- data$ncumul_ICU    # current, not cumulative numbers: https://github.com/openZH/covid_19
  data$hosp_vent <- data$ncumul_vent   # current, not cumulative numbers: https://github.com/openZH/covid_19

  # country
  data <- data %>%
    dplyr::mutate(country = ifelse(code=="FL", "Liechtenstein", "Switzerland"))

  # return
  return(data)

}
