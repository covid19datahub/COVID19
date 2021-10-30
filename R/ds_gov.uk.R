#' UK Health Security Agency
#'
#' Data source for: United Kingdom
#'
#' @param level 1, 2, 3
#'
#' @section Level 1:
#' - confirmed cases
#' - deaths
#' - tests
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#' - hospitalizations
#' - patients requiring ventilation
#'
#' @section Level 2:
#' - confirmed cases
#' - deaths
#' - tests
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#' - hospitalizations
#' - patients requiring ventilation
#' 
#' @section Level 3:
#' - confirmed cases
#' - deaths
#' - tests
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#' - hospitalizations
#' - patients requiring ventilation
#'
#' @source https://coronavirus.data.gov.uk
#'
#' @keywords internal
#'
gov.uk <- function(level){
  
  # Extracts paginated data by requesting all of the pages
  # and combining the results.
  #
  # @param filters    API filters. See the API documentations for 
  #                   additional information.
  #                   
  # @param structure  Structure parameter. See the API documentations 
  #                   for additional information.
  #                   
  # @return list      Comprehensive list of dictionaries containing all 
  #                   the data for the given ``filter`` and ``structure`.`
  get_paginated_data <- function (filters, structure) {
    
    endpoint     <- "https://api.coronavirus.data.gov.uk/v1/data"
    results      <- list()
    current_page <- 1
    
    repeat {
      
      i <- 1
      repeat{
        
        httr::GET(
          url   = endpoint,
          query = list(
            filters   = paste(filters, collapse = ";"),
            structure = jsonlite::toJSON(structure, auto_unbox = TRUE),
            page      = current_page
          ),
          httr::timeout(30)
        ) -> response
        
        # Handle errors:
        if ( response$status_code >= 400 ) {
          i <- i+1
          if(i<5)
            Sys.sleep(i+runif(1))
          else
            stop(httr::http_status(response))
        } else break
        
      }
      
      # Handle errors:
      if ( response$status_code == 204 ) {
        break
      }
      
      # Convert response from binary to JSON:
      json_text <- httr::content(response, "text")
      dt        <- jsonlite::fromJSON(json_text)
      results   <- rbind(results, dt$data)
      
      if ( is.null( dt$pagination$`next` ) ){
        break
      }
      
      current_page <- current_page + 1
      
    }
    
    return(results)
    
  }
  
  # level
  area_type <- switch (level, "overview", "nation", "ltla")
  
  # download
  x <- NULL
  for(a in area_type){
    
    # create filters
    filters <- c(
      sprintf("areaType=%s", a)
    )
    
    # vaccination metrics
    dose1 <- "cumPeopleVaccinatedFirstDoseByVaccinationDate"
    dose2 <- "cumPeopleVaccinatedSecondDoseByVaccinationDate"
    if(a %in% c("overview", "nation")){
      dose1 <- "cumPeopleVaccinatedFirstDoseByPublishDate"
      dose2 <- "cumPeopleVaccinatedSecondDoseByPublishDate"
    }
    
    # create structure
    structure <- list(
      "date"       = "date",
      "type"       = "areaType",
      "name"       = "areaName",
      "code"       = "areaCode",
      "confirmed"  = "cumCasesBySpecimenDate",
      "deaths"     = "cumDeaths28DaysByDeathDate",
      "tests"      = "cumVirusTests",
      "vent"       = "covidOccupiedMVBeds",
      "hosp"       = "hospitalCases",
      "vaccines"   = "cumVaccinesGivenByPublishDate",
      "people_vaccinated" =  dose1,
      "people_fully_vaccinated" =  dose2
    )
    
    # download data
    x <- dplyr::bind_rows(x, get_paginated_data(filters, structure))
    
  }
  
  # clean
  x <- x[!duplicated(x[,c("date","code")]),]
  
  # date
  x$date <- as.Date(x$date)
  
  return(x) 
}
