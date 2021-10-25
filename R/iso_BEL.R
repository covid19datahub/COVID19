#' Belgium
#'
#' @source \url{`r repo("BEL")`}
#' 
BEL <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("BEL", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("sciensano.be")`}{Sciensano, the Belgian Institute for Health}:
    #' confirmed cases,
    #' deaths,
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care,
    #' patients requiring ventilation.
    #'
    x1 <- sciensano.be(level = level)
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' recovered.
    #'
    x2 <- github.cssegisanddata.covid19(country = "Belgium") %>%
      select(date, recovered)
    
    # merge
    x <- full_join(x1, x2, by = "date")
    
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("BEL", 2)`
  #' 
  if(level==2){
    
    #' - \href{`r repo("sciensano.be")`}{Sciensano, the Belgian Institute for Health}:
    #' confirmed cases,
    #' deaths,
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care,
    #' patients requiring ventilation.
    #'
    x <- sciensano.be(level = level)
    x$id <- id(x$REGION, iso = "BEL", ds = "sciensano.be", level = level)
    
  }
  
  #' @concept Level 3
  #' @section Data Sources:
  #' 
  #' ## Level 3
  #' `r docstring("BEL", 3)`
  #' 
  if(level==3){  
    
    #' - \href{`r repo("sciensano.be")`}{Sciensano, the Belgian Institute for Health}:
    #' confirmed cases,
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care,
    #' patients requiring ventilation.
    #'
    x <- sciensano.be(level = level)
    x$id <- id(x$PROVINCE, iso = "BEL", ds = "sciensano.be", level = level)
    
  }
  
  return(x)
}
