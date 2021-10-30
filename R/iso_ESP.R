#' Spain
#'
#' @source \url{`r repo("ESP")`}
#' 
ESP <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("ESP", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' confirmed cases,
    #' deaths,
    #' recovered.
    #'
    x1 <- github.cssegisanddata.covid19(country = "Spain")
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care.
    #'
    x2 <- ourworldindata.org(id = "ESP")
    
    # merge
    x <- full_join(x1, x2, by = "date")
    
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("ESP", 2)`
  #' 
  if(level==2){
    
    #' - \href{`r repo("isciii.es")`}{Centro Nacional de Epidemiología}:
    #' confirmed cases.
    #'
    x <- isciii.es(level = level)
    x$id <- id(x$state, iso = "ESP", ds = "isciii.es", level = level)
    
  }
  
  #' @concept Level 3
  #' @section Data Sources:
  #' 
  #' ## Level 3
  #' `r docstring("ESP", 3)`
  #' 
  if(level==3){  
    
    #' - \href{`r repo("isciii.es")`}{Centro Nacional de Epidemiología}:
    #' confirmed cases,
    #' deaths,
    #' hospitalizations,
    #' intensive care.
    #'
    x <- isciii.es(level = level)
    x$id <- id(x$district, iso = "ESP", ds = "isciii.es", level = level)
    
  }
  
  return(x)
}
