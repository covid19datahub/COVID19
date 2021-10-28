#' Ministry of Health of the Czech Republic
#'
#' Data source for: Czech Republic
#'
#' @param level 1, 2, 3
#'
#' @section Level 1:
#' - confirmed cases
#' - deaths
#' - recovered
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
#' - recovered
#' - tests
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#'
#' @section Level 3:
#' - confirmed cases
#' - deaths
#' - recovered
#' - tests
#'
#' @source https://onemocneni-aktualne.mzcr.cz/api/v2/covid-19
#'
#' @keywords internal
#'
mzcr.cz <- function(level){
  if(!level %in% 1:3) return(NULL)
  
  # vaccines
  url.vacc <- "https://onemocneni-aktualne.mzcr.cz/api/v2/covid-19/ockovani.csv"
  x.vacc <- read.csv(url.vacc, fileEncoding = "UTF-8-BOM", encoding = "Latin1")
  
  # format
  x.vacc <- map_data(x.vacc, c(
    "datum" = "date",
    "vakcina" = "type",
    "kraj_nuts_kod" = "nuts",
    "prvnich_davek" = "first",
    "druhych_davek" = "second"
  ))
  
  # compute total doses and people vaccinated  
  x.vacc <- x.vacc %>%
    mutate(
      is_oneshot = type=="COVID-19 Vaccine Janssen",
      vaccines = first + second,
      people_vaccinated = first,
      people_fully_vaccinated = first*is_oneshot + second*(!is_oneshot))
  
  if(level==1){
    
    # confirmed, recovered, deaths, tests
    url.cases <- "https://onemocneni-aktualne.mzcr.cz/api/v2/covid-19/nakazeni-vyleceni-umrti-testy.csv"
    x.cases <- read.csv(url.cases, fileEncoding = "UTF-8-BOM")
    
    # format
    x.cases <- map_data(x.cases, c(
      "datum" = "date",
      "kumulativni_pocet_nakazenych" = "confirmed",
      "kumulativni_pocet_vylecenych" = "recovered",
      "kumulativni_pocet_umrti" = "deaths",
      "kumulativni_pocet_testu" = "pcr",
      "kumulativni_pocet_ag_testu" = "antigen"
    ))
    
    # compute total tests
    x.cases$tests <- x.cases$pcr + x.cases$antigen
    
    # hospitalizations
    url.hosp <- "https://onemocneni-aktualne.mzcr.cz/api/v2/covid-19/hospitalizace.csv"
    x.hosp <- read.csv(url.hosp, fileEncoding = "UTF-8-BOM")
    x.hosp <- map_data(x.hosp, c(
      "datum" = "date",
      "pocet_hosp" = "hosp",
      "jip" = "icu",
      "upv" = "vent"
    ))
    
    # compute cumulative vaccination data
    x.vacc <- x.vacc %>%
      # for each date
      group_by(date) %>%
      # compute total counts
      summarise(
        vaccines = sum(vaccines),
        people_vaccinated = sum(people_vaccinated),
        people_fully_vaccinated = sum(people_fully_vaccinated)) %>%
      # sort by date
      arrange(date) %>%
      # cumulate
      mutate(
        vaccines = cumsum(vaccines),
        people_vaccinated = cumsum(people_vaccinated),
        people_fully_vaccinated = cumsum(people_fully_vaccinated))
    
    # merge
    by <- "date"
    x <- x.cases %>%
      full_join(x.hosp, by = by) %>%
      full_join(x.vacc, by = by)
    
  }
  
  if(level==2 | level==3){
    
    # confirmed, recovered, deaths
    url.cases <- "https://onemocneni-aktualne.mzcr.cz/api/v2/covid-19/kraj-okres-nakazeni-vyleceni-umrti.csv"
    x.cases <- read.csv(url.cases, fileEncoding = "UTF-8-BOM")
    
    # format
    x.cases <- map_data(x.cases, c(
      "datum" = "date",
      "kraj_nuts_kod" = "nuts",
      "okres_lau_kod" = "lau",
      "kumulativni_pocet_nakazenych" = "confirmed",
      "kumulativni_pocet_vylecenych" = "recovered",
      "kumulativni_pocet_umrti" = "deaths"
    ))
    
    # tests
    url.tests <- "https://onemocneni-aktualne.mzcr.cz/api/v2/covid-19/kraj-okres-testy.csv"
    x.tests <- read.csv(url.tests, fileEncoding = "UTF-8-BOM")  
    
    # format
    x.tests <- map_data(x.tests, c(
      "datum" = "date",
      "kraj_nuts_kod" = "nuts",
      "okres_lau_kod" = "lau",
      "kumulativni_pocet_testu_okres" = "tests_lau",
      "kumulativni_pocet_testu_kraj" = "tests_nuts"
    ))
    
    if(level==2){
      
      # compute cases by state
      x.cases <- x.cases %>%
        filter(!is.na(nuts)) %>%
        group_by(nuts, date) %>%
        summarise(
          confirmed = sum(confirmed),
          recovered = sum(recovered),
          deaths    = sum(deaths))
      
      # compute tests by state
      x.tests <- x.tests %>%
        filter(!is.na(nuts)) %>%
        group_by(nuts, date) %>%
        summarise(tests = median(tests_nuts))
      
      # compute vaccines by state
      x.vacc <- x.vacc %>%
        # for each date and state
        group_by(date, nuts) %>%
        # compute total counts
        summarise(
          vaccines = sum(vaccines),
          people_vaccinated = sum(people_vaccinated),
          people_fully_vaccinated = sum(people_fully_vaccinated)) %>%
        # group by state
        group_by(nuts) %>%
        # sort by date
        arrange(date) %>%
        # cumulate
        mutate(
          vaccines = cumsum(vaccines),
          people_vaccinated = cumsum(people_vaccinated),
          people_fully_vaccinated = cumsum(people_fully_vaccinated))
      
      # merge
      by <- c("date", "nuts")
      x <- x.cases %>%
        full_join(x.tests, by = by) %>%
        full_join(x.vacc, by = by)
      
    }
    
    if(level==3){
      
      # filter cases by lau
      x.cases <- x.cases %>%
        filter(!is.na(lau)) 
      
      # filter tests by lau
      x.tests <- x.tests %>%
        filter(!is.na(lau)) %>%
        mutate(tests = tests_lau)
      
      # merge
      x <- full_join(x.cases, x.tests, by = c("date", "lau")) 
      
    }
    
  }
  
  # convert date
  x$date <- as.Date(x$date)
  
  return(x)
}
