gov_lv <- function(cache, level){
  # author: Martin Benes
  
  # source: Centre for Disease Prevention and Control (CDPC), Latvia
  if(level==1)
    url <- 'https://data.gov.lv/dati/dataset/f01ada0a-2e77-4a82-8ba2-09cf0cf90db3/resource/d499d2f0-b1ea-4ba2-9600-2c701b03bd4a/download/covid_19_izmeklejumi_rezultati.csv'
  if(level==2)
    url <- 'https://data.gov.lv/dati/dataset/e150cc9a-27c1-4920-a6c2-d20d10469873/resource/492931dd-0012-46d7-b415-76fe0ec7c216/download/covid_19_pa_adm_terit.csv'
  
  # download
  x <- read.csv(url, sep = ";", cache = cache, encoding = "UTF-8")
  
  # date
  colnames(x)[1] <- "date"
  
  # format
  if(level==1){
    
    x <- map_data(x, c(
      'date',
      'TestuSkaits'                                 = 'tests',
      'ApstiprinataCOVID19InfekcijaSkaits'          = 'confirmed',
      'IzarstetoPacientuSkaits'                     = 'hosp',
      'MirusoPersonuSkaits'                         = 'deaths'
    ))

    x$date         <- as.Date(x$date, format="%Y.%m.%d.")
    x$confirmed    <- cumsum(x$confirmed)
    x$tests        <- cumsum(x$tests)
    x$deaths       <- cumsum(x$deaths)
    
  }
  if(level==2){
    
    x <- map_data(x, c(
      'date',
      'region_id',
      'AdministrativiTeritorialasVienibasNosaukums' = 'region',
      'ATVK'                                        = 'region_id',
      'ApstiprinataCOVID19infekcija'                = 'confirmed'
    ))
    
    # date
    x$date <- as.Date(x$date, format="%Y.%m.%d.")
    
    # remove country reports from region reports
    x <- x[which(x$region_id != 'Nav'),]
    
    # replace range
    idx <- grepl("^no 1", x = x$confirmed)
    x$confirmed[idx] <- 1 
    x$confirmed <- as.integer(x$confirmed)
    x$region_id <- as.integer(x$region_id)
    
  }
  
  return(x)
  
}
