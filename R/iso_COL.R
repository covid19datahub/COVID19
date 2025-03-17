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
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care.
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
    #' Due to changes in the original file,  
    #' - \href{`r repo("covid19datahub.io")`}{COVID-19 Data Hub}  
    #' now provides historical data, which was previously sourced from:  
    #' 
    #' - \href{`r repo("gov.co")`}{Instituto Nacional de Salud}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' tests.
    #'
    x1 <- gov.co(level = level)
    x1$id <- id(x1$state, iso = "COL", ds = "gov.co", level = level)
    
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
    #' Due to changes in the original file,  
    #' - \href{`r repo("covid19datahub.io")`}{COVID-19 Data Hub}  
    #' now provides historical data, which was previously sourced from:  
    #' 
    #' - \href{`r repo("gov.co")`}{Instituto Nacional de Salud}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x1 <- gov.co(level = level)
    x1$id <- id(x1$city_code, iso = "COL", ds = "gov.co", level = level)
    
    x2 <- covid19datahub.io(iso = "COL", level) %>% 
      select(id, date, people_vaccinated, people_fully_vaccinated)
    
    # merge
    x <- full_join(x1, x2, by = c("date", "id"))
  }
  
  return(x)
}
