library("COVID19")

lithuania <- function(level, cache) {
  
  if(level == 1) {
    
    # download
    url.daily <- "https://raw.githubusercontent.com/mpiktas/covid19lt/master/data/lt-covid19-country.csv"
    x.daily   <- read.csv(url.daily, cashe = cashe)
    
    # parse
    x <- map_data(x.daily, c(
      "day" = "date",
      "confirmed" = "confirmed",
      "tests" = "tests",
      "deaths" = "deaths",
      "other_deaths",
      "recovered" = "recovered",
      "active",
      "vaccinated_1" = "vac_1",
      "vaccinated_2" = "vac_2",
      "confirmed_daily",
      "tests_daily",
      "tests_mobile_daily",
      "deaths_daily",
      "other_deaths_daily",
      "recovered_daily",
      "tests_positive_new_daily",
      "tests_positive_repeated_daily",
      "vaccinated_1_daily",
      "vaccinated_2_daily",
      "imported_daily",
      "population" = "population",
      "hospitalized" = "hosp",
      "icu" = "icu",
      "ventilated" = "vent",
      "oxygen",
      "tpr_confirmed",
      "tpr_tpn",
      "confirmed_100k",
      "tpn_100k",
      "deaths_100k",
      "other_deaths_100k",
      "all_deaths_100k",
      "tests_100k",
      "tests_mobile_100k",
      "confirmed_growth_weekly",
      "tpn_growth_weekly",
      "tpr_confirmed_diff_weekly",
      "tpr_tpn_diff_weekly",
      "confirmed_100k_growth_weekly",
      "tpn_100k_growth_weekly",
      "deaths_growth_weekly",
      "other_deaths_growth_weekly",
      "all_deaths_growth_weekly",
      "tests_growth_weekly",
      "tests_mobile_growth_weekly",
      "vaccinated_1_percent",
      "vaccinated_2_percent" 
    ))
    x$date <- as.Date(x$date, "%Y-%m-%d")
    
    x <- x %>% mutate( "vaccines" = vac_1 + vac_2) %>% 
      select(date, vaccines, tests, confirmed, recovered, deaths,
             hosp, vent, icu, population)
  }
  
  if(level == 2) {
    
    # download
    url.daily <- "https://raw.githubusercontent.com/mpiktas/covid19lt/master/data/lt-covid19-level2.csv"
    x.daily   <- read.csv(url.daily, cashe = cashe)
    
    x.daily <- x.daily %>% group_by(administrative_level_2) %>% 
      mutate( id = group_indices() )

      # parse
    x <- map_data(x.daily, c(
      "day" = "date",
      "administrative_level_2",
      "confirmed" = "confirmed",
      "tests" = "tests",
      "deaths" = "deaths",
      "other_deaths",
      "recovered" = "recovered",
      "active",
      "vaccinated_1" = "vac_1",
      "vaccinated_2" = "vac_2",
      "confirmed_daily",
      "tests_daily",
      "tests_mobile_daily",
      "deaths_daily",
      "other_deaths_daily",
      "recovered_daily",
      "tests_positive_new_daily",
      "tests_positive_repeated_daily",
      "vaccinated_1_daily",
      "vaccinated_2_daily",
      "imported_daily",
      "population" = "population",
      "tpr_confirmed",
      "tpr_tpn",
      "confirmed_100k",
      "tpn_100k",
      "deaths_100k",
      "other_deaths_100k",
      "all_deaths_100k",
      "tests_100k",
      "tests_mobile_100k",
      "confirmed_growth_weekly",
      "tpn_growth_weekly",
      "tpr_confirmed_diff_weekly",
      "tpr_tpn_diff_weekly",
      "confirmed_100k_growth_weekly",
      "tpn_100k_growth_weekly",
      "deaths_growth_weekly",
      "other_deaths_growth_weekly",
      "all_deaths_growth_weekly",
      "tests_growth_weekly",
      "tests_mobile_growth_weekly",
      "vaccinated_1_percent",
      "vaccinated_2_percent",
      "id" = "id"
    ))
    x$date <- as.Date(x$date, "%Y-%m-%d")
    
        x <- x %>% mutate( "vaccines" = vac_1 + vac_2) %>% 
      select(id, date, vaccines, tests, confirmed, recovered, deaths,
             population, administrative_level_2)
  }
  
  if(level == 3) {
    
    # download
    url.daily <- "https://raw.githubusercontent.com/mpiktas/covid19lt/master/data/lt-covid19-level3.csv"
    x.daily   <- read.csv(url.daily, cashe = cashe)
    
    x.daily <- x.daily %>% group_by(administrative_level_3) %>% 
      mutate( id = group_indices() )
    
    # parse
    x <- map_data(x.daily, c(
      "day" = "date",
      "administrative_level_2",
      "administrative_level_3",
      "confirmed",
      "tests",
      "deaths",
      "other_deaths",
      "recovered",
      "active",
      "vaccinated_1" = "vac_1",
      "vaccinated_2" = "vac_2",
      "confirmed_daily",
      "tests_daily",
      "tests_mobile_daily",
      "deaths_daily",
      "other_deaths_daily",
      "recovered_daily",
      "tests_positive_new_daily",
      "tests_positive_repeated_daily",
      "vaccinated_1_daily",
      "vaccinated_2_daily",
      "imported_daily",
      "population",
      "tpr_confirmed",
      "tpr_tpn",
      "confirmed_100k",
      "tpn_100k",
      "deaths_100k",
      "other_deaths_100k",
      "all_deaths_100k",
      "tests_100k",
      "tests_mobile_100k",
      "confirmed_growth_weekly",
      "tpn_growth_weekly",
      "tpr_confirmed_diff_weekly",
      "tpr_tpn_diff_weekly",
      "confirmed_100k_growth_weekly",
      "tpn_100k_growth_weekly",
      "deaths_growth_weekly",
      "other_deaths_growth_weekly",
      "all_deaths_growth_weekly",
      "tests_growth_weekly",
      "tests_mobile_growth_weekly",
      "vaccinated_1_percent",
      "vaccinated_2_percent",
      "id" = "id"
    ))
    x$date <- as.Date(x$date, "%Y-%m-%d")
    
    x <- x %>% mutate( "vaccines" = vac_1 + vac_2) %>% 
      select(id, date, vaccines, tests, confirmed, recovered, deaths,
             population, administrative_level_2, administrative_level_3)
  }
  
  # return
  return(x)
  
}

x_download <- lithuania(1)
tail(x_download)

ds_check_format(x_download, level = 1)

x_download <- lithuania(2)
tail(x_download)

ds_check_format(x_download, level = 2)

x_download <- lithuania(3)
tail(x_download)

ds_check_format(x_download, level = 3)

