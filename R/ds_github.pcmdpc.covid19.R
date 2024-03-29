#' Ministero della Salute
#'
#' Data source for: Italy
#'
#' @param level 1, 2, 3
#'
#' @section Level 1:
#' - confirmed cases
#' - deaths
#' - recovered
#' - tests
#' - hospitalizations
#' - intensive care
#'
#' @section Level 2:
#' - confirmed cases
#' - deaths
#' - recovered
#' - tests
#' - hospitalizations
#' - intensive care
#'
#' @section Level 3:
#' - confirmed cases
#'
#' @source https://github.com/pcm-dpc/COVID-19
#' 
#' @keywords internal
#'
github.pcmdpc.covid19 <- function(level){
  if(!level %in% 1:3) return(NULL)
                             
  # source
  repo <- "https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/"
  urls <- c(
    "dati-andamento-nazionale/dpc-covid19-ita-andamento-nazionale.csv",
    "dati-regioni/dpc-covid19-ita-regioni.csv",
    "dati-province/dpc-covid19-ita-province.csv"
  )

  # download
  url <- sprintf("%s/%s", repo, urls[level])
  x   <- read.csv(url)

  # date
  d <- as.Date(x$data, format = "%Y-%m-%d %H:%M:%S")
  if(all(is.na(d)))
    d <- as.Date(x$data, format = "%Y-%m-%dT%H:%M:%S")
  x$date <- d

  # filter
  if(!is.null(x$lat) & !is.null(x$long))
    x <- x[which(x$lat!=0 | x$long!=0),]
  
  # formatting
  x <- map_data(x, c(
    'date',
    'denominazione_regione'   = 'state', 
    'codice_regione'          = 'state_code',
    'sigla_provincia'         = 'city',
    'codice_provincia'        = 'city_code',
    'tamponi'                 = 'tests', 
    'totale_casi'             = 'confirmed', 
    'deceduti'                = 'deaths',        
    'dimessi_guariti'         = 'recovered',     
    'totale_ospedalizzati'    = 'hosp',
    'terapia_intensiva'       = 'icu' 
  ))
  
  return(x)
}
