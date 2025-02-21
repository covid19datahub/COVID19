#' Secretariat of the Pacific Regional Environment Programme
#'
#' Data source for: American Samoa
#'
#' @param level 1
#' @param id filter by 2-letter ISO code of country
#'
#' @section Level 1:
#' - total vaccine doses administered
#' - people vaccinated
#' - people fully vaccinated
#'
#' @source https://pacific-data.sprep.org/index.php/dataset/covid-19-vaccination
#'
#' @keywords internal
#'
sprep.org <- function(level = 1, id = NULL){
  # download
  url <- "https://stats-sdmx-disseminate.pacificdata.org/rest/data/SPC,DF_COVID_VACCINATION,1.0/all/?format=csvfilewithlabels"
  vac_data <- read.csv(url, stringsAsFactors = FALSE)
  
  # formatting
  vac_data <- map_data(vac_data, c(
    "TIME_PERIOD" = "date",
    "GEO_PICT" = "iso_code",
    "Pacific.Island.Countries.and.territories" = "country",
    "Indicator" = "type",
    "OBS_VALUE" = "total"
  ))
  
  # filter
  vac_data <- filter(vac_data, iso_code == id)
  
  # pivot
  vac_data <- vac_data %>%
    pivot_wider(names_from = type, values_from = total, values_fn = list(total = ~ .[!is.na(.)][1])) %>%
    rename(
      vaccines = `Total doses administered`,
      people_vaccinated = `1st dose administered`,
      people_fully_vaccinated = `2nd dose administered`
    ) %>%
    select(date, iso_code, country, vaccines, people_vaccinated, people_fully_vaccinated)
  
  # date 
  vac_data$date <- as.Date(vac_data$date, format = "%Y-%m-%d")
   
  return(vac_data)
}