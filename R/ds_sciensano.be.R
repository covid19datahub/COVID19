#' Sciensano, the Belgian Institute for Health
#'
#' Data source for: Belgium
#'
#' @param level 1, 2, 3
#'
#' @section Level 1:
#' - confirmed cases
#' - deaths
#' - tests
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#' - hospitalizations
#' - intensive care
#' - patients requiring ventilation
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
#' - patients requiring ventilation
#'
#' @section Level 3:
#' - confirmed cases
#' - tests
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#' - hospitalizations
#' - intensive care
#' - patients requiring ventilation
#'
#' @source https://epistat.wiv-isp.be/covid/
#'
#' @keywords internal
#'
sciensano.be <- function(level){
  if(!level %in% 1:3) return(NULL)
  
  # download
  url <- "https://epistat.sciensano.be/Data/COVID19BE.xlsx"
  x   <- read.excel(url)  
  
  # convert date in all the excel sheets
  x <- lapply(x, function(x){
    if("DATE" %in% colnames(x)){
      x$date <- as.Date(x$DATE)
      x$DATE <- NULL  
      x <- x %>% 
        filter(!is.na(date)) %>% 
        arrange(date)
    }
    return(x)
  })
  
  if(level==1){
    
    # confirmed
    confirmed <- x$CASES_AGESEX %>% 
      group_by(date) %>% 
      summarise(confirmed = sum(CASES)) %>%
      arrange(date) %>%
      mutate(confirmed = cumsum(confirmed))
    
    # hosp
    hosp <- x$HOSP %>%
      group_by(date) %>%
      summarise(
        hosp = sum(TOTAL_IN),
        icu  = sum(TOTAL_IN_ICU),
        vent = sum(TOTAL_IN_RESP))
    
    # deaths
    deaths <- x$MORT %>%
      group_by(date) %>%
      summarise(deaths = sum(DEATHS)) %>%
      arrange(date) %>%
      mutate(deaths = cumsum(deaths))
    
    # tests 
    tests <- x$TESTS %>%
      group_by(date) %>%
      summarise(tests = sum(TESTS_ALL)) %>%
      arrange(date) %>%
      mutate(tests = cumsum(tests))
    
    # Sciensano uses the following codes for vaccines. 
    # - For vaccines requiring 2 doses: A for first dose, B for second dose; 
    # - C for vaccine requiring only 1 dose 
    # - E for extra dose of vaccine administered since the 9th of September 2021
    # We use A+C to compute people_vaccinated and B+C to compute people_fully_vaccinated.
    # See https://epistat.sciensano.be/COVID19BE_codebook.pdf
    vaccines <- x$VACC %>%
      group_by(date) %>%
      summarise(
        vaccines = sum(COUNT),
        people_vaccinated = sum(COUNT[DOSE %in% c("A", "C")]),
        people_fully_vaccinated = sum(COUNT[DOSE %in% c("B", "C")])) %>%
      arrange(date) %>%
      mutate(
        vaccines = cumsum(vaccines),
        people_vaccinated = cumsum(people_vaccinated),
        people_fully_vaccinated = cumsum(people_fully_vaccinated))
    
    # merge
    by <- "date"
    x <- confirmed %>%
      full_join(hosp, by = by) %>%
      full_join(deaths, by = by) %>%
      full_join(tests, by = by) %>%
      full_join(vaccines, by = by)
    
  }
  if(level==2){
    
    # confirmed
    confirmed <- x$CASES_AGESEX %>%
      filter(!is.na(REGION)) %>%
      group_by(date, REGION) %>% 
      summarise(confirmed = sum(CASES)) %>%
      group_by(REGION) %>% 
      arrange(date) %>%
      mutate(confirmed = cumsum(confirmed))
    
    # hosp
    hosp <- x$HOSP %>%
      filter(!is.na(REGION)) %>%
      group_by(date, REGION) %>%
      summarise(
        hosp = sum(TOTAL_IN),
        icu  = sum(TOTAL_IN_ICU),
        vent = sum(TOTAL_IN_RESP))
    
    # deaths
    deaths <- x$MORT %>%
      filter(!is.na(REGION)) %>%
      group_by(date, REGION) %>%
      summarise(deaths = sum(DEATHS)) %>%
      group_by(REGION) %>% 
      arrange(date) %>%
      mutate(deaths = cumsum(deaths))
    
    # tests
    tests <- x$TESTS %>%
      filter(!is.na(REGION)) %>%
      group_by(date, REGION) %>%
      summarise(tests = sum(TESTS_ALL)) %>%
      group_by(REGION) %>% 
      arrange(date) %>%
      mutate(tests = cumsum(tests))
    
    # Sciensano uses the following codes for vaccines. 
    # - For vaccines requiring 2 doses: A for first dose, B for second dose; 
    # - C for vaccine requiring only 1 dose 
    # - E for extra dose of vaccine administered since the 9th of September 2021
    # We use A+C to compute people_vaccinated and B+C to compute people_fully_vaccinated.
    # See https://epistat.sciensano.be/COVID19BE_codebook.pdf
    vaccines <- x$VACC %>%
      filter(!is.na(REGION)) %>%
      group_by(date, REGION) %>%
      summarise(
        vaccines = sum(COUNT),
        people_vaccinated = sum(COUNT[DOSE %in% c("A", "C")]),
        people_fully_vaccinated = sum(COUNT[DOSE %in% c("B", "C")])) %>%
      group_by(REGION) %>% 
      arrange(date) %>%
      mutate(
        vaccines = cumsum(vaccines),
        people_vaccinated = cumsum(people_vaccinated),
        people_fully_vaccinated = cumsum(people_fully_vaccinated))
    
    # merge
    by <- c("date", "REGION")
    x <- confirmed %>%
      full_join(hosp, by = by) %>%
      full_join(deaths, by = by) %>%
      full_join(tests, by = by) %>%
      full_join(vaccines, by = by)
    
  }
  
  if(level==3){
    
    # confirmed
    confirmed <- x$CASES_AGESEX %>%
      filter(!is.na(REGION) & !is.na(PROVINCE)) %>%
      group_by(date, REGION, PROVINCE) %>% 
      summarise(confirmed = sum(CASES)) %>%
      group_by(REGION, PROVINCE) %>% 
      arrange(date) %>%
      mutate(confirmed = cumsum(confirmed))
    
    # hosp
    hosp <- x$HOSP %>%
      filter(!is.na(REGION) & !is.na(PROVINCE)) %>%
      group_by(date, REGION, PROVINCE) %>%
      summarise(
        hosp = sum(TOTAL_IN),
        icu  = sum(TOTAL_IN_ICU),
        vent = sum(TOTAL_IN_RESP))
    
    # tests
    tests <- x$TESTS %>%
      filter(!is.na(REGION) & !is.na(PROVINCE)) %>%
      group_by(date, REGION, PROVINCE) %>%
      summarise(tests = sum(TESTS_ALL)) %>%
      group_by(REGION, PROVINCE) %>% 
      arrange(date) %>%
      mutate(tests = cumsum(tests))
    
    # Sciensano uses the following codes for vaccines. 
    # - For vaccines requiring 2 doses: A for first dose, B for second dose; 
    # - C for vaccine requiring only 1 dose 
    # - E for extra dose of vaccine administered since the 9th of September 2021
    # We use A+C to compute people_vaccinated and B+C to compute people_fully_vaccinated.
    # See https://epistat.sciensano.be/COVID19BE_codebook.pdf
    vaccines <- x$VACC_MUNI_CUM %>%
      filter(CUMUL!="<10") %>%
      mutate(
        NIS5 = as.character(NIS5),
        CUMUL = as.integer(CUMUL),
        # convert epidemiological week to date. 
        # the vaccines are reported at the end of the week on Sundays.
        YEAR = as.integer(paste0("20", substr(YEAR_WEEK, 0, 2))),
        WEEK = as.integer(substr(YEAR_WEEK, 4, 6)),
        date = MMWRweek::MMWRweek2Date(YEAR, WEEK)+7) %>%
      left_join(x$CASES_MUNI_CUM, by = "NIS5") %>%
      filter(!is.na(REGION) & !is.na(PROVINCE)) %>%
      group_by(date, REGION, PROVINCE) %>%
      summarise(
        vaccines = sum(CUMUL),
        people_vaccinated = sum(CUMUL[DOSE %in% c("A", "C")]),
        people_fully_vaccinated = sum(CUMUL[DOSE %in% c("B", "C")]))
    
    # merge
    by <- c("date", "REGION", "PROVINCE")
    x <- confirmed %>%
      full_join(hosp, by = by) %>%
      full_join(tests, by = by) %>%
      full_join(vaccines, by = by)
    
  }
  
  return(x)
}
