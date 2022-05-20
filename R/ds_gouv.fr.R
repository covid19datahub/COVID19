#' Santé Publique France
#'
#' Data source for: France and overseas territories
#'
#' @param level 1, 2, 3
#' @param reg filter by region code
#' @param dep filter by department code
#'
#' @section Level 1:
#' - deaths
#' - tests
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#' - hospitalizations
#' - intensive care
#' 
#' @section Level 2:
#' - confirmed cases
#' - deaths
#' - tests
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#' - hospitalizations
#' - intensive care
#'
#' @section Level 3:
#' - confirmed cases
#' - deaths
#' - tests
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#' - hospitalizations
#' - intensive care
#'
#' @source https://www.data.gouv.fr/fr/pages/donnees-coronavirus/
#'
#' @keywords internal
#'
gouv.fr <- function(level = 1, reg = NULL, dep = NULL){
  if(!level %in% 1:3) return(NULL)
  
  if(level==1){
    
    # download cases
    # see https://www.data.gouv.fr/fr/datasets/synthese-des-indicateurs-de-suivi-de-lepidemie-covid-19/#_
    url.cases <- "https://www.data.gouv.fr/fr/datasets/r/f335f9ea-86e3-4ffa-9684-93c009d5e617"
    x.cases <- read.csv(url.cases)
    
    # format cases
    x.cases <- map_data(x.cases, c(
      "date" = "date",
      "hosp" = "hosp",
      "rea" = "icu",
      "dc_tot" = "deaths"
    ))
    
    # download tests
    # see https://www.data.gouv.fr/fr/datasets/donnees-de-laboratoires-pour-le-depistage-a-compter-du-18-05-2022-si-dep/
    url.tests <- "https://www.data.gouv.fr/fr/datasets/r/d349accb-56ef-4b53-b218-46c2a7f902e0"
    x.tests <- read.csv(url.tests, sep = ";", dec = ",")
    
    # format tests
    x.tests <- map_data(x.tests, c(
      "jour" = "date",
      "T"    = "tests"
    )) 
    
    # cumulate tests
    x.tests <- x.tests %>%
      group_by(date) %>%
      summarise(tests = as.integer(sum(tests))) %>%
      arrange(date) %>%
      mutate(tests = cumsum(tests))
    
    # download people vaccinated
    # see https://www.data.gouv.fr/fr/datasets/donnees-relatives-aux-personnes-vaccinees-contre-la-covid-19-1/
    url.vacc <- "https://www.data.gouv.fr/fr/datasets/r/efe23314-67c4-45d3-89a2-3faef82fae90"
    x.vacc  <- read.csv(url.vacc, sep = ";")
    
    # format people vaccinated
    x.vacc <- map_data(x.vacc, c(
      "jour" = "date",
      "n_cum_dose1" = "people_vaccinated",
      "n_cum_complet" = "people_fully_vaccinated"
    ))
    
    # download vaccine doses
    # see https://www.data.gouv.fr/fr/datasets/donnees-relatives-aux-personnes-vaccinees-contre-la-covid-19-1/
    url.doses <- "https://www.data.gouv.fr/fr/datasets/r/b273cf3b-e9de-437c-af55-eda5979e92fc"
    x.doses <- read.csv(url.doses, sep = ";")
    
    # compute vaccine doses
    x.doses <- x.doses %>%
      # filter by total vaccines
      filter(vaccin==0) %>%
      # for each row
      rowwise() %>%
      # compute the sum of all doses
      mutate(vaccines = sum(c_across(starts_with("n_cum_dose")))) %>%
      # rename date
      mutate(date = jour)
    
    # merge
    by <- "date"
    x <- x.cases %>%
      full_join(x.tests, by = by) %>%
      full_join(x.doses, by = by) %>%
      full_join(x.vacc, by = by)
    
  }
  
  if(level==2){
    
    # download cases
    # see https://www.data.gouv.fr/fr/datasets/synthese-des-indicateurs-de-suivi-de-lepidemie-covid-19/#_
    url.cases <- "https://www.data.gouv.fr/fr/datasets/r/5c4e1452-3850-4b59-b11c-3dd51d7fb8b5"
    x.cases <- read.csv(url.cases)
    
    # format cases
    x.cases <- map_data(x.cases, c(
      "date" = "date",
      "reg"  = "reg",
      "hosp" = "hosp",
      "rea" = "icu",
      "dchosp" = "deaths",
      "pos" = "confirmed"
    ))
    
    # cases
    x.cases <- x.cases %>%
      # for each date and region
      dplyr::group_by(reg, date) %>%
      # compute total counts
      dplyr::summarise(
        hosp = sum(hosp),
        icu = sum(icu),
        deaths = sum(deaths),
        confirmed = sum(confirmed)) %>%
      # group by region
      dplyr::group_by(reg) %>%
      # sort by date
      dplyr::arrange(date) %>%
      # cumulate confirmed cases (deaths are already cumulative)
      dplyr::mutate(confirmed = cumsum(confirmed))
    
    # download tests
    # see https://www.data.gouv.fr/fr/datasets/donnees-de-laboratoires-pour-le-depistage-a-compter-du-18-05-2022-si-dep/
    url.tests <- "https://www.data.gouv.fr/fr/datasets/r/8b382611-4b86-41ff-9e58-9ee638a6d564"
    x.tests <- read.csv(url.tests, sep = ";", dec = ",")
    
    # format tests
    x.tests <- map_data(x.tests, c(
      "reg"  = "reg",
      "jour" = "date",
      "T"    = "tests"
    )) 
    
    # cumulate tests
    x.tests <- x.tests %>% 
      group_by(reg, date) %>%
      summarise(tests = as.integer(sum(tests))) %>%
      group_by(reg) %>%
      arrange(date) %>%
      mutate(tests = cumsum(tests))
    
    # download people vaccinated
    # see https://www.data.gouv.fr/fr/datasets/donnees-relatives-aux-personnes-vaccinees-contre-la-covid-19-1/
    url.vacc <- "https://www.data.gouv.fr/fr/datasets/r/735b0df8-51b4-4dd2-8a2d-8e46d77d60d8"
    x.vacc  <- read.csv(url.vacc, sep = ";")
    
    # format people vaccinated
    x.vacc <- map_data(x.vacc, c(
      "jour" = "date",
      "reg" = "reg",
      "n_cum_dose1" = "people_vaccinated",
      "n_cum_complet" = "people_fully_vaccinated"
    ))
    
    # download vaccine doses
    # see https://www.data.gouv.fr/fr/datasets/donnees-relatives-aux-personnes-vaccinees-contre-la-covid-19-1/
    url.doses <- "https://www.data.gouv.fr/fr/datasets/r/900da9b0-8987-4ba7-b117-7aea0e53f530"
    x.doses <- read.csv(url.doses, sep = ";")
    
    # compute vaccine doses
    x.doses <- x.doses %>%
      # filter by total vaccines
      filter(vaccin==0) %>%
      # for each row
      rowwise() %>%
      # compute the sum of all doses
      mutate(vaccines = sum(c_across(starts_with("n_cum_dose")))) %>%
      # rename date
      mutate(date = jour)
    
    # merge
    by <- c("date", "reg")
    x <- x.cases %>%
      full_join(x.tests, by = by) %>%
      full_join(x.doses, by = by) %>%
      full_join(x.vacc, by = by)
    
  }
  
  if(level==3){
    
    # download cases
    # see https://www.data.gouv.fr/fr/datasets/synthese-des-indicateurs-de-suivi-de-lepidemie-covid-19/#_
    url.cases <- "https://www.data.gouv.fr/fr/datasets/r/5c4e1452-3850-4b59-b11c-3dd51d7fb8b5"
    x.cases <- read.csv(url.cases)
    
    # format cases
    x.cases <- map_data(x.cases, c(
      "date" = "date",
      "dep"  = "dep",
      "hosp" = "hosp",
      "rea" = "icu",
      "dchosp" = "deaths",
      "pos" = "confirmed"
    )) 
    
    # cumulate cases
    x.cases <- x.cases %>%
      dplyr::group_by(dep) %>%
      dplyr::arrange(date) %>%
      dplyr::mutate(confirmed = cumsum(confirmed))
    
    # download tests
    # see https://www.data.gouv.fr/fr/datasets/donnees-de-laboratoires-pour-le-depistage-a-compter-du-18-05-2022-si-dep/
    url.tests <- "https://www.data.gouv.fr/fr/datasets/r/674bddab-6d61-4e59-b0bd-0be535490db0"
    x.tests <- read.csv(url.tests, sep = ";", dec = ",")
    
    # format tests
    x.tests <- map_data(x.tests, c(
      "dep"  = "dep",
      "jour" = "date",
      "T"    = "tests"
    )) 
    
    # cumulate tests
    x.tests <- x.tests %>% 
      group_by(dep, date) %>%
      summarise(tests = as.integer(sum(tests))) %>%
      group_by(dep) %>%
      arrange(date) %>%
      mutate(tests = cumsum(tests))
    
    # download people vaccinated
    # see https://www.data.gouv.fr/fr/datasets/donnees-relatives-aux-personnes-vaccinees-contre-la-covid-19-1/
    url.vacc <- "https://www.data.gouv.fr/fr/datasets/r/4f39ec91-80d7-4602-befb-4b522804c0af"
    x.vacc <- read.csv(url.vacc, sep = ";")
    
    # format people vaccinated
    x.vacc <- map_data(x.vacc, c(
      "jour" = "date",
      "dep" = "dep",
      "n_cum_dose1" = "people_vaccinated",
      "n_cum_complet" = "people_fully_vaccinated"
    ))
    
    # download vaccine doses
    # see https://www.data.gouv.fr/fr/datasets/donnees-relatives-aux-personnes-vaccinees-contre-la-covid-19-1/
    url.doses <- "https://www.data.gouv.fr/fr/datasets/r/535f8686-d75d-43d9-94b3-da8cdf850634"
    x.doses <- read.csv(url.doses, sep = ";")
    
    # compute vaccine doses
    x.doses <- x.doses %>%
      # filter by total vaccines
      filter(vaccin==0) %>%
      # for each row
      rowwise() %>%
      # compute the sum of all doses
      mutate(vaccines = sum(c_across(starts_with("n_cum_dose")))) %>%
      # rename date
      mutate(date = jour)
    
    # merge
    by <- c("date", "dep")
    x <- x.cases %>%
      full_join(x.tests, by = by) %>%
      full_join(x.doses, by = by) %>%
      full_join(x.vacc, by = by)
    
  }
  
  # convert to date
  x$date <- as.Date(x$date)
  
  # filter
  if(!is.null(reg))
    x <- x[which(x$reg==reg),]
  if(!is.null(dep))
    x <- x[which(x$dep==dep),]
  
  return(x)
}
