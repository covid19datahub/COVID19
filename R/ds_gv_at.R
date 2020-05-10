gv_at <- function(cache){
  # author: Martin Benes
  
  # Download
  # https://www.data.gv.at/katalog/dataset/osterreichische-statistische-daten-zu-covid-19/resource/7ad666c7-663d-45dc-ae66-f61385c9eeba
  # Federal Ministery of Social Affairs, Health, Care and Consumer Protection, Austria (BMSGPK)
  url  <- "https://info.gesundheitsministerium.at/data/data.zip"
  
  # download
  data <- read.zip(url, cache = cache, sep = ";", files = c(
    "confirmed" = "Epikurve.csv",
    "deaths"    = "TodesfaelleTimeline.csv",
    "recovered" = "GenesenTimeline.csv", 
    "icu_pct"   = "IBAuslastung.csv",
    "hosp_pct"  = "NBAuslastung.csv"))
  # AlgemeinDaten.csv - current situation
  # Altersverteilung.csv - numbers of confirmed by age
  # AltersverteilungTodesfaelle.csv - numbers of deaths by age
  # AltersverteilungTodesfaelleDemogr.csv - numbers of deaths by age (computed on demography???)
  # Bezirke.csv - current number of confirmed by district
  # Bundesland.csv - current number of confirmed by state
  # Epikurve.csv - confirmed by time
  # GenesenTimeline.csv - recovered by time
  # GenesenTodesFaelleBL.csv - current number of deaths and recovered by state
  # Geschlechtsverteilung.csv - number of confirmed (percentage) by gender
  # IBAuslastung.csv - occupancy of ICU beds by time
  # IBKapazitaeten.csv - capacity of ICU beds by time
  # NBAuslastung.csv - occupancy of normal beds by time
  # NBKapazitaeten.csv - capacity of normal beds by time
  # TodesfaelleTimeline.csv - deaths by time
  # VerstorbenGeschlechtsverteilung.csv - number of deaths (percentage) by gender
  
  x <- NULL
  for(i in names(data)){
    
    xx <- data[[i]][,1:2]
    colnames(xx) <- c('date', i) 
    
    if(is.null(x))
      x <- xx
    else 
      x <- merge(x, xx, all = TRUE)
    
  }

  # date
  x$date <- as.Date(x$date, format="%d.%m.%Y")
  
  # sort and cumulate
  x <- x %>% dplyr::arrange_at('date')
  x$confirmed <- cumsum(x$confirmed)
  
  # return
  return(x)
  
}

