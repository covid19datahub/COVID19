opencovid_fr <- function(cache, level = 1){
  # Montemurro Paolo 11 05 2020
  
  # Download data
  url <- "https://raw.githubusercontent.com/opencovid19-fr/data/master/dist/chiffres-cles.csv"
  x   <- read.csv(url, cache = cache) 
  
  # drop wrong observation
  idx <- which(x$date<"2020-01-24" & x$granularite=="pays")
  if(length(idx))
    x <- x[-idx,]
  
  # Formatting columns
  x <- map_data(x, c(
    'date',
    'depistes'      = 'tests',
    'cas_confirmes' = 'confirmed',
    'deces'         = 'deaths',
    'deces_ehpad'   = 'deaths_elderly',
    'gueris'        = 'recovered',
    'hospitalises'  = 'hosp',
    'reanimation'   = 'icu',
    'source_type'   = 'source',
    'granularite',
    'maille_code',
    'maille_nom'
  ))

  # Fix multiple dates per id
  x <- x %>% 
    group_by_at(c('date', 'maille_code', 'source', 'granularite', 'maille_nom')) %>%
    summarize(tests          = sum(tests),
              confirmed      = sum(confirmed),
              deaths         = sum(deaths),
              recovered      = sum(recovered),
              hosp           = sum(hosp),
              icu            = sum(icu),
              deaths_elderly = sum(deaths_elderly))
  
  # Switch by level
  if(level==1){
    
    x <- x[x$granularite=="pays" & x$source=="ministere-sante",]  
    
    # Deaths + Deaths in elderly homes
    x$deaths <- x$deaths + x$deaths_elderly 
    
  }
  if(level==2){
    
    x  <- x[x$granularite %in% c("region", "collectivite-outremer"),]
    
    x1 <- x[x$source=="opencovid19-fr",]
    x2 <- x[x$source=="agences-regionales-sante",]
    x  <- merge(x1, x2, by = c("date", "maille_code"), all = TRUE)
    
  }
  if(level==3){
    
    x <- x[x$granularite=="departement",]
    
    x1 <- x[x$source=="agences-regionales-sante",]
    x2 <- x[x$source=="sante-publique-france-data",]
    x  <- merge(x1, x2, by = c("date", "maille_code"), all = TRUE)
    
  }
  
  # fix date
  idx <- which(grepl("_", x$date, fixed = TRUE))
  if(length(idx)>0)
    x <- x[-idx,]
  
  # convert date
  x$date <- as.Date(x$date)
  
  # Done!
  return(x)
  
}
