gov_co <- function(cache, level){
  # author: Federico Lo Giudice
  
  # Socrata API https://dev.socrata.com/foundry/www.datos.gov.co/gt2j-8ykr
  # Source: Ministerio de Salud y Protecci?n Social de Colombia
  
  # download
  url <- 'https://www.datos.gov.co/resource/gt2j-8ykr.csv?$limit=9999999999'
  x   <- read.csv(url, encoding="UTF-8", cache = cache)
  
  # formatting
  x <- map_data(x, c(
    'fecha_diagnostico'    = 'date_confirmed',
    'fecha_muerte'         = 'date_deaths',
    'fecha_recuperado'     = 'date_recovered',
    'departamento'         = 'state_code',
    'ciudad_municipio'     = 'city_code',
    'departamento_nom'     = 'state',
    'ciudad_municipio_nom' = 'city'
  ))
  
  # fix
  idx <- which(x$state_code==94 & x$state=="CESAR")
  if(length(idx))
    x <- x[-idx,]
  
  # date 
  for(d in c("date_confirmed","date_deaths","date_recovered"))
    x[[d]] <- as.Date(x[[d]], format = "%d/%m/%Y")

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
    dplyr::filter(!is.na(date_deaths)) %>%
    dplyr::group_by_at(c('date_deaths',by)) %>%
    dplyr::summarise(deaths = n()) %>%
    dplyr::mutate(date = date_deaths)
  
  # group to recovered
  recovered <- x %>%
    dplyr::filter(!is.na(date_recovered)) %>%
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
  
  # return
  return(x)
  
}

