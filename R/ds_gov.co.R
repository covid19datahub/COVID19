#' Instituto Nacional de Salud
#'
#' Data source for: Colombia
#'
#' @param level 1, 2, 3
#'
#' @section Level 1:
#' - confirmed cases
#' - deaths
#' - recovered
#'
#' @section Level 2:
#' - confirmed cases
#' - deaths
#' - recovered
#' 
#' @section Level 3:
#' - confirmed cases
#' - deaths
#' - recovered
#'
#' @source https://www.datos.gov.co/browse?category=Salud+y+Protecci%C3%B3n+Social&q=covid&sortBy=relevance
#'
#' @keywords internal
#'
gov.co <- function(level){
  if(!level %in% 1:3) return(NULL)
 
  # confirmed, recovered, deaths
  # the number of rows in this file matches the number of confirmed cases reported by other sources (e.g. JHU)
  # this file can be aggregated to compute confirmed, recovered, and deaths at all levels
  # see https://www.datos.gov.co/Salud-y-Protecci-n-Social/Casos-positivos-de-COVID-19-en-Colombia/gt2j-8ykr
  url <- 'https://www.datos.gov.co/resource/gt2j-8ykr.csv?$limit=9999999999'
  x.cases <- read.csv(url, encoding = "UTF-8")
  # format
  x.cases <- map_data(x.cases, c(
    'fecha_reporte_web'     = 'date_confirmed',
    'fecha_muerte'          = 'date_deaths',
    'fecha_recuperado'      = 'date_recovered',
    'departamento'          = 'state_code',
    'ciudad_municipio'      = 'city_code',
    'departamento_nom'      = 'state',
    'ciudad_municipio_nom'  = 'city'
  ))
  # compute cumulative cases, deaths, and recovered
  x.cases <- x.cases %>%
    # pivot
    pivot_longer(cols = starts_with("date"), names_to = "type", values_to = "date", values_drop_na = TRUE, names_prefix = "date_") %>%
    # convert date
    mutate(date = as.Date(date)) %>%
    # keep only valid dates
    filter(!is.na(date)) %>%
    # group by city, date, and type of metrics
    group_by(state_code, city_code, date, type) %>%
    # compute the counts for each metric
    summarise(n = n())
  
    if(level==1){
      
      # confirmed, recovered, deaths
      x <- x.cases %>%
        group_by(date, type) %>%
        summarise(n = sum(n)) %>%
        group_by(type) %>%
        arrange(date) %>%
        mutate(n = cumsum(n)) %>%
        pivot_wider(id_cols = "date", names_from = "type", values_from = "n")
    }
  
    if(level==2){
      # confirmed, recovered, deaths
      x <- x.cases %>%
        filter(!state_code %in% c(13001, 8001, 47001)) %>%
        group_by(date, state_code, type) %>%
        summarise(n = sum(n)) %>%
        group_by(type, state_code) %>%
        arrange(date) %>%
        mutate(n = cumsum(n)) %>%
        pivot_wider(id_cols = c("date", "state_code"), names_from = "type", values_from = "n")
      
      # map code to state       
      db <- extdata("db/COL.csv")
      
      idx <- which(db$administrative_area_level==2)
      map <- db$id_gov.co[idx]
      names(map) <- as.integer(db$key_local[idx])
      x$state <- map_values(x$state_code, map = map)
    
  }
  
  if(level==3){
    # confirmed, recovered, deaths
    x <- x.cases %>%
      group_by(type, city_code) %>%
      arrange(date) %>%
      mutate(n = cumsum(n)) %>%
      pivot_wider(id_cols = c("date", "city_code"), names_from = "type", values_from = "n")
    
  }
  
  return(x)
}
