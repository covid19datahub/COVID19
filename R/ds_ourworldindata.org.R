#' Our World in Data
#'
#' Data source for: Worldwide
#'
#' @param level 1, 2
#' @param id filter by ISO code if level=1 or by name of state if level=2
#'
#' @section Level 1:
#' - tests
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#' - hospitalizations
#' - intensive care
#'
#' @section Level 2:
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#'
#' @source https://covid.ourworldindata.org
#'
#' @keywords internal
#'
ourworldindata.org <- function(level = 1, id = NULL){
  if(!level %in% 1:2) return(NULL)
  
  if(level==1){
    
    # download
    url <- "https://covid.ourworldindata.org/data/owid-covid-data.csv"
    x   <- read.csv(url, cache = TRUE)
    
    # keep only countries 
    x <- x[!is.na(x$iso_code),]
    
    # filter by id 
    if(!is.null(id))
      x <- x[x$iso_code %in% id,]
    
    # formatting
    x <- map_data(x, c(
      'date',
      'iso_code'                = 'iso_alpha_3',
      'location'                = 'country',
      'total_tests'             = 'tests',
      'total_vaccinations'      = 'vaccines',
      'people_vaccinated'       = 'people_vaccinated',
      'people_fully_vaccinated' = 'people_fully_vaccinated',
      'icu_patients'            = 'icu',
      'hosp_patients'           = 'hosp'
    ))
    
  }
  
  if(level==2){
    
    # download
    url <- "https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/vaccinations/us_state_vaccinations.csv"
    x   <- read.csv(url)
    
    # formatting
    x <- map_data(x, c(
      'date',
      'location'                = 'state',
      'total_vaccinations'      = 'vaccines',
      'people_vaccinated'       = 'people_vaccinated',
      'people_fully_vaccinated' = 'people_fully_vaccinated'
    ))
    
    # filter by id
    if(!is.null(id)){
      x <- x[which(x$state %in% id),]
    }
    # drop states that should not be in level 2
    else{
      x <- x[which(!x$state %in% c(
        "Bureau of Prisons", "Dept of Defense", "Federated States of Micronesia", 
        "Indian Health Svc", "Long Term Care", "Marshall Islands", "Republic of Palau", 
        "United States", "Veterans Health")),]
    }
    
  }
  
  # date
  x$date <- as.Date(x$date)
  
  return(x)
}

