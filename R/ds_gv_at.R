gv_at <- function(cache, level){
  # author: Martin Benes
  
  # Source: Federal Ministery of Social Affairs, Health, Care and Consumer Protection, Austria (BMSGPK)
  # See also: https://github.com/covid19datahub/COVID19/issues/128
  url.hosp <- "https://covid19-dashboard.ages.at/data/CovidFallzahlen.csv"
  url.cases <- "https://covid19-dashboard.ages.at/data/CovidFaelle_Timeline.csv"
  url.cases3 <- "https://covid19-dashboard.ages.at/data/CovidFaelle_Timeline_GKZ.csv"
  
  x.hosp <- read.csv(url.hosp, cache = cache, sep = ";")
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
  
  x.cases <- read.csv(url.cases, cache = cache, sep = ";")
  colnames(x.cases)[1] <- "date"
  x.cases$date <- as.Date(x.cases$date, format = "%d.%m.%Y")
  x.cases <- map_data(x.cases, c(
    "date"             = "date",
    "Bundesland"       = "state",
    "BundeslandID"     = "state_id",
    "AnzEinwohner"     = "population",
    "AnzahlFaelleSum"  = "confirmed",
    "AnzahlGeheiltSum" = "recovered",
    "AnzahlTotSum"     = 'deaths'
  ))
  
  x.cases3 <- read.csv(url.cases3, cache = cache, sep = ";")
  colnames(x.cases3)[1] <- "date"
  x.cases3$date <- as.Date(x.cases3$date, format = "%d.%m.%Y")
  x.cases3 <- map_data(x.cases3, c(
    "date"             = "date",
    "Bezirk"           = "city",
    "GKZ"              = "city_id",
    "AnzEinwohner"     = "population",
    "AnzahlFaelleSum"  = "confirmed",
    "AnzahlGeheiltSum" = "recovered",
    "AnzahlTotSum"     = 'deaths'
  ))
  
  if(level==1){
    
    # national level data
    x.cases <- x.cases[which(x.cases$state_id==10),]
    x.hosp <- x.hosp[which(x.hosp$state_id==10),]

    # merge
    x <- dplyr::full_join(x.cases, x.hosp, by = "date") 
      
  }
  
  if(level == 2){
    
    # drop national level data
    x.cases <- x.cases[-which(x.cases$state_id==10),]
    x.hosp <- x.hosp[-which(x.hosp$state_id==10),]
    
    # merge
    x <- dplyr::full_join(x.cases, x.hosp, by = c("date","state_id"))
    
  }
  
  if(level == 3){
    
    # nothing to do
    x <- x.cases3
    
  }
  
  # return
  return(x)
  
}

