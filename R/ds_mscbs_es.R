mscbs_es <- function(level, cache) {
  # Author: Martin Benes 07/09/2020 - martinbenes1996@gmail.com
  
  if(level == 2) {
    
    # download
    url <- 'https://cnecovid.isciii.es/covid19/resources/casos_diagnostico_ccaa.csv'
    x   <- read.csv(url, cache = cache)
    
    # format
    x <- map_data(x, c(
      "fecha"     = "date",
      "ccaa_iso"  = "state",
      "num_casos" = "confirmed")) 
    
    # cumulate
    x <- x %>%
      dplyr::group_by(state) %>%
      dplyr::arrange(date) %>%
      dplyr::mutate(confirmed = cumsum(confirmed))
    
    # date
    x$date <- as.Date(x$date, "%Y-%m-%d")
    
  }
  if(level == 3) {
    
    # download
    url <- 'https://cnecovid.isciii.es/covid19/resources/casos_hosp_uci_def_sexo_edad_provres.csv'
    x <- read.csv(url, cache = cache)
    
    # format
    x <- map_data(x, c(
      "fecha"          = "date",
      "provincia_iso"  = "district",
      "num_casos"      = "confirmed",
      "num_hosp"       = "hosp",
      "num_uci"        = "icu",
      "num_def"        = "deaths")) 
    
    # process
    x <- x %>%
      dplyr::group_by_at(c("date", "district")) %>%
      dplyr::summarise(confirmed = sum(confirmed),
                       hosp = sum(hosp),
                       icu = sum(icu),
                       deaths = sum(deaths)) %>%
      dplyr::group_by(district) %>%
      dplyr::arrange(date) %>%
      dplyr::mutate(confirmed = cumsum(confirmed),
                    deaths = cumsum(deaths))
    
    # date
    x$date <- as.Date(x$date, "%Y-%m-%d")
    
  }
  
  # return
  return(x)
  
}