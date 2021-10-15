covid19chile_git <- function(level, cache) {
  
  if(level == 1) {
    
    # url
    url           <- "https://raw.githubusercontent.com/MinCiencia/Datos-COVID19/master/output/producto5/TotalesNacionales_T.csv"
    url.hosp      <- "https://raw.githubusercontent.com/MinCiencia/Datos-COVID19/master/output/producto24/CamasHospital_Diario_T.csv"
    url.test      <- "https://raw.githubusercontent.com/MinCiencia/Datos-COVID19/master/output/producto17/PCREstablecimiento_std.csv"
    
    # download
    x           <- read.csv(url, cache = cache)
    x.hosp      <- read.csv(url.hosp, cache = cache)
    x.test      <- read.csv(url.test, cache = cache)
    
    # parse
    x <- map_data(x, c(
      "Fecha"                    = "date",
      "Casos.totales"            = "confirmed",
      "Fallecidos"               = "deaths",
      "Casos.activos"            = "active"))
    
    # recovered
    x$recovered <- x$confirmed - x$deaths - x$active
    
    # parse hosp
    x.hosp$hosp <- x.hosp$Basica + x.hosp$Media + x.hosp$UTI + x.hosp$UCI
    x.hosp <- map_data(x.hosp, c(
      "Tipo.de.cama" = "date",
      "hosp"         = "hosp",
      "UCI"          = "icu"
    ))
    
    # parse test
    x.test <- x.test[x.test$Establecimiento=="Total realizados",]
    x.test <- map_data(x.test, c(
      "fecha"         = "date",
      "Numero.de.PCR" = "tests"
    ))
    
    # merge
    x <- x %>%
      merge(x.hosp, by = "date", all = TRUE) %>%
      merge(x.test, by = "date", all = TRUE)
    
    # date
    x$date <- as.Date(x$date, "%Y-%m-%d")
    
    # drop duplicates
    x <- x[!duplicated(x$date),]
    
  }
  
  if(level == 2) {
    
    # url
    url      <- "https://raw.githubusercontent.com/MinCiencia/Datos-COVID19/master/output/producto3/TotalesPorRegion.csv"
    url.icu  <- "https://raw.githubusercontent.com/MinCiencia/Datos-COVID19/master/output/producto8/UCI.csv"
    url.test <- "https://raw.githubusercontent.com/MinCiencia/Datos-COVID19/master/output/producto7/PCR.csv"
    
    # download
    x      <- read.csv(url, cache = cache)
    x.icu  <- read.csv(url.icu, cache = cache)
    x.test <- read.csv(url.test, cache = cache)
    
    # sanitize Araucania
    x$Region      <- gsub("^Araucan.a$", "Araucania", x$Region)
    x.icu$Region  <- gsub("^Araucan.a$", "Araucania", x.icu$Region)
    x.test$Region <- gsub("^Araucan.a$", "Araucania", x.test$Region)
    
    # sanitize O'Higgins
    x$Region      <- gsub("^O.Higgins$", "O'Higgins", x$Region)
    x.icu$Region  <- gsub("^O.Higgins$", "O'Higgins", x.icu$Region)
    x.test$Region <- gsub("^O.Higgins$", "O'Higgins", x.test$Region)

    # formatting x
    x$Categoria <- map_values(x$Categoria, c(
      "Casos acumulados"              = "confirmed",
      "Fallecidos totales"            = "deaths",
      "Casos confirmados recuperados" = "recovered"
    ))
    
    x <- x %>%
      tidyr::pivot_longer(cols = -c("Region", "Categoria"), names_to = 'date', values_to = 'value') %>%
      tidyr::pivot_wider(names_from = "Categoria", values_from = "value")
    
    # formatting x.icu
    x.icu <- x.icu %>% 
      dplyr::select(-c("Poblacion")) %>%
      tidyr::pivot_longer(cols = -c("Region", "Codigo.region"), names_to = "date", values_to = "icu")
    
    # formatting tests
    x.test <- x.test %>% 
      dplyr::select(-c("Poblacion")) %>%
      tidyr::pivot_longer(cols = -c("Region", "Codigo.region"), names_to = "date", values_to = "tests") %>%
      dplyr::group_by_at("Region") %>%
      dplyr::arrange_at("date") %>%
      dplyr::mutate(tests = cumsum(tests, na.rm = TRUE))
    
    # merge
    x <- x[x$Region!="Total",] %>%
      merge(x.icu, by = c("date","Region"), all = TRUE) %>%
      merge(x.test, by = c("date","Region"), all = TRUE)
    
    # fix missing codes after merge
    map <- x$Codigo.region
    names(map) <- x$Region
    x$Codigo.region <- map_values(x$Region, map)
    
    # date
    x$date <- as.Date(x$date, format = "X%Y.%m.%d")
    
  }
  
  if(level == 3) {
    
    # url
    url        <- "https://raw.githubusercontent.com/MinCiencia/Datos-COVID19/master/output/producto1/Covid-19.csv"
    url.deaths <- "https://raw.githubusercontent.com/MinCiencia/Datos-COVID19/master/output/producto38/CasosFallecidosPorComuna.csv"
    
    # download
    x        <- read.csv(url, cache = cache)
    x.deaths <- read.csv(url.deaths, cache = cache)
    
    # by
    drop <- c("Region", "Codigo.region", "Comuna", "Poblacion")
    by <- "Codigo.comuna"
    
    # formatting x
    x <- x %>%
      dplyr::select(-dplyr::all_of(c(drop, "Tasa"))) %>%
      tidyr::pivot_longer(cols = -dplyr::all_of(by), names_to = "date", values_to = "confirmed") %>%
      dplyr::group_by_at(c("date", by)) %>%
      dplyr::summarise(confirmed = sum(confirmed))
    
    # formatting x.deaths
    x.deaths <- x.deaths %>% 
      dplyr::select(-dplyr::all_of(drop)) %>%
      tidyr::pivot_longer(cols = -dplyr::all_of(by), names_to = "date", values_to = "deaths") %>%
      dplyr::group_by_at(c("date", by)) %>%
      dplyr::summarise(deaths = sum(deaths))
   
    # merge
    x <- merge(x, x.deaths, by = c("date", by), all = TRUE)
     
    # drop total
    x <- x[!is.na(x[[by]]),]
    
    # date
    x$date <- as.Date(x$date, format = "X%Y.%m.%d")
    
  }
  
  # return
  return(x)
}
