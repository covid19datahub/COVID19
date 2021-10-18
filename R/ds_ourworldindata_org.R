#' Our World in Data
#' 
#' Imports worldwide confirmed cases, deaths, hospitalizations,
#' tests, and vaccines at national level from Our World in Data. 
#' Vaccination data are also available at state level for U.S.
#' 
#' @source
#' https://covid.ourworldindata.org
#' 
#' @keywords internal
#' 
ourworldindata_org <- function(level = 1, id = NULL){
  if(level>2) return(NULL)
  
  if(level==1){
    
    # download
    url <- "https://covid.ourworldindata.org/data/owid-covid-data.csv"
    x   <- read.csv(url, cache = TRUE)
    
    # filter 
    x <- x[!is.na(x$iso_code),]
    if(!is.null(id))
      x <- x[x$iso_code %in% id,]
    
    # formatting
    x <- map_data(x, c(
      'date',
      'iso_code'                = 'iso_alpha_3',
      'location'                = 'country',
      'total_cases'             = 'confirmed',
      'total_deaths'            = 'deaths',
      'total_tests'             = 'tests',
      'total_vaccinations'      = 'vaccines',
      'people_vaccinated'       = 'vaccines_1',
      'people_fully_vaccinated' = 'vaccines_2',
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
      'people_vaccinated'       = 'vaccines_1',
      'people_fully_vaccinated' = 'vaccines_2'
    ))
    
    # filter
    if(!is.null(id)){
      x <- x[which(x$state %in% id),]
    }
    else{
      x <- x[which(!x$state %in% c(
        "Bureau of Prisons", "Dept of Defense", "Federated States of Micronesia", 
        "Indian Health Svc", "Long Term Care", "Marshall Islands", "Republic of Palau", 
        "United States", "Veterans Health")),]
    }
    
  }
  
  # date
  x$date <- as.Date(x$date)
  
  # return
  return(x)
  
}

