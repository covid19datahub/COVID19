#' Ministerio de Ciencia, Tecnología, Conocimiento, e Innovación
#'
#' Data source for: Chile
#'
#' @param level 1, 2, 3
#'
#' @section Level 1:
#' - confirmed cases
#' - deaths
#' - recovered
#' - tests
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#' - hospitalizations
#' - intensive care
#' - patients requiring ventilation
#'
#' @section Level 2:
#' - confirmed cases
#' - deaths
#' - recovered
#' - tests
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#' - intensive care
#'
#' @section Level 3:
#' - confirmed cases
#' - deaths
#' - tests
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#'
#' @source https://github.com/MinCiencia/Datos-COVID19
#'
#' @keywords internal
#'
github.minciencia.datoscovid19 <- function(level) {
  if(!level %in% 1:3) return(NULL)
    
    file <- tempfile(fileext = ".zip")
    download.file("https://api.observa.minciencia.gob.cl/api/datosabiertos/download/?uuid=e26a2360-6447-47bc-8535-9b443fdff6e1&filename=datos-covid-19.zip", 
                  file, mode = "wb", quiet = TRUE)
    
    unzip_dir <- tempdir()
    unzip(file, exdir = unzip_dir)
    unlink(file) 
    
    if(level==1 | level==2){
      
    # confirmed, deaths, and recovered at regional and national level
    x.cases <- read.csv(file.path(unzip_dir, "datos-covid-19/producto3/TotalesPorRegion_std.csv"))
    # format
    x.cases <- map_data(x.cases, c(
      "Region"    = "region",
      "Fecha"     = "date",
      "Categoria" = "type",
      "Total"     = "n"
    ))
    
    # pivot
    x.cases <- x.cases %>%
      mutate(type = map_values(type, force = TRUE, map = c(
        "Casos acumulados" = "confirmed",
        "Fallecidos totales" = "deaths",
        "Casos confirmados recuperados" = "recovered"))) %>%
      filter(!is.na(type)) %>%
      pivot_wider(id_cols = c("region", "date"), names_from = "type", values_from = "n")
    
    
    # vaccination data at national and regional level
    x.vacc <- read.csv(file.path(unzip_dir, "datos-covid-19/producto76/vacunacion_std.csv"))
    # format
    x.vacc <- map_data(x.vacc, c(
      "Region"   = "region",
      "Fecha"    = "date",
      "Dosis"    = "type",
      "Cantidad" = "n"
    ))
    # compute people vaccinated
    x.vacc <- x.vacc %>%
      group_by(region, date) %>%
      summarise(
        vaccines = sum(n),
        people_vaccinated = sum(n[type %in% c("Primera", "Unica")]),
        people_fully_vaccinated = sum(n[type %in% c("Segunda", "Unica")]))
    
    if(level==1){
      
      # hospitalization data at national level
      x.hosp<- read.csv(file.path(unzip_dir, "datos-covid-19/producto24/CamasHospital_Diario_std.csv"))
      # format      
      x.hosp <- map_data(x.hosp, c(
        "fecha" = "date",
        "Tipo.de.cama" = "type",
        "Casos.confirmados" = "n"
      ))
      # compute total hospitalizations and intensive care
      x.hosp <- x.hosp %>%
        group_by(date) %>%
        summarise(
          hosp = sum(n),
          icu = sum(n[type %in% c("UTI", "UCI")]))
      
      # this file contains data on patients requiring ventilation at national level
      x.vent <- read.csv(file.path(unzip_dir, "datos-covid-19/producto30/PacientesVMI_std.csv"))
      # format
      x.vent <- map_data(x.vent, c(
        "Fecha" = "date",
        "Casos" = "type",
        "Casos.confirmados" = "n"
      ))
      # extract patients requiring ventilation
      x.vent <- x.vent %>%
        group_by(date) %>%
        summarise(vent = n[type=="Pacientes VMI"])
      
      # this file contains the total tests at national level
      x.tests <- read.csv(file.path(unzip_dir, "datos-covid-19/producto17/PCREstablecimiento_std.csv"))
      # format
      x.tests <- map_data(x.tests, c(
        "fecha" = "date",
        "Establecimiento" = "type",
        "Numero.de.PCR" = "n"
      ))
      # extract the total number of tests performed 
      x.tests <- x.tests %>%
        group_by(date) %>%
        summarise(tests = n[type=="Total realizados"])
      
      # extract national cases and vaccination data
      x.cases <- filter(x.cases, region=="Total")
      x.vacc <- filter(x.vacc, region=="Total")

      # merge
      by <- "date"
      x <- x.cases %>%
        full_join(x.vacc, by = by) %>%
        full_join(x.hosp, by = by) %>%
        full_join(x.vent, by = by) %>%
        full_join(x.tests, by = by)
      
    }
    
    if(level==2){
      
      # data on realized tests at regional level
      x.tests <- read.csv(file.path(unzip_dir,  "datos-covid-19/producto7/PCR_std.csv"))
      # format
      x.tests <- map_data(x.tests, c(
        "fecha" = "date",
        "Region" = "region",
        "numero" = "n"
      ))
      # cumulate
      x.tests <- x.tests %>%
        group_by(region) %>%
        arrange(date) %>%
        mutate(tests = cumsum(n))
      
      # intensive care at regional level
      x.icu <- read.csv(file.path(unzip_dir,  "datos-covid-19/producto8/UCI_std.csv"))
      # format
      x.icu <- map_data(x.icu, c(
        "fecha" = "date",
        "Region" = "region",
        "numero" = "icu"
      ))  
      
      # extract regional cases and vaccination data
      x.cases <- filter(x.cases, region!="Total")
      x.vacc <- filter(x.vacc, region!="Total")
      
      # merge
      by <- c("date", "region")
      x <- x.cases %>%
        full_join(x.vacc, by = by) %>%
        full_join(x.icu, by = by) %>%
        full_join(x.tests, by = by)
      
    }
    
  }
  
  if(level == 3) {

    # download
    x.pos    <-  read.csv(file.path(unzip_dir,  "datos-covid-19/producto55/Positividad_por_comuna.csv"))
    x.cases  <-  read.csv(file.path(unzip_dir,  "datos-covid-19/producto1/Covid-19_std.csv"))
    x.deaths <-  read.csv(file.path(unzip_dir,  "datos-covid-19/producto38/CasosFallecidosPorComuna_std.csv"))
    x.vacc.0 <-  read.csv(file.path(unzip_dir,  "datos-covid-19/producto80/vacunacion_comuna_UnicaDosis_std.csv"))
    x.vacc.1 <-  read.csv(file.path(unzip_dir,  "datos-covid-19/producto80/vacunacion_comuna_1eraDosis_std.csv"))
    x.vacc.2 <-  read.csv(file.path(unzip_dir,  "datos-covid-19/producto80/vacunacion_comuna_2daDosis_std.csv"))
    x.vacc.3 <-  read.csv(file.path(unzip_dir,  "datos-covid-19/producto80/vacunacion_comuna_Refuerzo_std.csv"))
    
    # format positivity rate
    x.pos <- map_data(x.pos, c(
      "Codigo.comuna" = "municipality",
      "fecha" = "date",
      "positividad" = "positivity"
    )) %>%
      mutate(date = as.Date(date))
    
    # format cases
    x.cases <- map_data(x.cases, c(
      "Codigo.comuna" = "municipality",
      "Fecha" = "date",
      "Casos.confirmados" = "confirmed"
    )) %>%
      mutate(date = as.Date(date, format = "%d-%m-%Y"))
    
    # format deaths
    x.deaths <- map_data(x.deaths, c(
      "Codigo.comuna" = "municipality",
      "Fecha" = "date",
      "Casos.fallecidos" = "deaths"
    )) %>%
      mutate(date = as.Date(date))
    
    # format one shot vaccine dose
    x.vacc.0 <- map_data(x.vacc.0, c(
      "Fecha" = "date",
      "Codigo.comuna" = "municipality",
      "Unica.Dosis" = "oneshot"
    )) %>%
      mutate(date = as.Date(date))
    
    # format first vaccine dose
    x.vacc.1 <- map_data(x.vacc.1, c(
      "Fecha" = "date",
      "Codigo.comuna" = "municipality",
      "Primera.Dosis" = "first"
    )) %>%
      mutate(date = as.Date(date))
    
    # format second vaccine dose
    x.vacc.2 <- map_data(x.vacc.2, c(
      "Fecha" = "date",
      "Codigo.comuna" = "municipality",
      "Segunda.Dosis" = "second"
    )) %>%
      mutate(date = as.Date(date))
    
    # format extra vaccine dose
    x.vacc.3 <- map_data(x.vacc.3, c(
      "Fecha" = "date",
      "Codigo.comuna" = "municipality",
      "Dosis.Refuerzo" = "extra"
    )) %>%
      mutate(date = as.Date(date))
    
    # drop non-geographical entities
    x.pos    <- filter(x.pos,    !is.na(municipality))
    x.cases  <- filter(x.cases,  !is.na(municipality))
    x.deaths <- filter(x.deaths, !is.na(municipality))
    x.vacc.0 <- filter(x.vacc.0, !is.na(municipality))
    x.vacc.1 <- filter(x.vacc.1, !is.na(municipality))
    x.vacc.2 <- filter(x.vacc.2, !is.na(municipality))
    x.vacc.3 <- filter(x.vacc.3, !is.na(municipality))
    
    # merge
    by <- c("date", "municipality")
    x <- x.cases %>%
      full_join(x.pos,    by = by) %>%
      full_join(x.deaths, by = by) %>%
      full_join(x.vacc.0, by = by) %>%
      full_join(x.vacc.1, by = by) %>%
      full_join(x.vacc.2, by = by) %>%
      full_join(x.vacc.3, by = by) 
    
    # vaccines and tests
    x <- x %>%
      mutate(
        # total positive cases = confirmed cases
        pos_tot = confirmed,
        # drop negative and unfeasible values of positivity rate
        positivity = replace(positivity, positivity < 1e-4, NA)) %>%
      # for each municipality
      group_by(municipality) %>%
      # order by date
      arrange(date) %>%
      # replace missing positives with the previous value
      fill(pos_tot) %>%
      mutate(
        # compute vaccines and people vaccinated
        vaccines = cumsum(first + second + oneshot + extra),
        people_vaccinated = cumsum(first + oneshot),
        people_fully_vaccinated = cumsum(second + oneshot),
        # compute daily positive
        pos_new = pmax(0, c(NA, diff(pos_tot))),
        ma7 = sapply(1:n(), function(i) {
          if (i < 7) return(NA)
          mean(pos_new[max(1, i-6):i], na.rm = TRUE)
        }),
        tests = ma7 / positivity,
        tests = as.integer(cumsum(tests)),
        tests = replace(tests, is.na(confirmed) | confirmed > tests, NA)
        )
      
  }
  
  # convert date
  x$date <- as.Date(x$date)
    
  return(x)
}
