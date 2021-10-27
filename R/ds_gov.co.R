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
#' - tests
#'
#' @section Level 2:
#' - confirmed cases
#' - deaths
#' - recovered
#' - tests
#' 
#' @section Level 3:
#' - confirmed cases
#' - deaths
#' - recovered
#' - people with at least one vaccine dose
#' - people fully vaccinated
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
    mutate(date = as.Date(date, format = "%d/%m/%Y")) %>%
    # keep only valid dates
    filter(!is.na(date)) %>%
    # group by city, date, and type of metrics
    group_by(state_code, city_code, date, type) %>%
    # compute the counts for each metric
    summarise(n = n())
  
  if(level==1 | level==2){
    
    # pcr tests
    # see https://www.datos.gov.co/Salud-y-Protecci-n-Social/Pruebas-PCR-procesadas-de-COVID-19-en-Colombia-Dep/8835-5baf
    url <- 'https://www.datos.gov.co/resource/8835-5baf.csv?$limit=9999999999'
    x.pcr <- read.csv(url, encoding="UTF-8")
    # format and sanitize
    x.pcr <- x.pcr %>%
      rename(date = fecha) %>%
      mutate(date = as.Date(date, format = "%Y-%m-%d")) %>%
      filter(!is.na(date)) %>%
      select(-c("cartagena", "barranquilla", "santa_marta",
                "indeterminadas", "procedencia_desconocida",
                "positivas_acumuladas", "negativas_acumuladas", 
                "positividad_acumulada")) %>%
      pivot_longer(cols = -1, names_to = 'state', values_to = 'n', values_drop_na = TRUE)
    
    # antigen tests
    # see https://www.datos.gov.co/Salud-y-Protecci-n-Social/Ant-geno-procesadas-de-COVID-19-en-Colombia-Depart/ci85-cyhe
    url <- 'https://www.datos.gov.co/resource/ci85-cyhe.csv?$limit=9999999999'
    x.ant <- read.csv(url, encoding="UTF-8")
    # format and sanitize (make names compatible with the PCR dataset)
    x.ant <- x.ant %>%
      rename(
        date = mes,
        narino = nari_o, 
        norte_de_santander = norte_santander,
        bogota = bogota_dc) %>%
      mutate(date = as.Date(date, format = "%Y-%m-%d")) %>%
      filter(!is.na(date)) %>%
      pivot_longer(cols = -1, names_to = 'state', values_to = 'n', values_drop_na = TRUE)
    
    if(level==1){
      
      # confirmed, recovered, deaths
      x.cases <- x.cases %>%
        group_by(date, type) %>%
        summarise(n = sum(n)) %>%
        group_by(type) %>%
        arrange(date) %>%
        mutate(n = cumsum(n)) %>%
        pivot_wider(id_cols = "date", names_from = "type", values_from = "n")
      
      # pcr tests
      x.pcr <- x.pcr %>%
        filter(state=="acumuladas") %>%
        rename(pcr = n)
      
      # antigen tests
      x.ant <- x.ant %>%
        group_by(date) %>%
        summarise(antigen = sum(n))
      
      # merge 
      by <- "date"
      x <- x.cases %>%
        full_join(x.pcr, by = by) %>%
        full_join(x.ant, by = by) %>%
        mutate(tests = antigen + pcr)
      
    }
    
    if(level==2){
      
      # confirmed, recovered, deaths
      x.cases <- x.cases %>%
        filter(!state_code %in% c(13001, 8001, 47001)) %>%
        group_by(date, state_code, type) %>%
        summarise(n = sum(n)) %>%
        group_by(type, state_code) %>%
        arrange(date) %>%
        mutate(n = cumsum(n)) %>%
        pivot_wider(id_cols = c("date", "state_code"), names_from = "type", values_from = "n")

      # pcr tests
      x.pcr <- x.pcr %>%
        filter(state!="acumuladas") %>%
        rename(pcr = n)
      
      # antigen tests
      x.ant <- x.ant %>%
        rename(antigen = n)
      
      # map code to state as used in the PCR and antigen datasets      
      db <- extdata("db/COL.csv")
      idx <- which(db$administrative_area_level==2)
      map <- db$id_gov.co[idx]
      names(map) <- as.integer(db$key_local[idx])
      x.cases$state <- map_values(x.cases$state_code, map = map)
      
      # merge 
      by <- c("date", "state")
      x <- x.cases %>%
        full_join(x.pcr, by = by) %>%
        full_join(x.ant, by = by) %>%
        mutate(tests = antigen + pcr)
      
    }
    
  }
  
  if(level==3){
    
    # this file does not sum up to the vaccines for level 1 (from e.g. Our World in Data)
    # use only for level 3 as it is: do not aggregate to upper levels
    # see https://www.datos.gov.co/Salud-y-Protecci-n-Social/Coberturas-de-Vacunaci-n-contra-COVID-19/8cgj-t5ds
    url <- 'https://www.datos.gov.co/resource/8cgj-t5ds.csv?$limit=9999999999'
    x.vacc <- read.csv(url, encoding="UTF-8")
    # format
    x.vacc <- map_data(x.vacc, c(
      "fecha_de_corte"     = "date",
      "municipio_divipola" = "city_code",
      "grupo_edad"         = "age",
      "n_mero_acumulado_de_1_dosis" = "people_vaccinated",
      "n_mero_acumulado_de_esquema" = "people_fully_vaccinated"
    ))
    # sanitize
    x.vacc <- x.vacc %>%
      mutate(date = as.Date(date, format = "%Y-%m-%d")) %>%
      filter(age=="Todas" & city_code!="No definido" & !is.na(date)) %>%
      mutate(city_code = as.integer(city_code))
      
    # confirmed, recovered, deaths
    x.cases <- x.cases %>%
      group_by(type, city_code) %>%
      arrange(date) %>%
      mutate(n = cumsum(n)) %>%
      pivot_wider(id_cols = c("date", "city_code"), names_from = "type", values_from = "n")
    
    # merge
    by <- c("date", "city_code")
    x <- x.cases %>%
      full_join(x.vacc, by = by)
    
  }
  
  return(x)
}
