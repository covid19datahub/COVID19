rivm_nl <- function(level, cache) {
  
  # data for levels 1 & 2
  if(level <= 2) {
    
    # download
    url <- "https://data.rivm.nl/covid-19/COVID-19_casus_landelijk.csv"
    x2  <- read.csv(url, cache = cache, sep = ";")
    
    # date, death dates
    x2 <- x2 %>%
      dplyr::mutate(
        date     = as.Date(Date_statistics),
        province = trimws(Province),
        death_date = as.Date(paste(Week_of_death, "Sun"), "%Y%W %a"))
    
  }
  # data or levels 2 & 3
  if(level >= 2) {
    
    # download
    url <- "https://data.rivm.nl/covid-19/COVID-19_aantallen_gemeente_cumulatief.csv"
    x3  <- read.csv(url, cache = cache, sep = ";")
    
    # parse
    x3 <- map_data(x3, c(
      "Date_of_report"     = "date",
      "Municipality_name"  = "municipality",
      "Province"           = "province",
      "Total_reported"     = "confirmed",
      "Hospital_admission" = "hosp", # cumulative
      "Deceased"           = "deaths"
    ))
    x3 <- x3 %>%
      dplyr::mutate(
        date         = as.Date(date, "%Y-%m-%d %H:%M:%S"),
        municipality = trimws(municipality))
  }
  
  # country level
  if(level == 1) {
    
    # confirmed
    x.confirmed <- x2 %>%
      # group cases
      dplyr::group_by(date) %>%
      dplyr::tally(name = "confirmed") %>%
      # cumsum
      dplyr::mutate(confirmed = cumsum(confirmed))
    
    # deaths
    x.deaths <- x2 %>%
      dplyr::filter(!is.na(death_date)) %>% # some death dates are not known
      # group death cases
      dplyr::group_by(death_date) %>%
      dplyr::tally(name = "deaths") %>%
      # cumsum
      dplyr::rename(date = death_date) %>%
      dplyr::mutate(deaths = cumsum(deaths))
    
    # join and fill
    x <- x.confirmed %>%
      dplyr::full_join(x.deaths, by = "date") %>%
      tidyr::fill(confirmed, deaths, .direction = "down")
    
  }
  # region level
  if(level == 2) {
    
    # confirmed
    x.confirmed <- x2 %>%
      # group cases
      dplyr::group_by(date, province) %>%
      dplyr::tally(name = "confirmed") %>%
      # cumsum
      dplyr::mutate(confirmed = cumsum(confirmed))
    
    # deaths
    x.deaths <- x2 %>%
      dplyr::filter(!is.na(death_date)) %>% # some death dates are not known
      # group death cases
      dplyr::group_by(death_date, province) %>%
      dplyr::tally(name = "deaths") %>%
      # cumsum
      dplyr::rename(date = death_date) %>%
      dplyr::group_by(province) %>%
      dplyr::mutate(deaths = cumsum(deaths))
    
    x.hosp <- x3 %>%
      dplyr::group_by(date, province) %>%
      dplyr::summarise(hosp = sum(hosp), .groups = "drop")
    
    # join and fill
    x <- x.confirmed %>%
      dplyr::full_join(x.deaths, by = c("date","province")) %>%
      dplyr::full_join(x.hosp, by = c("date","province")) %>%
      dplyr::group_by(province) %>%
      tidyr::fill(confirmed, deaths, .direction = "down")
      
  }
  
  # municipality
  if(level == 3) {
    
    x <- x3 %>%
      dplyr::filter(!is.na(municipality))
    
  }
  
  # return
  return(x)
  
}
