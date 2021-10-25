#' Specialist Unit for Open Government Data Canton of Zurich
#'
#' Data source for: Switzerland and Liechtenstein
#'
#' @param level 1 (only for Liechtenstein), or 2 (only for Switzerland)
#' @param state one of CH (Switzerland) or FL (Liechtenstein)
#'
#' @section Level 1:
#' - confirmed cases
#' - deaths
#' - recovered
#' - tests
#' - hospitalizations
#' - intensive care
#' - patients requiring ventilation
#'
#' @section Level 2:
#' - confirmed cases
#' - deaths
#' - recovered
#' - tests
#' - hospitalizations
#' - intensive care
#' - patients requiring ventilation
#'
#' @source https://github.com/openZH/covid_19
#'
#' @keywords internal
#'
github.openzh.covid19 <- function(level, state){
  if(state=="FL" & level!=1) return(NULL)
  if(state=="CH" & level!=2) return(NULL)
  
  # download
  url <- "https://raw.githubusercontent.com/openZH/covid_19/master/COVID19_Fallzahlen_CH_total_v2.csv"
  x <- read.csv(url)

  # formatting
  x <- map_data(x, c(
    'date',
    'abbreviation_canton_and_fl' = 'code',
    'ncumul_conf'                = 'confirmed',
    'ncumul_tested'              = 'tests',
    'ncumul_deceased'            = 'deaths',
    'ncumul_released'            = 'recovered',
    'current_hosp'               = 'hosp',
    'current_icu'                = 'icu',
    'current_vent'               = 'vent'  
  ))

  # filter by state
  if(state=="FL")
    x <- x[which(x$code=="FL"),]
  if(state=="CH")
    x <- x[which(x$code!="FL"),]

  # convert date
  x$date <- as.Date(x$date)

  return(x)
}
