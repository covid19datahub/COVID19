cdpc <- function(cache, level){
  # author: Martin Benes
  
  # source: Centre for Disease Prevention and Control (CDPC), Latvia
  if(level==1)
    url <- 'https://data.gov.lv/dati/dataset/f01ada0a-2e77-4a82-8ba2-09cf0cf90db3/resource/d499d2f0-b1ea-4ba2-9600-2c701b03bd4a/download/covid_19_izmeklejumi_rezultati.csv'
  if(level==2)
    url <- 'https://data.gov.lv/dati/dataset/e150cc9a-27c1-4920-a6c2-d20d10469873/resource/492931dd-0012-46d7-b415-76fe0ec7c216/download/covid_19_pa_adm_terit.csv'
  
  # download
  x <- read.csv(url, sep = ";", cache = cache, fileEncoding = "UTF-8-BOM")
  
  # format
  if(level==1){
    
    x <- reduce(x, c(
      'Datums'                                      = 'date',
      'TestuSkaits'                                 = 'tests',
      'ApstiprinataCOVID19InfekcijaSkaits'          = 'confirmed',
      'IzarstetoPacientuSkaits'                     = 'hospitalized',
      'MirusoPersonuSkaits'                         = 'deaths'
    ))

    x$date         <- as.Date(x$date, format="%Y.%m.%d.")
    x$confirmed    <- cumsum(x$confirmed)
    x$tests        <- cumsum(x$tests)
    x$hospitalized <- cumsum(x$hospitalized)
    x$deaths       <- cumsum(x$deaths)
    
  }
  if(level==2){
    
    x <- reduce(x, c(
      'region_id',
      'Datums'                                      = 'date',
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
    x$confirmed[idx] <- 3 
    x$confirmed <- as.integer(x$confirmed)
    
    # bindings
    region_id <- confirmed <- NULL
    # replace counts per region with cumulative sums
    x <- x %>% 
      dplyr::group_by(region_id) %>%
      dplyr::arrange(date) %>%
      dplyr::mutate(confirmed = cumsum(confirmed))

  }
  
  return(x)
  
}
