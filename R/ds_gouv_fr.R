gouv_fr <- function(level = 1, reg = NULL, dep = NULL){
  
  # cases
  # https://www.data.gouv.fr/fr/datasets/synthese-des-indicateurs-de-suivi-de-lepidemie-covid-19/#_
  
  # tests
  # https://www.data.gouv.fr/fr/datasets/capacite-analytique-de-tests-virologiques-dans-le-cadre-de-lepidemie-covid-19/
  
  # vaccines
  # https://www.data.gouv.fr/fr/datasets/donnees-relatives-aux-personnes-vaccinees-contre-la-covid-19-1/
  
  if(level == 1){
    
    cases <- read.csv("https://www.data.gouv.fr/fr/datasets/r/f335f9ea-86e3-4ffa-9684-93c009d5e617")
    tests <- read.csv("https://www.data.gouv.fr/fr/datasets/r/21ff3134-c37c-41ef-bb3d-fbea5f6d4a28", sep = ";")
    vacc  <- read.csv("https://www.data.gouv.fr/fr/datasets/r/b273cf3b-e9de-437c-af55-eda5979e92fc", sep = ";")
      
    cases <- map_data(cases, c(
      "date" = "date",
      "hosp" = "hosp",
      "rea" = "icu",
      "dc_tot" = "deaths",
      "conf" = "confirmed"
    ))
    
    tests <- map_data(tests, c(
      "jour" = "date",
      "T"    = "tests"
    )) 
    tests <- tests %>%
      arrange(date) %>%
      mutate(tests = cumsum(tests))
    
    vacc <- vacc[vacc$vaccin==0,]
    vacc$doses <- rowSums(vacc[,startsWith(colnames(vacc), "n_cum_")])
    vacc <- map_data(vacc, c(
      "jour"  = "date",
      "doses" = "vaccines"
    ))
    
    x <- merge(cases, tests, all = TRUE)
    x <- merge(x, vacc, all = TRUE)

  }
  
  if(level == 2){
    
    cases <- read.csv("https://www.data.gouv.fr/fr/datasets/r/5c4e1452-3850-4b59-b11c-3dd51d7fb8b5")
    tests <- read.csv("https://www.data.gouv.fr/fr/datasets/r/0c230dc3-2d51-4f17-be97-aa9938564b39", sep = ";")
    vacc  <- read.csv("https://www.data.gouv.fr/fr/datasets/r/900da9b0-8987-4ba7-b117-7aea0e53f530", sep = ";")
    
    cases <- map_data(cases, c(
      "date" = "date",
      "reg"  = "reg",
      "hosp" = "hosp",
      "rea" = "icu",
      "dchosp" = "deaths",
      "pos" = "confirmed"
    )) %>%
      dplyr::group_by(reg, date) %>%
      dplyr::summarise(hosp      = sum(hosp),
                       icu       = sum(icu),
                       deaths    = sum(deaths),
                       confirmed = sum(confirmed)) %>%
      dplyr::group_by(reg) %>%
      dplyr::arrange(date) %>%
      dplyr::mutate(confirmed = cumsum(confirmed))
    
    tests <- map_data(tests, c(
      "reg"  = "reg",
      "jour" = "date",
      "T"    = "tests"
    )) %>% 
      dplyr::group_by(reg) %>%
      dplyr::arrange(date) %>%
      dplyr::mutate(tests = cumsum(tests))
    
    vacc <- vacc[vacc$vaccin==0,]
    vacc$doses <- rowSums(vacc[,startsWith(colnames(vacc), "n_cum_")])
    vacc <- map_data(vacc, c(
      "reg"   = "reg",
      "jour"  = "date",
      "doses" = "vaccines"
    ))
    
    x <- merge(cases, tests, all = TRUE)
    x <- merge(x, vacc, all = TRUE)
    
  }
  
  if(level == 3){
    
    cases <- read.csv("https://www.data.gouv.fr/fr/datasets/r/5c4e1452-3850-4b59-b11c-3dd51d7fb8b5")
    tests <- read.csv("https://www.data.gouv.fr/fr/datasets/r/44b46964-8583-4f18-b93f-80fefcbf3b74", sep = ";")
    vacc  <- read.csv("https://www.data.gouv.fr/fr/datasets/r/535f8686-d75d-43d9-94b3-da8cdf850634", sep = ";")
    
    cases <- map_data(cases, c(
      "date" = "date",
      "dep"  = "dep",
      "hosp" = "hosp",
      "rea" = "icu",
      "dchosp" = "deaths",
      "pos" = "confirmed"
    )) %>%
      dplyr::group_by(dep) %>%
      dplyr::arrange(date) %>%
      dplyr::mutate(confirmed = cumsum(confirmed))
    
    tests <- map_data(tests, c(
      "dep"  = "dep",
      "jour" = "date",
      "T"    = "tests"
    )) %>% 
      dplyr::group_by(dep) %>%
      dplyr::arrange(date) %>%
      dplyr::mutate(tests = cumsum(tests))
    
    vacc <- vacc[vacc$vaccin==0,]
    vacc$doses <- rowSums(vacc[,startsWith(colnames(vacc), "n_cum_")])
    vacc <- map_data(vacc, c(
      "dep"   = "dep",
      "jour"  = "date",
      "doses" = "vaccines"
    ))
    
    x <- merge(cases, tests, all = TRUE)
    x <- merge(x, vacc, all = TRUE)
    
  }
  
  # convert to date
  x$date <- as.Date(x$date)
  
  # filter
  if(!is.null(reg))
    x <- x[which(x$reg==reg),]
  if(!is.null(dep))
    x <- x[which(x$dep==dep),]
  
  # return
  return(x)
  
}
