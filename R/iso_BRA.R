#' Brazil 
#'
#' @source \url{`r repo("BRA")`}
#' 
BRA <- function(level, ...){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("BRA", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.wcota.covid19br")`}{Wesley Cota}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' tests,
    #' total vaccine doses administered.
    #'
    x <- github.wcota.covid19br(level = level)
   
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("BRA", 2)`
  #' 
  if(level==2){
    
    #' - \href{`r repo("github.wcota.covid19br")`}{Wesley Cota}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' tests,
    #' total vaccine doses administered.
    #'
    x <- github.wcota.covid19br(level = level)
    x$id <- id(x$state, iso = "BRA", ds = "github.wcota.covid19br", level = level)
    
  }
  
  #' @concept Level 3
  #' @section Data Sources:
  #' 
  #' ## Level 3
  #' `r docstring("BRA", 3)`
  #' 
  if(level==3){  

    #' - \href{`r repo("github.wcota.covid19br")`}{Wesley Cota}:
    #' confirmed cases,
    #' deaths.
    #'
    x <- github.wcota.covid19br(level = level)
    x$id <- id(x$code, iso = "BRA", ds = "github.wcota.covid19br", level = level)
    
    #' - \href{`r repo("github.covid19datahub.covid19br")`}{Emanuele Guidotti}:
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    v <- github.covid19datahub.covid19br(level = level)
    v$id <- id(v$ibge, iso = "BRA", ds = "github.covid19datahub.covid19br", level = level)
    
    # merge
    x <- full_join(x, v, by = c("id", "date"))
    
  }
  
  return(x)
}
