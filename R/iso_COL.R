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
    #' recovered,
    #' tests.
    #'
    x1 <- gov.co(level = level)
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care.
    #'
    x2 <- ourworldindata.org(id = "COL") %>%
      select(-c("tests"))
    
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
    x <- gov.co(level = level)
    x$id <- id(x$state, iso = "COL", ds = "gov.co", level = level)
    
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
    x <- gov.co(level = level)
    x$id <- id(x$city_code, iso = "COL", ds = "gov.co", level = level)
    
  }
  
  return(x)
}
