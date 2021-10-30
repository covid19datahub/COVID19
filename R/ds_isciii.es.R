#' Centro Nacional de Epidemiología
#'
#' Data source for: Spain
#'
#' @param level 2, 3
#'
#' @section Level 2:
#' - confirmed cases
#'
#' @section Level 3:
#' - confirmed cases
#' - deaths
#' - hospitalizations
#' - intensive care
#'
#' @source https://cnecovid.isciii.es/covid19/#documentaci%C3%B3n-y-datos
#'
#' @keywords internal
#'
isciii.es <- function(level) {
  if(!level %in% 2:3) return(NULL)
  
  if(level==2){
    
    # download cases
    url <- 'https://cnecovid.isciii.es/covid19/resources/casos_diag_ccaadecl.csv'
    x   <- read.csv(url)
    
    # format cases
    x <- map_data(x, c(
      "fecha"     = "date",
      "ccaa_iso"  = "state",
      "num_casos" = "confirmed")) 
    
    # cases
    x <- x %>%
      group_by(state) %>%
      arrange(date) %>%
      mutate(confirmed = cumsum(confirmed))
    
    # date
    x$date <- as.Date(x$date)
    
  }
  
  if(level==3) {
    
    # download cases
    url <- 'https://cnecovid.isciii.es/covid19/resources/casos_hosp_uci_def_sexo_edad_provres.csv'
    x <- read.csv(url)
    
    # format cases
    x <- map_data(x, c(
      "fecha"          = "date",
      "provincia_iso"  = "district",
      "num_casos"      = "confirmed",
      "num_hosp"       = "hosp",
      "num_uci"        = "icu",
      "num_def"        = "deaths")) 
    
    # cases
    x <- x %>%
      # remove unassigned
      filter(district!="NC") %>%
      # for each date and district
      group_by(date, district) %>%
      # compute total counts
      summarise(
        confirmed = sum(confirmed),
        hosp = sum(hosp),
        icu = sum(icu),
        deaths = sum(deaths)) %>%
      # group by district
      group_by(district) %>%
      # sort by date
      arrange(date) %>%
      # cumulate
      mutate(
        confirmed = cumsum(confirmed),
        deaths = cumsum(deaths))
    
    # date
    x$date <- as.Date(x$date)
    
  }
  
  return(x)
}
