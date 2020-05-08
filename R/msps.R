msps <- function(cache, level){
  # author: Federico Lo Giudice
  
  # Socrata API https://dev.socrata.com/foundry/www.datos.gov.co/gt2j-8ykr
  # Source: Ministerio de Salud y Protecci?n Social de Colombia
  
  # download
  url.administrative <- 'https://www.datos.gov.co/resource/gdxc-w37w.csv?$limit=2000'
  
  url <- 'https://www.datos.gov.co/resource/gt2j-8ykr.csv?$limit=500000'
  cases <- read.csv(url, encoding="UTF-8", cache = cache)
  
  x <- cases %>%
    dplyr::mutate(
      date_notified  = as.Date(ifelse(fecha_de_notificaci_n == '-   -', NA, fecha_de_notificaci_n), format="%Y-%m-%d"),
      date_confirmed = as.Date(ifelse(fecha_diagnostico == '-   -', NA, fecha_diagnostico), format="%Y-%m-%d"),
      date_death     = as.Date(ifelse(fecha_de_muerte == '-   -', NA, fecha_de_muerte), format="%Y-%m-%d"),
      date_recovered = as.Date(ifelse(fecha_recuperado == '-   -', NA, fecha_recuperado), format="%Y-%m-%d") ) %>%
    dplyr::mutate(
      departamento = replace(departamento, departamento == 'Cundinamara', 'Cundinamarca')
    )
    
  
  if(level == 1) {
    # group to confirmed
    confirmed <- x %>%
      dplyr::group_by(date_confirmed) %>%
      dplyr::summarise(confirmed = n()) %>%
      dplyr::mutate(date = date_confirmed)
    # group to deaths
    deaths <- x %>%
      dplyr::group_by(date_death) %>%
      dplyr::summarise(deaths = n()) %>%
      dplyr::mutate(date = date_death)
    # group to recovered
    recovered <- x %>%
      dplyr::group_by(date_recovered) %>%
      dplyr::summarise(recovered = n()) %>%
      dplyr::mutate(date = date_recovered)
    
    # merge
    xx <- merge(confirmed, deaths, by = "date", all = T)
    xx <- merge(xx, recovered, by = "date", all = T)
    
    # cumsum
    xxx <- xx %>%
      tidyr::replace_na(list(confirmed = 0, deaths = 0, recovered = 0)) %>%
      dplyr::filter(!is.na(date)) %>%
      dplyr::mutate(
        confirmed = cumsum(confirmed),
        deaths    = cumsum(deaths),
        recovered = cumsum(recovered) )
  } else {  # administrative
    administrative <- read.csv(url.administrative, encoding="UTF-8", cache = cache)
  }
  if(level == 2) {
    x$state <- x$departamento
    states <- administrative %>%
      dplyr::mutate(state = replace(dpto, dpto == 'Bogotá d C.', 'Bogotá D.C.')) %>%
      dplyr::group_by(state,cod_depto) %>%
      dplyr::summarise() %>%
      dplyr::ungroup() %>%
      dplyr::add_row(cod_depto = 8, state = "Barranquilla D.E.") %>%
      dplyr::add_row(cod_depto = 76, state = "Buenaventura D.E.") %>%
      dplyr::add_row(cod_depto = 13, state = "Cartagena D.T. y C.") %>%
      dplyr::add_row(cod_depto = 47, state = "Santa Marta D.T. y C.")
    # group to confirmed
    confirmed <- x %>%
      dplyr::group_by(date_confirmed, state) %>%
      dplyr::summarise(confirmed = n()) %>%
      dplyr::mutate(date = date_confirmed)
    # group to deaths
    deaths <- x %>%
      dplyr::group_by(date_death, state) %>%
      dplyr::summarise(deaths = n()) %>%
      dplyr::mutate(date = date_death)
    # group to recovered
    recovered <- x %>%
      dplyr::group_by(date_recovered, state) %>%
      dplyr::summarise(recovered = n()) %>%
      dplyr::mutate(date = date_recovered)
    
    # merge
    xx <- merge(confirmed, deaths, by = c("date","state"), all = T)
    xx <- merge(xx, recovered, by = c("date","state"), all = T)
    xx <- merge(xx, states, by="state", all.x=T)
    
    # cumsum
    xxx <- xx %>%
      tidyr::replace_na(list(confirmed = 0, deaths = 0, recovered = 0)) %>%
      dplyr::filter(!is.na(date)) %>%
      dplyr::arrange(date) %>%
      dplyr::group_by(state) %>%
      dplyr::mutate(
        confirmed = cumsum(confirmed),
        deaths    = cumsum(deaths),
        recovered = cumsum(recovered) )
    xxx$state <- xxx$cod_depto
    
  }
  if(level == 3) {
    cities <- administrative %>%
      dplyr::mutate(city = nom_mpio) %>%
      dplyr::group_by(city,cod_mpio) %>%
      dplyr::summarise() %>%
      dplyr::ungroup()
    x$city <- x$ciudad_de_ubicaci_n
    # group to confirmed
    confirmed <- x %>%
      dplyr::group_by(date_confirmed, city) %>%
      dplyr::summarise(confirmed = n()) %>%
      dplyr::mutate(date = date_confirmed)
    # group to deaths
    deaths <- x %>%
      dplyr::group_by(date_death, city) %>%
      dplyr::summarise(deaths = n()) %>%
      dplyr::mutate(date = date_death)
    # group to recovered
    recovered <- x %>%
      dplyr::group_by(date_recovered, city) %>%
      dplyr::summarise(recovered = n()) %>%
      dplyr::mutate(date = date_recovered)
    
    # merge
    xx <- merge(confirmed, deaths, by = c("date","city"), all = T)
    xx <- merge(xx, recovered, by = c("date","city"), all = T)
    xx <- merge(xx, cities, by="city", all.x=T)
    
    # cumsum
    xxx <- xx %>%
      tidyr::replace_na(list(confirmed = 0, deaths = 0, recovered = 0)) %>%
      dplyr::filter(!is.na(date)) %>%
      dplyr::arrange(date) %>%
      dplyr::group_by(city) %>%
      dplyr::mutate(
        confirmed = cumsum(confirmed),
        deaths    = cumsum(deaths),
        recovered = cumsum(recovered) ) %>%
      dplyr::ungroup() %>%
      dplyr::filter(!is.na(cod_mpio))
    xxx$city <- xxx$cod_mpio
    
  }
  
  # return
  return(xxx)
  
}

