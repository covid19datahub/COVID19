gov_co <- function(cache, level){
  # author: Federico Lo Giudice
  
  # Socrata API https://dev.socrata.com/foundry/www.datos.gov.co/gt2j-8ykr
  # Source: Ministerio de Salud y Protecci?n Social de Colombia
  
  # download
  url <- 'https://www.datos.gov.co/resource/gt2j-8ykr.csv?$limit=9999999999'
  x   <- read.csv(url, encoding="UTF-8", cache = cache)
  
  # tests
  url <- 'https://www.datos.gov.co/resource/8835-5baf.csv?$limit=9999999999'
  x.tests   <- read.csv(url, encoding="UTF-8", cache = cache)
  
  # formatting
  x <- map_data(x, c(
    'recuperado'            = 'type',
    'fecha_reporte_web'     = 'date_confirmed',
    'fecha_muerte'          = 'date_deaths',
    'fecha_recuperado'      = 'date_recovered',
    'departamento'          = 'state_code',
    'ciudad_municipio'      = 'city_code',
    'departamento_nom'      = 'state',
    'ciudad_municipio_nom'  = 'city'
  ))
  
  # sanitize
  x$type <- tolower(x$type)
  
  # date 
  for(d in c("date_confirmed","date_deaths","date_recovered"))
    x[[d]] <- as.Date(x[[d]], format = "%d/%m/%Y")
  
  # formatting tests
  if(level==1){
    
    tests <- map_data(x.tests[-1,], c(
      'fecha'      = 'date',
      'acumuladas' = 'tests'
    ))
    
    tests$date <- as.Date(tests$date, format = "%Y-%m-%d")
    
  }
  if(level==2){
    
    tests <- map_data(x.tests[-1,], c(
      'fecha'  = 'date',
      "amazonas" = 91,          
      "antioquia" = 5,
      "arauca" = 81,
      "atlantico" = 8,              
      "bogota" = 11,
      "bolivar" = 13,
      "boyaca" = 15,                
      "caldas" = 17,
      "caqueta" = 18,
      "casanare" = 85,
      "cauca" = 19,
      "cesar" = 20,
      "choco" = 27,               
      "cordoba" = 23,
      "cundinamarca"  = 25,
      "guainia" = 94,
      "guajira" = 44,
      "guaviare" = 95,
      "huila" = 41,              
      "magdalena" = 47,
      "meta" = 50,
      "narino" = 52,
      "norte_de_santander" = 54,
      "putumayo" = 86,
      "quindio"  = 63,             
      "risaralda" = 66,
      "san_andres" = 88,
      "santander" = 68,             
      "sucre" = 70,
      "tolima"  = 73,
      "valle_del_cauca" = 76,
      "vaupes" = 97,
      "vichada" = 99,             
      "barranquilla" = 8001,
      "cartagena" = 13001,
      "santa_marta" = 47001          
    ))
    
    tests$date <- as.Date(tests$date, format = "%Y-%m-%d")
    
    tests <- tidyr::pivot_longer(tests, cols = -date, names_to = "state_code", values_to = "tests")
    
  }

  # group key
  if(level == 1) 
    by <- NULL
  if(level == 2) 
    by <- 'state_code'
  if(level == 3) 
    by <- c('state_code','city_code')
  
  # group to confirmed
  confirmed <- x %>%
    dplyr::filter(!is.na(date_confirmed)) %>%
    dplyr::group_by_at(c('date_confirmed',by)) %>%
    dplyr::summarise(confirmed = n()) %>%
    dplyr::mutate(date = date_confirmed)
  
  # group to deaths
  deaths <- x %>%
    dplyr::filter(!is.na(date_deaths) & type=='fallecido') %>%
    dplyr::group_by_at(c('date_deaths',by)) %>%
    dplyr::summarise(deaths = n()) %>%
    dplyr::mutate(date = date_deaths)
  
  # group to recovered
  recovered <- x %>%
    dplyr::filter(!is.na(date_recovered) & type=='recuperado') %>%
    dplyr::group_by_at(c('date_recovered',by)) %>%
    dplyr::summarise(recovered = n()) %>%
    dplyr::mutate(date = date_recovered)
  
  # merge
  x <- merge(confirmed, deaths, all = TRUE)
  x <- merge(x, recovered, all = TRUE)
  
  # cumsum
  x <- x %>%
    dplyr::filter(!is.na(date) & date <= Sys.Date()) %>%
    dplyr::group_by_at(by) %>%
    dplyr::arrange(date) %>%
    dplyr::mutate(
      confirmed = cumsum(confirmed, na.rm = TRUE),
      deaths    = cumsum(deaths,    na.rm = TRUE),
      recovered = cumsum(recovered,  na.rm = TRUE)
    )
  
  # cumulative tests
  if(level!=3)
    x <- merge(x, tests, all = TRUE)
   
  # return
  return(x)
  
}

