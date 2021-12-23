#' Argentina
#'
#' @source \url{`r repo("ARG")`}
#' 
ARG <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("ARG", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' confirmed cases,
    #' deaths,
    #' recovered.
    #'
    x1 <- github.cssegisanddata.covid19(country = "Argentina")
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care.
    #'
    x2 <- ourworldindata.org(id = "ARG")
    
    # merge
    x <- full_join(x1, x2, by = "date")
    
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("ARG", 2)`
  #' 
  if(level==2){
   
    #' - \href{`r repo("gob.ar")`}{Argentine Ministry of Health}:
    #' - confirmed cases
    #' - deaths
    #' - tests
    #' - total vaccine doses administered
    #' - people with at least one vaccine dose
    #' - people fully vaccinated
    #'
    x <- gob.ar(level = level)
    x$id <- id(x$prov, iso = "ARG", ds = "gob.ar", level = level)
    
  }
  
  #' @concept Level 3
  #' @section Data Sources:
  #' 
  #' ## Level 3
  #' `r docstring("ARG", 3)`
  #' 
  if(level==3){
    
    #' - \href{`r repo("gob.ar")`}{Argentine Ministry of Health}:
    #' - confirmed cases
    #' - deaths
    #' - tests
    #' - total vaccine doses administered
    #' - people with at least one vaccine dose
    #' - people fully vaccinated
    #'
    x <- gob.ar(level = level)
    x$id <- id(x$dep, iso = "ARG", ds = "gob.ar", level = level)
    
  }
  
  return(x)
}
