#' Croatia
#'
#' @source \url{`r repo("HRV")`}
#' 
HRV <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("HRV", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("koronavirus.hr")`}{Croatian Institute of Public Health}:
    #' confirmed cases,
    #' deaths,
    #' recovered.
    #'
    x1 <- koronavirus.hr(level = level)
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care.
    #'
    x2 <- ourworldindata.org(id = "HRV")
    
    # merge
    x <- full_join(x1, x2, by = "date")
    
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("HRV", 2)`
  #' 
  if(level==2){
    
    #' - \href{`r repo("koronavirus.hr")`}{Croatian Institute of Public Health}:
    #' confirmed cases,
    #' deaths,
    #' recovered.
    #'
    x <- koronavirus.hr(level = level)
    x$id <- id(x$region, iso = "HRV", ds = "koronavirus.hr", level = level)
    
  }
  
  return(x)
}
