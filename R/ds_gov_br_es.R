gov_br_es <- function(level, cache) {
  
  # This panel is provided by the State Government of Espírito Santo – Brazil,
  # since the beginning of march. It is updated daily and provides data about the
  # disease spread in all 78 state counties.
  # https://coronavirus.es.gov.br/painel-covid-19-es
  
  # url 
  url <- "https://bi.static.es.gov.br/covid19/MICRODADOS.csv"
  
  # download
  filename <- tempfile()
  download.file(url, destfile = filename, quiet = TRUE)
  
  # read
  x <- read.csv(filename, cache = cache, sep = ";", na.strings = "")
  
  # level
  if(level==2)
    key <- c()
  if(level==3)
    key <- c("Municipio")

  # cumulative tests (filter out wrong dates before 2020)
  tests <- c("DataColeta_RT_PCR", "DataColetaSorologia", "DataColetaSorologiaIGG", "DataColetaTesteRapido")
  x.tests <- x %>%
    dplyr::select_at(c(key, tests)) %>%
    tidyr::pivot_longer(cols = dplyr::all_of(tests), values_to = "date") %>%
    dplyr::filter(date > "2020-01-01") %>%
    dplyr::mutate(date = as.Date(date)) %>%
    tidyr::drop_na(date) %>%
    dplyr::group_by_at(c(key, "date")) %>%
    dplyr::summarise(tests = n()) %>%
    dplyr::group_by_at(key) %>%
    dplyr::arrange(date) %>%
    dplyr::mutate(tests = cumsum(tests))
  
  # cumulative confirmed (filter out wrong dates before 2020)
  x.cases <- x %>%
    dplyr::filter(Classificacao == "Confirmados") %>%
    dplyr::rename(date = DataNotificacao) %>%
    dplyr::filter(date > "2020-01-01") %>%
    dplyr::mutate(date = as.Date(date)) %>%
    tidyr::drop_na(date) %>%
    dplyr::group_by_at(c(key,"date")) %>%
    dplyr::summarise(confirmed = n()) %>%
    dplyr::group_by_at(key) %>%
    dplyr::arrange(date) %>%
    dplyr::mutate(confirmed = cumsum(confirmed))
  
  # cumulative recovered (filter out wrong dates before 2020)
  x.recovered <- x %>%
    dplyr::filter(Evolucao == "Cura") %>%
    dplyr::rename(date = DataEncerramento) %>%
    dplyr::filter(date > "2020-01-01") %>%
    dplyr::mutate(date = as.Date(date)) %>%
    tidyr::drop_na(date) %>%
    dplyr::group_by_at(c(key,"date")) %>%
    dplyr::summarise(recovered = n()) %>%
    dplyr::group_by_at(key) %>%
    dplyr::arrange(date) %>%
    dplyr::mutate(recovered = cumsum(recovered))
  
  # cumulative deaths (filter out wrong dates before 2020)
  x.deaths <- x %>%
    dplyr::filter(grepl("bito pelo COVID-19$", Evolucao)) %>% 
    dplyr::rename(date = DataObito) %>%
    dplyr::filter(date > "2020-01-01") %>%
    dplyr::mutate(date = as.Date(date)) %>%
    tidyr::drop_na(date) %>%
    dplyr::group_by_at(c(key,"date")) %>%
    dplyr::summarise(deaths = n()) %>%
    dplyr::group_by_at(key) %>%
    dplyr::arrange(date) %>%
    dplyr::mutate(deaths = cumsum(deaths))
  
  # merge
  x <- x.tests %>%
    dplyr::full_join(x.cases, by = c(key, "date")) %>%
    dplyr::full_join(x.recovered, by = c(key, "date")) %>%
    dplyr::full_join(x.deaths, by = c(key, "date"))
  
  # add state
  x$State <- "ESPIRITO SANTO"
  
  # return
  return(x)
  
}