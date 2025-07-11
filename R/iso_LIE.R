#' Liechtenstein
#'
#' @source \url{`r repo("LIE")`}
#' 
LIE <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("LIE", 1)`
  #' 
  if(level==1){

    #' - \href{`r repo("admin.ch")`}{Federal Office of Public Health}:
    #' confirmed cases,
    #' deaths,
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x1 <- admin.ch(state = "FL", level = 1) %>% 
      select(-hosp)
    
    # use vintage data because the type "COVID19FullyVaccPersons" 
    # in the vacc file from admin.ch is no longer available
    x2 <- covid19datahub.io(iso = "LIE", level) %>% 
      select(date, people_fully_vaccinated)
    
    #' - \href{`r repo("who.int")`}{World Health Organization}:
    #' confirmed cases,
    #' deaths.
    #'
    x3 <- who.int(level = level, id = "LI") %>% 
      filter(date > "2023-11-28")
    
    #' - \href{`r repo("github.openzh.covid19")`}{Specialist Unit for Open Government Data Canton of Zurich}:
    #' recovered,
    #' hospitalizations.
    #'
    x4 <- github.openzh.covid19(state = "FL", level = 1) %>%
      select(-c("confirmed", "deaths", "tests", "icu"))
    
    # merge
    x <- bind_rows(x1, x3) %>% 
      full_join(x2, by = "date") %>% 
      full_join(x4, by = "date")
    
  }
  
  return(x)
}
