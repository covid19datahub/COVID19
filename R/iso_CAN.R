#' Canada
#'
#' @source \url{`r repo("CAN")`}
#' 
CAN <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("CAN", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("canada.ca")`}{Public Health Agency of Canada}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' tests.
    #'
    x1 <- canada.ca(level = level) %>%
      select(-one_of('vaccines', 'people_vaccinated', "people_fully_vaccinated"))
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care.
    #'
    x2 <- ourworldindata.org(id = "CAN") %>%
      select(-tests)
    
    # merge
    x <- full_join(x1, x2, by = "date")
    
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("CAN", 2)`
  #' 
  if(level==2){
    
    #' - \href{`r repo("canada.ca")`}{Public Health Agency of Canada}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x <- canada.ca(level = level)
    x$id <- id(x$id, iso = "CAN", ds = "canada.ca", level = level)
    
  }
  
  return(x)
}
