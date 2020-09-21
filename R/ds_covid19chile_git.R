covid19chile_git <- function(level, cache) {
  
  if(level == 1) {
    
    # url
    url           <- "https://raw.githubusercontent.com/MinCiencia/Datos-COVID19/master/output/producto5/TotalesNacionales_T.csv"
    url.icu       <- "https://raw.githubusercontent.com/MinCiencia/Datos-COVID19/master/output/producto9/HospitalizadosUCIEtario_T.csv"
    url.crit      <- "https://raw.githubusercontent.com/MinCiencia/Datos-COVID19/master/output/producto23/PacientesCriticos_T.csv"
    # download
    x           <- read.csv(url, cache = cache)
    x.icu       <- read.csv(url.icu, cache = cache)
    x.crit      <- read.csv(url.crit, cache = cache)
    x.recovered <- read.csv(url.recovered, cache = cache)
    
    # parse
    x <- map_data(x, c(
      "Fecha"             = "date",
      "Casos.totales"     = "confirmed",
      "Casos.recuperados" = "recovered",
      "Fallecidos"        = "deaths",
      "Casos.activos"     = "active"))
    
    # parse icu
    x <- x.icu %>%
      dplyr::mutate(
        date = Grupo.de.edad,
        icu  = X..39 + X40.49 + X50.59 + X60.69 + X..70) %>%
      dplyr::select(date, icu) %>%
      dplyr::full_join(x, by = "date")
    map_data(x.crit, c(
      "Casos"              = "date",
      "Pacientes.criticos" = "critical")) %>%
      dplyr::full_join(x, by = "date")
      
  }
  
  if(level == 2) {
    
    # url
    url      <- "https://raw.githubusercontent.com/MinCiencia/Datos-COVID19/master/output/producto3/TotalesPorRegion_T.csv"
    url.icu  <- "https://raw.githubusercontent.com/MinCiencia/Datos-COVID19/master/output/producto8/UCI_T.csv"
    url.test <- "https://raw.githubusercontent.com/MinCiencia/Datos-COVID19/master/output/producto7/PCR_T.csv"
    # download
    x      <- read.csv(url, cache = cache)
    x.icu  <- read.csv(url.icu, cache = cache)
    x.test <- read.csv(url.test, cache = cache)
    
    # to mutate the region names
    mutate_region <- function(col) {
      # parse
      col = sub('^(.*)\\.[0-9]$', '\\1', col)
      col = gsub('\\.', ' ', col)
      col = ifelse(col == "Araucania", "Araucanía", col)
      # return
      return(col)
    }
    
    transform.column <- function(x, value) 
      x[c(-1,-2),] %>%
        dplyr::rename(date = Region) %>%
        # longer
        tidyr::pivot_longer(!date, names_to = "region", values_to = value) %>%
        dplyr::mutate(region = mutate_region(region))
        
    x.test <- transform.column(x.test, "tests")
    x.icu  <- transform.column(x.icu, "icu")
    
    # join headers
    colnames(x) <- c("date", paste(colnames(x[,-1]), x[1,-1], sep = "_"))
    x <- x[-1,] %>%
      # longer
      tidyr::pivot_longer(!date, names_to = "name", values_to = "value") %>%
      # split into multiple columns
      dplyr::mutate(
        region = sapply(strsplit(name, "_"), "[", 1),
        item   = sapply(strsplit(name, "_"), "[", 2),
        value  = as.numeric(value)) %>%
      dplyr::mutate(region = mutate_region(region)) %>%
      dplyr::select(date, value, region, item) %>%
      # create data columns
      tidyr::pivot_wider(names_from = item, values_from = value) %>%
      # rename columns
      map_data(c(
        "date"                          = "date",
        "region"                        = "region",
        "Casos acumulados"              = "confirmed",
        "Fallecidos totales"            = "deaths",
        "Casos confirmados recuperados" = "recovered")) %>%
      dplyr::group_by(region) %>%
      dplyr::arrange(as.Date(date,"%Y-%m-%d")) %>%
      tidyr::fill(deaths, .direction = "up")
    
    # join with tests
    x <- x %>%
      dplyr::filter(region != "Total") %>%
      #dplyr::full_join(x.test, by = c("date","region")) %>% # error in data (too low in comparison to confirmed)
      dplyr::full_join(x.icu, by = c("date","region"))
    
    # sanitize
    x$region <- trimws(x$region)
  }
  
  if(level == 3) {
    
    # url
    url        <- "https://raw.githubusercontent.com/MinCiencia/Datos-COVID19/master/output/producto1/Covid-19.csv"
    url.deaths <- "https://raw.githubusercontent.com/MinCiencia/Datos-COVID19/master/output/producto38/CasosFallecidosPorComuna.csv"
    # download
    x        <- read.csv(url, cache = cache)
    x.deaths <- read.csv(url.deaths, cache = cache)
    
    # to transform data
    transform.date.columns <- function(x, value) 
      x %>%
        dplyr::rename(region = Region, commune = Comuna, population = Poblacion) %>%
        # longer dates
        dplyr::select(-c(Codigo.region, Codigo.comuna)) %>%
        tidyr::pivot_longer(-c(region,commune,population),
                            names_prefix = "X", names_to = "date",
                            values_to = value) %>%
        dplyr::mutate(date = gsub("\\.", "-", date))
    
    # transform date columns
    x        <- transform.date.columns(x, "confirmed")
    x.deaths <- transform.date.columns(x.deaths, "deaths")

    # join
    x <- x %>%
      dplyr::full_join(x.deaths, by = c("date","region","commune","population"))
    
    # sanitize
    x$commune <- trimws(x$commune)
  }
  
  # date
  x$date <- as.Date(x$date, "%Y-%m-%d")
  
  # return
  return(x)
}
