#' Chile
#'
#' @source \url{`r repo("CHL")`}
#' 
CHL <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("CHL", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.minciencia.datoscovid19")`}{Ministerio de Ciencia, Tecnología, Conocimiento, e Innovación}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care,
    #' patients requiring ventilation.
    #'
    x <- github.minciencia.datoscovid19(level = level)
    
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("CHL", 2)`
  #' 
  if(level==2){
    
    #' - \href{`r repo("github.minciencia.datoscovid19")`}{Ministerio de Ciencia, Tecnología, Conocimiento, e Innovación}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' intensive care.
    #'
    x <- github.minciencia.datoscovid19(level = level)
    x$id <- id(x$region, iso = "CHL", ds = "github.minciencia.datoscovid19", level = level)
    
  }
  
  #' @concept Level 3
  #' @section Data Sources:
  #' 
  #' ## Level 3
  #' `r docstring("CHL", 3)`
  #' 
  if(level==3){  
    
    #' - \href{`r repo("github.minciencia.datoscovid19")`}{Ministerio de Ciencia, Tecnología, Conocimiento, e Innovación}:
    #' confirmed cases,
    #' deaths,
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x <- github.minciencia.datoscovid19(level = level)
    x$id <- id(x$municipality, iso = "CHL", ds = "github.minciencia.datoscovid19", level = level)
    
  }
  
  return(x)
}
