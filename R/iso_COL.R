#' Colombia
#'
#' @source \url{`r repo("COL")`}
#' 
COL <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("COL", 1)`
  #' 
  if(level==1){

    #' - \href{`r repo("gov.co")`}{Instituto Nacional de Salud}:
    #' confirmed cases,
    #' deaths,
    #' recovered.
    #'
    x1 <- gov.co(level = level)
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x2 <- ourworldindata.org(id = "COL")
    
    # merge
    x <- full_join(x1, x2, by = "date")
    
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("COL", 2)`
  #' 
  if(level==2){
 
    #' - \href{`r repo("gov.co")`}{Instituto Nacional de Salud}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' tests.
    #'
    x1 <- gov.co(level = level)
    x1$id <- id(x1$state_code, iso = "COL", ds = "gov.co", level = level)
    
    # use vintage data because gov.co file with antigen tests is empty
    x2 <- covid19datahub.io(iso = "COL", level) %>% 
      select(id, date, tests)
    
    # merge
    x <- full_join(x1, x2, by = c("date", "id"))

  }
  
  #' @concept Level 3
  #' @section Data Sources:
  #' 
  #' ## Level 3
  #' `r docstring("COL", 3)`
  #' 
  if(level==3){  
  
    #' - \href{`r repo("gov.co")`}{Instituto Nacional de Salud}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x1 <- gov.co(level = level)
    x1$id <- id(x1$city_code, iso = "COL", ds = "gov.co", level = level)
    
    # use vintage data because file with vaccines from gov.co is no longer available
    x2 <- covid19datahub.io(iso = "COL", level) %>% 
      select(id, date, people_vaccinated, people_fully_vaccinated)
    
    # merge
    x <- full_join(x1, x2, by = c("date", "id"))
  }
  
  return(x)
}
