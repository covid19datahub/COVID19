bmsgpk <- function(cache, ...){
  # author: Martin Benes
  
  #' Download
  #' https://www.data.gv.at/katalog/dataset/osterreichische-statistische-daten-zu-covid-19/resource/7ad666c7-663d-45dc-ae66-f61385c9eeba
  #' Federal Ministery of Social Affairs, Health, Care and Consumer Protection, Austria (BMSGPK)
  bmsgpk.url <- "https://info.gesundheitsministerium.at/data/data.zip"
  temp <- tempfile()
  download.file(bmsgpk.url, temp)
  
  # avaliable information
  zipped_filenames <- unzip(temp, list=T)[,1]
  #' AlgemeinDaten.csv - current situation
  #' Altersverteilung.csv - numbers of confirmed by age
  #' AltersverteilungTodesfaelle.csv - numbers of deaths by age
  #' AltersverteilungTodesfaelleDemogr.csv - numbers of deaths by age (computed on demography???)
  #' Bezirke.csv - current number of confirmed by district
  #' Bundesland.csv - current number of confirmed by state
  #' Epikurve.csv - confirmed by time
  #' GenesenTimeline.csv - recovered by time
  #' GenesenTodesFaelleBL.csv - current number of deaths and recovered by state
  #' Geschlechtsverteilung.csv - number of confirmed (percentage) by gender
  #' IBAuslastung.csv - occupancy of ICU beds by time
  #' IBKapazitaeten.csv - capacity of ICU beds by time
  #' NBAuslastung.csv - occupancy of normal beds by time
  #' NBKapazitaeten.csv - capacity of normal beds by time
  #' TodesfaelleTimeline.csv - deaths by time
  #' VerstorbenGeschlechtsverteilung.csv - number of deaths (percentage) by gender
   
  # load data
  confirmed <- read.csv(unz(temp, "Epikurve.csv"), sep=";", cache=cache)
  deaths <- read.csv(unz(temp, "TodesfaelleTimeline.csv"), sep=";", cache=cache)
  recovered <- read.csv(unz(temp, "GenesenTimeline.csv"), sep=";", cache=cache)
  icu.occupancy <- read.csv(unz(temp, "IBAuslastung.csv"), sep=";", cache=cache)
  normal.occupancy <- read.csv(unz(temp, "NBAuslastung.csv"), sep=";", cache=cache)
  
  # format
  confirmed <- subset(confirmed, select=-Timestamp)
  colnames(confirmed) <- mapvalues(colnames(confirmed), c(
    'ï..time'                      = 'date',
    'tÃ.gliche.Erkrankungen'       = 'confirmed'
  ))
  deaths <- subset(deaths, select=-Timestamp)
  colnames(deaths) <- mapvalues(colnames(deaths), c(
    'ï..time'                      = 'date',
    'TodesfÃ.lle'                  = 'deaths'
  ))
  recovered <- subset(recovered, select=-Timestamp)
  colnames(recovered) <- mapvalues(colnames(recovered), c(
    'ï..time'                      = 'date',
    'Genesen'                      = 'recovered'
  ))
  icu.occupancy <- subset(icu.occupancy, select=-Timestamp)
  colnames(icu.occupancy) <- mapvalues(colnames(icu.occupancy), c(
    'ï..time'                      = 'date',
    'Belegung.Intensivbetten.in..' = 'icu_beds_occupancy'
  ))
  normal.occupancy <- subset(normal.occupancy, select=-Timestamp)
  colnames(normal.occupancy) <- mapvalues(colnames(normal.occupancy), c(
    'ï..time'                      = 'date',
    'Belegung.Normalbetten.in..'   = 'normal_beds_occupancy'
  ))
  
  # convert dates  
  confirmed$date <- as.Date(confirmed$date, format="%d.%m.%Y")
  deaths$date <- as.Date(deaths$date, format="%d.%m.%Y")
  recovered$date <- as.Date(recovered$date, format="%d.%m.%Y")
  icu.occupancy$date <- as.Date(icu.occupancy$date, format="%d.%m.%Y")
  normal.occupancy$date <- as.Date(normal.occupancy$date, format="%d.%m.%Y")
  
  # join tables by dates
  x <- merge(confirmed,deaths,by="date",all=T)
  x <- merge(x,recovered,by="date",all=T)
  x <- merge(x,icu.occupancy,by="date",all=T)
  x <- merge(x,normal.occupancy,by="date",all=T)
  
  # turn confirmed to cumulative
  x$confirmed <- cumsum(x$confirmed)
  
  x$country <- "AUT" # country

  return(x)
}

bmsgpk(F)
