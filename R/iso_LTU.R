#' Lithuania
#'
#' @source \url{`r repo("LTU")`}
#' 
LTU <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("LTU", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.mpiktas.covid19lt")`}{Vaidotas Zemlys-Balevicius}:
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
    x1 <- github.mpiktas.covid19lt(level = level)
    
    # use vintage data because recovered disappeared from github.mpiktas.covid19lt
    x2 <- covid19datahub.io(iso = "LTU", level) %>% 
      select(date, recovered)
    
    # merge
    x <- full_join(x1, x2, by = "date")
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("LTU", 2)`
  #' 
  if(level==2){
    
    #' - \href{`r repo("github.mpiktas.covid19lt")`}{Vaidotas Zemlys-Balevicius}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x1 <- github.mpiktas.covid19lt(level = level)
    x1$id <- id(x1$admin2, iso = "LTU", ds = "github.mpiktas.covid19lt", level = level)
    
    # use vintage data because recovered disappeared from github.mpiktas.covid19lt
    x2 <- covid19datahub.io(iso = "LTU", level) %>% 
      select(id, date, recovered)
    
    # merge
    x <- full_join(x1, x2, by = c("date", "id"))
    
  }
  
  #' @concept Level 3
  #' @section Data Sources:
  #' 
  #' ## Level 3
  #' `r docstring("LTU", 3)`
  #' 
  if(level==3){  
 
    #' - \href{`r repo("github.mpiktas.covid19lt")`}{Vaidotas Zemlys-Balevicius}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x1 <- github.mpiktas.covid19lt(level = level)
    x1$id <- id(x1$admin3, iso = "LTU", ds = "github.mpiktas.covid19lt", level = level)
    
    # use vintage data because recovered disappeared from github.mpiktas.covid19lt
    x2 <- covid19datahub.io(iso = "LTU", level) %>% 
      select(id, date, recovered)
    
    # merge
    x <- full_join(x1, x2, by = c("date", "id"))
  }
  
  return(x)
}
