#' Federal Ministry of Social Affairs, Health, Care and Consumer Protection, Austria
#'
#' Data source for: Austria
#'
#' @param level 1, 2, 3
#'
#' @section Level 1:
#' - confirmed cases
#' - deaths
#' - recovered
#' - tests
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#' - hospitalizations
#' - intensive care
#'
#' @section Level 2:
#' - confirmed cases
#' - deaths
#' - recovered
#' - tests
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#' - hospitalizations
#' - intensive care
#'
#' @section Level 3:
#' - confirmed cases
#' - deaths
#' - recovered
#'
#' @source https://www.data.gv.at/covid-19/
#'
#' @keywords internal
#'
gv.at <- function(level){
  if(!level %in% 1:3) return(NULL)
  
  if(level==1 | level==2){

    # see https://www.data.gv.at/katalog/dataset/846448a5-a26e-4297-ac08-ad7040af20f1
    url.hosp <- "https://covid19-dashboard.ages.at/data/Hospitalisierung.csv"    
    
    # see https://www.data.gv.at/katalog/dataset/ef8e980b-9644-45d8-b0e9-c6aaf0eff0c0
    url.cases <- "https://covid19-dashboard.ages.at/data/CovidFaelle_Timeline.csv"
    
    # see https://www.data.gv.at/katalog/dataset/85d040af-e09a-4401-8d67-8cee3e41fcaa
    url.vacc <- "https://info.gesundheitsministerium.gv.at/data/COVID19_vaccination_doses_timeline_v202206.csv"
    
    # import hosp
    x.hosp <- read.csv(url.hosp, sep = ";")
    x.hosp <- map_data(x.hosp, c(
      "Meldedatum"   = "date",
      "Bundesland"   = "state",
      "BundeslandID" = "state_id",
      "TestGesamt"   = "tests",
      "NormalBettenBelCovid19"   = "hosp",
      "IntensivBettenBelCovid19" = "icu"
    )) 
    
    # import cases
    x.cases <- read.csv(url.cases, sep = ";")
    x.cases <- map_data(x.cases, c(
      "Time"             = "date",
      "Bundesland"       = "state",
      "BundeslandID"     = "state_id",
      "AnzEinwohner"     = "population",
      "AnzahlFaelleSum"  = "confirmed",
      "AnzahlGeheiltSum" = "recovered",
      "AnzahlTotSum"     = 'deaths'
    ))
    
    # import vaccines
    x.vacc <- read.csv(url.vacc, sep = ";", fileEncoding = "UTF-8-BOM")
    x.vacc <- map_data(x.vacc, c(
      "date" = "date",
      "state_id" = "state_id",
      "vaccine" = "type",
      "dose_number" = "dose",
      "doses_administered_cumulative" = "n"
    ))
    
    # format date
    x.hosp$date <- as.Date(x.hosp$date, format = "%d.%m.%Y")
    x.cases$date <- as.Date(x.cases$date, format = "%d.%m.%Y")
    x.vacc$date <- as.Date(x.vacc$date, format = "%Y-%m-%d")
    
    # first, second, and total doses by state
    x.vacc <- x.vacc %>%
      filter(state_id != 0) %>%
      group_by(date, state_id) %>%
      summarise(
        vaccines = sum(n),
        people_vaccinated = sum(n[dose == "1"]),
        people_fully_vaccinated = sum(n[dose == "2" | (dose == "1" & type == "Janssen")])) %>%
      mutate(people_fully_vaccinated = pmin(people_fully_vaccinated, people_vaccinated))
    
    if(level==1){
      
      # national level data
      x.cases <- x.cases[which(x.cases$state_id==10),]
      x.hosp  <- x.hosp[which(x.hosp$state_id==10),]
      x.vacc  <- x.vacc[which(x.vacc$state_id==10),]
      
      # merge
      x <- x.cases %>%
        full_join(x.hosp, by = "date") %>%
        full_join(x.vacc, by = "date")
      
    }
    
    if(level == 2){
      
      # drop national level data
      x.cases <- x.cases[-which(x.cases$state_id==10),]
      x.hosp  <- x.hosp[-which(x.hosp$state_id==10),]
      x.vacc  <- x.vacc[-which(x.vacc$state_id==10),]
      
      # merge
      x <- x.cases %>%
        full_join(x.hosp, by = c("date","state_id")) %>%
        full_join(x.vacc, by = c("date","state_id"))
      
    }
    
  }
  
  if(level == 3){
    
    # see https://www.data.gv.at/katalog/dataset/4b71eb3d-7d55-4967-b80d-91a3f220b60c
    url <- "https://covid19-dashboard.ages.at/data/CovidFaelle_Timeline_GKZ.csv"
    
    # download
    x <- read.csv(url, sep = ";")
    
    # format
    x <- map_data(x, c(
      "Time"             = "date",
      "Bezirk"           = "city",
      "GKZ"              = "city_id",
      "AnzEinwohner"     = "population",
      "AnzahlFaelleSum"  = "confirmed",
      "AnzahlGeheiltSum" = "recovered",
      "AnzahlTotSum"     = 'deaths'
    ))
    
    # convert date
    x$date <- as.Date(x$date, format = "%d.%m.%Y")
    
  }
  
  return(x)
}
