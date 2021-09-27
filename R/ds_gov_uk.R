gov_uk <- function(level){
  
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
  area_type <- switch (level,
    c("overview"),
    c("nation","region"),
    c("ltla")
  )
  
  # download
  x <- NULL
  for(a in area_type){
    
    # Create filters:
    filters <- c(
      sprintf("areaType=%s", a)
    )
    
    # metrics
    dose1 <- "cumPeopleVaccinatedFirstDoseByVaccinationDate"
    dose2 <- "cumPeopleVaccinatedSecondDoseByVaccinationDate"
    if(a %in% c("overview", "nation")){
      dose1 <- "cumPeopleVaccinatedFirstDoseByPublishDate"
      dose2 <- "cumPeopleVaccinatedSecondDoseByPublishDate"
    }
    
    # Create structure. It seems that numbers are not allowed in renaming!
    structure <- list(
      "date"       = "date",
      "type"       = "areaType",
      "name"       = "areaName",
      "code"       = "areaCode",
      "confirmed"  = "cumCasesBySpecimenDate",
      "deaths"     = "cumDeaths28DaysByDeathDate",
      "tests"      = "cumVirusTests",
      "dose1"      =  dose1,
      "dose2"      =  dose2,
      "vent"       = "covidOccupiedMVBeds",
      "hosp"       = "hospitalCases"
    )
    
    x <- dplyr::bind_rows(x, get_paginated_data(filters, structure))
    
  }
  
  # drop England (already included with regions)
  x <- x[x$code!="E92000001",]
  
  # vaccines
  x$vaccines <- rowSums(x[,c("dose1", "dose2")], na.rm = TRUE)
  
  # clean
  x <- x[!duplicated(x[,c("date","code")]),]
  
  # date
  x$date <- as.Date(x$date)
  
  # return
  return(x) 
  
}


