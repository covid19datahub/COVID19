#' World Health Organization
#'
#' Data source for: Worldwide
#'
#' @param level 1
#' @param id filter by 2-letter ISO code of country 
#'
#' @section Level 1:
#' - confirmed cases
#' - deaths
#'
#' @source https://covid19.who.int
#'
#' @keywords internal
#'
who.int <- function(level = 1, id = NULL){
  if(level!=1) return(NULL)
  
  # download
  url <- "https://srhdpeuwpubsa.blob.core.windows.net/whdh/COVID/WHO-COVID-19-global-daily-data.csv"
  who_data <- read.csv(url, stringsAsFactors = FALSE)
  
  # formatting
  who_data <- map_data(who_data, c(
    'Date_reported'     = 'date',
    'Country_code'      = 'country_id',
    'Country'           = 'country',
    'Cumulative_cases'  = 'confirmed',
    'Cumulative_deaths' = 'deaths',
    'New_cases'         = 'new_cases',
    'New_deaths'        = 'new_deaths'
  ))
  
  # date
  who_data$date <- as.Date(who_data$date, format = "%Y-%m-%d")

  # filter
  who_data <- who_data %>%
    filter(country_id == id) %>%
    mutate(
      confirmed = if_else(!is.na(new_cases), confirmed, NA_integer_),
      deaths = if_else(!is.na(new_deaths), deaths, NA_integer_)
    ) %>%
    filter(!is.na(confirmed) | !is.na(deaths)) %>% 
    select(date, country_id, confirmed, deaths)
  
  return(who_data)
}
