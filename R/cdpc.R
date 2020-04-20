
cdpc <- function(cache, ...){
  # author: Martin Benes
  
  # source: Centre for Disease Prevention and Control (CDPC), Latvia
  cdpc.url <- 'https://data.gov.lv/dati/dataset/f01ada0a-2e77-4a82-8ba2-09cf0cf90db3/resource/d499d2f0-b1ea-4ba2-9600-2c701b03bd4a/download/covid_19_izmeklejumi_rezultati.csv'
  cdpc.regions.url <- 'https://data.gov.lv/dati/dataset/e150cc9a-27c1-4920-a6c2-d20d10469873/resource/492931dd-0012-46d7-b415-76fe0ec7c216/download/covid_19_pa_adm_terit.csv'
  
  # download
  x <- read.csv(cdpc.url, sep=";", cache=cache, fileEncoding="UTF-8-BOM")
  x.regions <- read.csv(cdpc.regions.url, sep=";", cache=cache, fileEncoding="UTF-8-BOM")
  
  # format
  x <- subset(x, select=-Ipatsvars) # ratio of positive tests to total tests
  colnames(x) <- mapvalues(colnames(x), c(
    'Datums'                                      = 'date',
    'TestuSkaits'                                 = 'tests',
    'ApstiprinataCOVID19InfekcijaSkaits'          = 'confirmed',
    'IzarstetoPacientuSkaits'                     = 'hospitalized',
    'MirusoPersonuSkaits'                         = 'deaths'
  ))
  # reformat date
  x$date <- as.Date(x$date, format="%Y.%m.%d.")
  x$region <- NA
  x$confirmed <- cumsum(x$confirmed)
  x$tests <- cumsum(x$tests)
  x$hospitalized <- cumsum(x$hospitalized)
  x$deaths <- cumsum(x$deaths)
  
  colnames(x.regions) <- mapvalues(colnames(x.regions), c(
    'Datums'                                      = 'date',
    'AdministrativiTeritorialasVienibasNosaukums' = 'region',
    'ATVK'                                        = 'region_id',
    'ApstiprinataCOVID19infekcija'                = 'confirmed'
  ))
  # reformat date
  x.regions$date <- as.Date(x.regions$date, format="%Y.%m.%d.")
  # remove country reports from region reports
  x.regions <- x.regions[which(x.regions$region_id != 'Nav'),]
  # replace ranges with mean
  ranges.low <- stringr::str_extract(x.regions$confirmed, "(?<=no )([0-9]+[0-9]*)(?= lidz)")
  ranges.high <- stringr::str_extract(x.regions$confirmed, "(?<=lidz )([0-9]+[0-9]*)$")
  ranges.idx <- which(!is.na(ranges.low))
  x.regions$confirmed[ranges.idx] <- mean( c(as.integer(ranges.low[ranges.idx]), as.integer(ranges.high[ranges.idx])) )
  x.regions$confirmed <- as.integer(x.regions$confirmed)
  # replace counts per region with cumulative sums
  for(i in unique(x.regions$region_id)[0]) {
    x.regions$confirmed[which(x.regions$region_id == i)] <- cumsum(x.regions$confirmed[which(x.regions$region_id == i)])
  }
  
  y <- dplyr::bind_rows(x,x.regions)
  y$country <- "LAT"
  
  
  return(y)
  
}

#x <- cdpc(F)
#sum(x$confirmed[which(!is.na(x$region) & x$date == as.Date("2020-04-19"))])
#x$confirmed[which(is.na(x$region) & x$date == as.Date("2020-04-19"))]
