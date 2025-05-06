#' Latvia
#'
#' @source \url{`r repo("LVA")`}
#' 
LVA <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("LVA", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("gov.lv")`}{Center for Disease Prevention and Control}:
    #' confirmed cases,
    #' deaths,
    #' tests,
    #' hospitalizations,
    #' intensive care,
    #' patients requiring ventilation.
    #'
    x1 <- gov.lv(level = level)
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' recovered.
    #'
    x2 <- github.cssegisanddata.covid19(country = "Latvia") %>%
      select(-c("confirmed", "deaths"))
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care.
    #'
    x3 <- ourworldindata.org(id = "LVA") %>%
      select(-c("tests", "hosp"))
    
    # use vintage data because hosp data disappeared from ourworldindata.org
    x4 <- covid19datahub.io(iso = "LVA", level) %>% 
      select(date, hosp)

    # merge
    hosp_data <- bind_rows(
      full_join(
        filter(x3, date < "2022-02-01") %>% select(date, icu),
        filter(x4, date < "2022-02-01") %>% select(date, hosp),
        by = "date"),
      filter(x1, date >= "2022-02-01") %>% select(date, hosp, icu))
      
    x <- full_join(x1, x2, by = "date") %>%
      full_join(x3, by = "date") %>% 
      select(-icu.x, -icu.y, - hosp) %>% 
      full_join(hosp_data, by = "date")
    
  }
  
  #' @concept Level 3
  #' @section Data Sources:
  #' 
  #' ## Level 3
  #' `r docstring("LVA", 3)`
  #' 
  if(level==3){  
    
    #' - \href{`r repo("gov.lv")`}{Center for Disease Prevention and Control}:
    #' confirmed cases.
    #'
    x <- gov.lv(level = level)
    x$id <- id(x$atvk, iso = "LVA", ds = "gov.lv", level = level)
  }
  
  return(x)
}
