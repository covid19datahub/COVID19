#' Federal Ministry of Social Affairs, Health, Care and Consumer Protection, Austria (BMSGPK)
#' 
#' Imports confirmed cases, deaths, recovered, tests, hospitalizations, and vaccines at 
#' national and state level for Austria from BMSGPK. Confirmed cases, recovered, and deaths are 
#' also available at the district level.
#' 
#' We compute vaccines_1 as the number of first doses administrated and
#' vaccines_2 as the number of second doses administrated (fully vaccinated).
#' 
#' @source 
#' https://www.data.gv.at/covid-19/
#' 
#' @keywords internal
#' 
gv_at <- function(level){
  if(level>3) return(NULL)
  
  if(level==1 | level==2){

    # see https://www.data.gv.at/katalog/dataset/846448a5-a26e-4297-ac08-ad7040af20f1
    url.hosp <- "https://covid19-dashboard.ages.at/data/Hospitalisierung.csv"    
    
    # see https://www.data.gv.at/katalog/dataset/ef8e980b-9644-45d8-b0e9-c6aaf0eff0c0
    url.cases <- "https://covid19-dashboard.ages.at/data/CovidFaelle_Timeline.csv"
    
    # see https://www.data.gv.at/katalog/dataset/276ffd1e-efdd-42e2-b6c9-04fb5fa2b7ea
    url.vacc <- "https://info.gesundheitsministerium.gv.at/data/COVID19_vaccination_doses_timeline.csv"
    
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
      "dose_number" = "n",
      "doses_administered_cumulative" = "doses"
    ))
    
    # format date
    x.hosp$date <- as.Date(x.hosp$date, format = "%d.%m.%Y")
    x.cases$date <- as.Date(x.cases$date, format = "%d.%m.%Y")
    x.vacc$date <- as.Date(x.vacc$date, format = "%Y-%m-%d")
    
    # first, second, and total doses by state
    x.vacc <- x.vacc %>%
      dplyr::filter(state_id != 0) %>%
      dplyr::group_by(date, state_id) %>%
      dplyr::summarise(
        vaccines = sum(doses),
        vaccines_1 = sum(doses[n==1]),
        vaccines_2 = sum(doses[n==2]))
    
    if(level==1){
      
      # national level data
      x.cases <- x.cases[which(x.cases$state_id==10),]
      x.hosp  <- x.hosp[which(x.hosp$state_id==10),]
      x.vacc  <- x.vacc[which(x.vacc$state_id==10),]
      
      # merge
      x <- x.cases %>%
        dplyr::full_join(x.hosp, by = "date") %>%
        dplyr::full_join(x.vacc, by = "date")
      
    }
    
    if(level == 2){
      
      # drop national level data
      x.cases <- x.cases[-which(x.cases$state_id==10),]
      x.hosp  <- x.hosp[-which(x.hosp$state_id==10),]
      x.vacc  <- x.vacc[-which(x.vacc$state_id==10),]
      
      # merge
      x <- x.cases %>%
        dplyr::full_join(x.hosp, by = c("date","state_id")) %>%
        dplyr::full_join(x.vacc, by = c("date","state_id"))
      
    }
    
  }
  
  if(level == 3){
    
    # see https://www.data.gv.at/katalog/dataset/4b71eb3d-7d55-4967-b80d-91a3f220b60c
    url <- "https://covid19-dashboard.ages.at/data/CovidFaelle_Timeline_GKZ.csv"
    
    # download
    x <- read.csv(url, sep = ";")
    
    # format
    x$date <- as.Date(x$date, format = "%d.%m.%Y")
    x <- map_data(x, c(
      "date"             = "date",
      "Bezirk"           = "city",
      "GKZ"              = "city_id",
      "AnzEinwohner"     = "population",
      "AnzahlFaelleSum"  = "confirmed",
      "AnzahlGeheiltSum" = "recovered",
      "AnzahlTotSum"     = 'deaths'
    ))
    
  }
  
  # return
  return(x)
  
}

