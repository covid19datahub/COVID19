#' Argentine Ministry of Health
#'
#' Data source for: Argentina
#'
#' @param level 1, 2, 3
#'
#' @section Level 1:
#' - confirmed cases
#' - deaths
#' - tests
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#'
#' @section Level 2:
#' - confirmed cases
#' - deaths
#' - tests
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#' 
#' @section Level 3:
#' - confirmed cases
#' - deaths
#' - tests
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#' 
#' @source https://datos.gob.ar/dataset?q=covid&tags=COVID-19&sort=metadata_modified+desc
#'
#' @keywords internal
#'
gob.ar <- function(level){
  if(!level %in% 1:3) return(NULL)
  
  # group by level
  if(level==1)
    by <- NULL
  if(level==2)
    by <- "prov"
  if(level==3)
    by <- "dep"
  
  # download cases 
  # see https://datos.gob.ar/dataset/salud-covid-19-casos-registrados-republica-argentina
  url.cases <- "https://sisa.msal.gov.ar/datos/descargas/covid-19/files/Covid19Casos.zip"
  x.cases <- read.zip(url.cases, files = "Covid19Casos.csv", method = "wget", xsv = TRUE, 
                      select = c("clasificacion_resumen", "fecha_apertura", "fecha_fallecimiento",
                                 "residencia_provincia_id", "residencia_departamento_id"))
  
  # format cases
  x.cases <- map_data(x.cases[[1]], c(
    "clasificacion_resumen" = "type",
    "fecha_apertura" = "date_confirmed",
    "fecha_fallecimiento" = "date_deaths",
    "residencia_provincia_id" = "prov",
    "residencia_departamento_id" = "dep"
  ))
  
  # sanitize cases
  x.cases <- x.cases[x.cases$type=="Confirmado",]
  x.cases$prov <- sprintf("%.02d", x.cases$prov)
  x.cases$dep <- paste0(x.cases$prov, sprintf("%.03d", x.cases$dep))
  
  # compute confirmed
  x.confirmed <- x.cases %>%
    rename(date = date_confirmed) %>%
    group_by_at(c("date", by)) %>%
    summarize(confirmed = n()) %>%
    group_by_at(by) %>%
    arrange(date) %>%
    mutate(confirmed = cumsum(confirmed))
  
  # compute deaths
  x.deaths <- x.cases %>%
    rename(date = date_deaths) %>%
    filter(!is.na(date)) %>%
    group_by_at(c("date", by)) %>%
    summarize(deaths = n()) %>%
    group_by_at(by) %>%
    arrange(date) %>%
    mutate(deaths = cumsum(deaths))
  
  # download tests
  # see https://datos.gob.ar/dataset/salud-covid-19-determinaciones-registradas-republica-argentina
  url.tests <- "https://sisa.msal.gov.ar/datos/descargas/covid-19/files/Covid19Determinaciones.zip"
  x.tests <- read.zip(url.tests, files = "Covid19Determinaciones.csv", fread = TRUE)
  
  # format tests
  x.tests <- map_data(x.tests[[1]], c(
    "fecha" = "date",
    "codigo_indec_provincia" = "prov",
    "codigo_indec_departamento" = "dep",
    "positivos" = "confirmed",
    "total" = "tests"
  ))
  
  # sanitize tests
  x.tests$prov <- sprintf("%.02d", x.tests$prov)
  x.tests$dep <- paste0(x.tests$prov, sprintf("%.03d", x.tests$dep))
  
  # compute tests
  x.tests <- x.tests %>%
    group_by_at(c("date", by)) %>%
    summarise(tests = sum(tests),
              confirmed = sum(confirmed)) %>%
    group_by_at(by) %>%
    arrange(date) %>%
    mutate(tests = cumsum(tests),
           confirmed = cumsum(confirmed))
  
  # download vaccines
  # see https://datos.gob.ar/dataset/salud-vacunas-contra-covid-19-dosis-aplicadas-republica-argentina---registro-desagregado
  url.vacc <- "https://sisa.msal.gov.ar/datos/descargas/covid-19/files/datos_nomivac_covid19.zip"
  x.vacc <- read.zip(url.vacc, files = "datos_nomivac_covid19.csv", method = "wget", xsv = TRUE, 
                     select = c("fecha_aplicacion", "jurisdiccion_residencia_id", "depto_residencia_id", "orden_dosis"))
  
  # format vaccines
  x.vacc <- map_data(x.vacc[[1]], c(
    "fecha_aplicacion" = "date",
    "jurisdiccion_residencia_id" = "prov",
    "depto_residencia_id" = "dep",
    "orden_dosis" = "dose"
  ))
  
  # sanitize vaccines
  x.vacc$prov <- sprintf("%.02d", x.vacc$prov)
  x.vacc$dep <- paste0(x.vacc$prov, sprintf("%.03d", x.vacc$dep))
  
  # compute vaccines
  x.vacc <- x.vacc %>%
    group_by_at(c("date", by)) %>%
    summarize(vaccines = n(),
              people_vaccinated = sum(dose==1),
              people_fully_vaccinated = sum(dose==2)) %>%
    group_by_at(by) %>%
    arrange(date) %>%
    mutate(vaccines = cumsum(vaccines),
           people_vaccinated = cumsum(people_vaccinated),
           people_fully_vaccinated = cumsum(people_fully_vaccinated))
  
  # merge
  x <- x.deaths %>%
    full_join(x.tests, by = c("date", by)) %>%
    full_join(x.vacc, by = c("date", by))
  
  # confirmed tests are reported by testing location, confirmed cases by residence.
  # we need confirmed tests to be compatible with the number of tests at level 3.
  # for levels 1 and 2, it doesn't make much difference and we can use confirmed cases that have a longer history.
  # if level!=3 use confirmed cases instead of confirmed tests.
  if(level!=3){
    x <- x %>%
      select(-confirmed) %>%
      full_join(x.confirmed, by = c("date", by))
  }
  
  # convert date and sanitize
  x <- x %>%
    mutate(date = as.Date(date)) %>%
    filter(!is.na(date) & date>="2020-01-01")

  # fill missing values originated by the merge
  x <- x %>%
    # for each group
    group_by_at(by) %>%
    # sort by date
    arrange(date) %>%
    # fill with previous value
    fill(confirmed, deaths, tests, vaccines, people_vaccinated, people_fully_vaccinated) %>%
    # ungroup
    ungroup() %>%
    # set to missing if date greater than the corresponding max date
    mutate(confirmed = replace(confirmed, date>max(x.confirmed$date), NA),
           deaths = replace(deaths, date>max(x.deaths$date), NA),
           tests = replace(tests, date>max(x.tests$date), NA),
           vaccines = replace(vaccines, date>max(x.vacc$date), NA),
           people_vaccinated = replace(people_vaccinated, date>max(x.vacc$date), NA),
           people_fully_vaccinated = replace(people_fully_vaccinated, date>max(x.vacc$date), NA))
  
  # drop unassigned provinces
  if(level==2){
    x <- x %>% 
      filter(prov!="99" & prov!="00") %>%
      mutate(prov = as.integer(prov))
  }
  
  # drop unassigned departments
  if(level==3){
    x <- x %>% 
      filter(!startsWith(dep, "99") & !endsWith(dep, "999") & !startsWith(dep, "00") & !endsWith(dep, "000")) %>%
      mutate(dep = as.integer(dep))
  }
  
  return(x)
}
