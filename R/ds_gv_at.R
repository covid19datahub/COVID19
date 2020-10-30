gv_at <- function(cache, level){
  # author: Martin Benes
  
  # Download
  # https://www.data.gv.at/katalog/dataset/osterreichische-statistische-daten-zu-covid-19/resource/7ad666c7-663d-45dc-ae66-f61385c9eeba
  # Federal Ministery of Social Affairs, Health, Care and Consumer Protection, Austria (BMSGPK)
  url  <- "https://info.gesundheitsministerium.at/data/data.zip"
  
  data <- read.zip(url, cache = cache, sep = ";", files = c(
    "cases"     = "CovidFaelle_Timeline.csv",
    "hosp"      = "CovidFallzahlen.csv",
    "deaths"    = "TodesfaelleTimeline.csv",
    "recovered" = "GenesenTimeline.csv"))
  
  x.cases <- data$cases
  colnames(x.cases)[1] <- "date"
  x.cases$date <- as.Date(x.cases$date, format = "%d.%m.%Y")
  x.cases <- map_data(x.cases, c(
    "date"             = "date",
    "Bundesland"       = "state",
    "BundeslandID"     = "state_id",
    "AnzEinwohner"     = "population",
    "AnzahlFaelleSum"  = "confirmed",
    "AnzahlGeheiltSum" = "recovered"
  ))
  
  x.hosp <- data$hosp
  colnames(x.hosp)[1] <- "date"
  x.hosp$date <- as.Date(x.hosp$date, format = "%d.%m.%Y")
  x.hosp <- map_data(x.hosp, c(
    "date"         = "date",
    "Bundesland"   = "state",
    "BundeslandID" = "state_id",
    "TestGesamt"   = "tests",
    "FZHosp"       = "hosp",
    "FZICU"        = "icu"
  )) 
  
  x.deaths <- data$deaths[,1:2]
  colnames(x.deaths) <- c("date", "deaths")
  x.deaths$date <- as.Date(x.deaths$date, format = "%d.%m.%Y")
  
  x.recovered <- data$recovered[,1:2]
  colnames(x.recovered) <- c("date", "recovered")
  x.recovered$date <- as.Date(x.recovered$date, format = "%d.%m.%Y")
  
  if(level==1){
    
    # national level data
    x.cases <- x.cases[which(x.cases$state_id==10),]
    x.hosp <- x.hosp[which(x.hosp$state_id==10),]
    
    # drop duplicated recovered
    x.cases$recovered <- NULL
    
    # merge
    by <- c("date")
    x <- x.cases %>% 
      dplyr::full_join(x.hosp, by = by) %>%
      dplyr::full_join(x.deaths, by = by) %>%
      dplyr::full_join(x.recovered, by = by) 
    
  }
  
  if(level == 2){
    
    # drop national level data
    x.cases <- x.cases[-which(x.cases$state_id==10),]
    x.hosp <- x.hosp[-which(x.hosp$state_id==10),]
    
    # merge
    x <- dplyr::full_join(x.cases, x.hosp, by = c("date","state_id"))
    
  }
  
  # return
  return(x)
  
}

