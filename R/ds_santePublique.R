santePublique <- function(level, cache){
  
  # download
  # source: https://www.data.gouv.fr/fr/organizations/sante-publique-france/
  url.hospital.data <- 'https://www.data.gouv.fr/fr/datasets/r/63352e38-d353-4b54-bfd1-f1b3ee1cabd7'
  url.tests         <- 'https://www.data.gouv.fr/fr/datasets/r/b4ea7b4b-b7d1-4885-a099-71852291ff20'
  
  hospital.data <- read.csv(url.hospital.data, sep=";", cache=cache)
  #warning("FRA test data might take longer to download...")
  #tests.data    <- read.csv(url.tests, sep=";", cache=cache)
  
  hospital.data <- subset(hospital.data, c(
    'dep'  = 'city', # French departments (subregions)
    'sexe' = 'sex',
    'jour' = 'date',
    'hosp' = 'hosp',
    'rea'  = 'icu',
    'rad'  = 'recovered',
    'dc'   = 'deaths_in_hospital'
  ))
  
  #tests.data <- subset(tests.data, c(
  #  'dep'         = 'city', # French departments (subregions)
  #  'jour'        = 'date',
  #  'clage_covid' = 'age_group',
  #  'nb_test'     = 'tests',
  #  'nb_pos'      = 'confirmed',
  #  'tx_pos'      = 'positive_rate',
  #  'nb_test_h'   = 'tests_men',
  #  'nb_test_f'   = 'tests_women',
  #  'nb_pos_h'    = 'confirmed_men',
  #  'nb_pos_f'    = 'confirmed_women'
  #))
  
  # country level
  if(level == 1) {
    h <- hospital.data %>%
      dplyr::filter(sex == "0") %>%
      dplyr::mutate(date = as.Date(date)) %>%
      dplyr::group_by(date)     %>%
      dplyr::summarise(hosp      = sum(hosp),
                       icu       = sum(icu),
                       recovered = sum(recovered),
                       deaths    = sum(deaths_in_hospital))
    #t <- tests.data %>%
    #  dplyr::filter(age_group == "0") %>%
    #  dplyr::mutate(date = as.Date(date)) %>%
    #  dplyr::group_by(date) %>%
    #  dplyr::summarise(tests = sum(tests),
    #                   confirmed = sum(confirmed),
    #                   confirmed_women = sum(confirmed_women),
    #                   confirmed_men = sum(confirmed_men)) %>%
    #  dplyr::arrange(date) %>%
    #  dplyr::mutate(tests = cumsum(tests),
    #                confirmed = cumsum(confirmed),
    #                confirmed_women = cumsum(confirmed_women),
    #                confirmed_men = cumsum(confirmed_men))
    # merge
    #x <- merge(h,t,by=c("date"),all=T)
    x <- h
  }
  # state level
  if(level == 2) {
    # read states from db
    hospital.data$state <- FRA_departments_to_states(hospital.data$city)
    #tests.data$state <- FRA_departments_to_states(tests.data$city)
    # group
    h <- hospital.data %>%
      dplyr::filter(sex == "0")           %>%
      dplyr::mutate(date = as.Date(date)) %>%
      dplyr::group_by(date,state)         %>%
      dplyr::summarise(hosp      = sum(hosp),
                       icu       = sum(icu),
                       recovered = sum(recovered),
                       deaths    = sum(deaths_in_hospital))
    #t <- tests.data %>%
    #  dplyr::filter(age_group == "0") %>%
    #  dplyr::mutate(date = as.Date(date)) %>%
    #  dplyr::group_by(date,state) %>%
    #  dplyr::summarise(tests = sum(tests),
    #                   confirmed = sum(confirmed),
    #                   confirmed_women = sum(confirmed_women),
    #                   confirmed_men = sum(confirmed_men)) %>%
    #  dplyr::arrange(date) %>%
    #  dplyr::mutate(tests = cumsum(tests),
    #                confirmed = cumsum(confirmed),
    #                confirmed_women = cumsum(confirmed_women),
    #                confirmed_men = cumsum(confirmed_men))
    # merge
    #x <- merge(h,t,by=c("date","state"),all=T)
    x <- h
  }
  if(level == 3) {
    # group
    h <- hospital.data %>%
      dplyr::filter(sex == "0")  %>%
      dplyr::mutate(date = as.Date(date)) %>%
      dplyr::group_by(date,city) %>%
      dplyr::summarise(hosp      = sum(hosp),
                       icu       = sum(icu),
                       recovered = sum(recovered),
                       deaths    = sum(deaths_in_hospital)) %>%
      dplyr::mutate(city = paste("dep",city,sep=""))
    #t <- tests.data %>%
    #  dplyr::filter(age_group == "0") %>%
    #  dplyr::mutate(date = as.Date(date)) %>%
    #  dplyr::group_by(date,city) %>%
    #  dplyr::summarise(tests = sum(tests),
    #                   confirmed = sum(confirmed),
    #                   confirmed_women = sum(confirmed_women),
    #                   confirmed_men = sum(confirmed_men)) %>%
    #  dplyr::arrange(date) %>%
    #  dplyr::mutate(tests = cumsum(tests),
    #                confirmed = cumsum(confirmed),
    #                confirmed_women = cumsum(confirmed_women),
    #                confirmed_men = cumsum(confirmed_men),
    #                city = paste("dep",city,sep=""))
    # merge
    #x <- merge(h,t,by=c("date","city"),all=T)
    x <- h
  }
  
  
  
  # return
  return(x)
  
}

FRA_departments_to_states <- function(deps) {
  fra <- read.csv("inst/extdata/db/FRA.csv", cache=F)
  regs <- c()
  for(i in 1:length(deps)) {
    dep <- deps[i]
    if(!is.na(deps[i]))
      regs <- c(regs, fra$state[which(fra$id == paste("dep",deps[i],sep=""))])
    else
      regs <- c(regs, NA)
  }
  return(regs)
}
