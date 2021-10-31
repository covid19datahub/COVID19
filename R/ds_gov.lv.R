#' Center for Disease Prevention and Control
#'
#' Data source for: Latvia
#'
#' @param level 1, 3
#'
#' @section Level 1:
#' - confirmed cases
#' - deaths
#' - tests
#'
#' @section Level 3:
#' - confirmed cases
#'
#' @source https://data.gov.lv/dati/eng/dataset?q=covid&res_format=CSV&sort=score+desc%2C+metadata_modified+desc
#'
#' @keywords internal
#'
gov.lv <- function(level){
  if(level!=1 & level!=3) return(NULL)
  
  if(level==1){
    
    # cases
    # see https://data.gov.lv/dati/eng/dataset/covid-19
    url <- 'https://data.gov.lv/dati/dataset/f01ada0a-2e77-4a82-8ba2-09cf0cf90db3/resource/d499d2f0-b1ea-4ba2-9600-2c701b03bd4a/download/covid_19_izmeklejumi_rezultati.csv'
    x <- read.csv(url, sep = ";")
    
    # format cases
    x <- map_data(x, c(
      'Datums' = "date",
      'TestuSkaits' = 'tests',
      'ApstiprinataCOVID19InfekcijaSkaits' = 'confirmed',
      'MirusoPersonuSkaits' = 'deaths'
    ))
    
    # cumulate
    x <- x %>%
      arrange(date) %>%
      mutate(across(c("confirmed", "deaths", "tests"), cumsum))
    
    # convert date
    x$date <- as.Date(x$date, format="%Y.%m.%d.")
    
  }
  
  if(level==3){
    
    # cases
    # see https://data.gov.lv/dati/eng/dataset/covid-19-pa-adm-terit
    url <- 'https://data.gov.lv/dati/dataset/e150cc9a-27c1-4920-a6c2-d20d10469873/resource/492931dd-0012-46d7-b415-76fe0ec7c216/download/covid_19_pa_adm_terit.csv'
    x <- read.csv(url, sep = ";", fileEncoding = "UTF-8-BOM", encoding = "Latin1")
    
    # format cases
    x <- map_data(x, c(
      'Datums' = 'date',
      'AdministrativiTeritorialasVienibasNosaukums' = 'region',
      'ATVK' = 'atvk',
      'ApstiprinataCOVID19infekcija' = 'confirmed'
    ))
    
    # remove country reports from region reports
    x <- x[which(x$atvk != 'Nav'),]
    
    # replace range
    x$confirmed <- replace(x$confirmed, grepl("^no 1", x$confirmed), 1)
    
    # convert types
    x$date <- as.Date(x$date, format="%Y.%m.%d.")
    x$confirmed <- as.integer(x$confirmed)
    x$atvk <- as.integer(x$atvk)
    
  }
  
  return(x)
}
