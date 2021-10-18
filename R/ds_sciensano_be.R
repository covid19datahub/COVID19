#' Sciensano, the Belgian institute for health
#' 
#' Imports confirmed cases, hospitalizations, deaths, tests, and vaccines for Belgium
#' at national, regional, and province level from Sciensano. The number of deaths is not
#' available at the province level. 
#' 
#' Sciensano uses the following codes. 
#' - For vaccines requiring 2 doses: A for first dose, B for second dose; 
#' - C for vaccine requiring only 1 dose 
#' - E for extra dose of vaccine administered since the 9th of September 2021
#' See https://epistat.sciensano.be/COVID19BE_codebook.pdf
#' 
#' We use A+C to compute vaccines_1 (at least one dose) and B+C to compute vaccines_2 (fully vaccinated).
#' 
#' @source 
#' https://epistat.wiv-isp.be/covid/
#' 
#' @keywords internal
#' 
sciensano_be <- function(level){

  # download
  url <- "https://epistat.sciensano.be/Data/COVID19BE.xlsx"
  x   <- read.excel(url)  
  
  # convert date
  x <- lapply(x, function(x){
    if("DATE" %in% colnames(x)){
      x$date <- as.Date(x$DATE)
      x$DATE <- NULL  
      x <- x %>% 
        dplyr::filter(!is.na(date)) %>% 
        dplyr::arrange(date)
    }
    return(x)
  })
  
  if(level==1){
    
    # confirmed
    confirmed <- x$CASES_AGESEX %>% 
      dplyr::group_by(date) %>% 
      dplyr::summarise(confirmed = sum(CASES)) %>%
      dplyr::arrange(date) %>%
      dplyr::mutate(confirmed = cumsum(confirmed))
    
    # hosp
    hosp <- x$HOSP %>%
      dplyr::group_by(date) %>%
      dplyr::summarise(hosp = sum(TOTAL_IN),
                       icu  = sum(TOTAL_IN_ICU),
                       vent = sum(TOTAL_IN_RESP))
    
    # deaths
    deaths <- x$MORT %>%
      dplyr::group_by(date) %>%
      dplyr::summarise(deaths = sum(DEATHS)) %>%
      dplyr::arrange(date) %>%
      dplyr::mutate(deaths = cumsum(deaths))
    
    # tests 
    tests <- x$TESTS %>%
      dplyr::group_by(date) %>%
      dplyr::summarise(tests = sum(TESTS_ALL)) %>%
      dplyr::arrange(date) %>%
      dplyr::mutate(tests = cumsum(tests))
    
    # vaccines
    vaccines <- x$VACC %>%
      dplyr::group_by(date) %>%
      dplyr::summarise(
        vaccines = sum(COUNT),
        vaccines_1 = sum(COUNT[DOSE %in% c("A", "C")]),
        vaccines_2 = sum(COUNT[DOSE %in% c("B", "C")])) %>%
      dplyr::arrange(date) %>%
      dplyr::mutate(
        vaccines = cumsum(vaccines),
        vaccines_1 = cumsum(vaccines_1),
        vaccines_2 = cumsum(vaccines_2))
    
    # merge
    x <- merge(confirmed, hosp, all = TRUE)
    x <- merge(x, deaths, all = TRUE)
    x <- merge(x, tests, all = TRUE)
    x <- merge(x, vaccines, all = TRUE)
    
  }
  if(level==2){
    
    # confirmed
    confirmed <- x$CASES_AGESEX %>%
      dplyr::filter(!is.na(REGION)) %>%
      dplyr::group_by(date, REGION) %>% 
      dplyr::summarise(confirmed = sum(CASES)) %>%
      dplyr::group_by(REGION) %>% 
      dplyr::arrange(date) %>%
      dplyr::mutate(confirmed = cumsum(confirmed))
    
    # hosp
    hosp <- x$HOSP %>%
      dplyr::filter(!is.na(REGION)) %>%
      dplyr::group_by(date, REGION) %>%
      dplyr::summarise(hosp = sum(TOTAL_IN),
                       icu  = sum(TOTAL_IN_ICU),
                       vent = sum(TOTAL_IN_RESP))
    
    # deaths
    deaths <- x$MORT %>%
      dplyr::filter(!is.na(REGION)) %>%
      dplyr::group_by(date, REGION) %>%
      dplyr::summarise(deaths = sum(DEATHS)) %>%
      dplyr::group_by(REGION) %>% 
      dplyr::arrange(date) %>%
      dplyr::mutate(deaths = cumsum(deaths))
    
    # tests
    tests <- x$TESTS %>%
      dplyr::filter(!is.na(REGION)) %>%
      dplyr::group_by(date, REGION) %>%
      dplyr::summarise(tests = sum(TESTS_ALL)) %>%
      dplyr::group_by(REGION) %>% 
      dplyr::arrange(date) %>%
      dplyr::mutate(tests = cumsum(tests))
    
    # vaccines
    vaccines <- x$VACC %>%
      dplyr::filter(!is.na(REGION)) %>%
      dplyr::group_by(date, REGION) %>%
      dplyr::summarise(
        vaccines = sum(COUNT),
        vaccines_1 = sum(COUNT[DOSE %in% c("A", "C")]),
        vaccines_2 = sum(COUNT[DOSE %in% c("B", "C")])) %>%
      dplyr::group_by(REGION) %>% 
      dplyr::arrange(date) %>%
      dplyr::mutate(
        vaccines = cumsum(vaccines),
        vaccines_1 = cumsum(vaccines_1),
        vaccines_2 = cumsum(vaccines_2))
    
    # merge
    x <- merge(confirmed, hosp, all = TRUE)
    x <- merge(x, deaths, all = TRUE)
    x <- merge(x, tests, all = TRUE)
    x <- merge(x, vaccines, all = TRUE)

  }
 
  if(level==3){
    
    # confirmed
    confirmed <- x$CASES_AGESEX %>%
      dplyr::filter(!is.na(REGION) & !is.na(PROVINCE)) %>%
      dplyr::group_by(date, REGION, PROVINCE) %>% 
      dplyr::summarise(confirmed = sum(CASES)) %>%
      dplyr::group_by(REGION, PROVINCE) %>% 
      dplyr::arrange(date) %>%
      dplyr::mutate(confirmed = cumsum(confirmed))
    
    # hosp
    hosp <- x$HOSP %>%
      dplyr::filter(!is.na(REGION) & !is.na(PROVINCE)) %>%
      dplyr::group_by(date, REGION, PROVINCE) %>%
      dplyr::summarise(hosp = sum(TOTAL_IN),
                       icu  = sum(TOTAL_IN_ICU),
                       vent = sum(TOTAL_IN_RESP))
    
    # tests
    tests <- x$TESTS %>%
      dplyr::filter(!is.na(REGION) & !is.na(PROVINCE)) %>%
      dplyr::group_by(date, REGION, PROVINCE) %>%
      dplyr::summarise(tests = sum(TESTS_ALL)) %>%
      dplyr::group_by(REGION, PROVINCE) %>% 
      dplyr::arrange(date) %>%
      dplyr::mutate(tests = cumsum(tests))
    
    # vaccines
    vaccines <- x$VACC_MUNI_CUM %>%
      dplyr::filter(CUMUL!="<10") %>%
      dplyr::mutate(
        NIS5 = as.character(NIS5),
        CUMUL = as.integer(CUMUL),
        # convert epidemiological week to date. 
        # the vaccines are reported at the end of the week on Sundays.
        YEAR = as.integer(paste0("20", substr(YEAR_WEEK, 0, 2))),
        WEEK = as.integer(substr(YEAR_WEEK, 4, 6)),
        date = MMWRweek::MMWRweek2Date(YEAR, WEEK)+7) %>%
      dplyr::left_join(x$CASES_MUNI_CUM, by = "NIS5") %>%
      dplyr::filter(!is.na(REGION) & !is.na(PROVINCE)) %>%
      dplyr::group_by(date, REGION, PROVINCE) %>%
      dplyr::summarise(
        vaccines = sum(CUMUL),
        vaccines_1 = sum(CUMUL[DOSE %in% c("A", "C")]),
        vaccines_2 = sum(CUMUL[DOSE %in% c("B", "C")]))
    
    # merge
    x <- merge(confirmed, hosp, all = TRUE)
    x <- merge(x, tests, all = TRUE)
    x <- merge(x, vaccines, all = TRUE)
    
  }
  
  return(x)
  
}