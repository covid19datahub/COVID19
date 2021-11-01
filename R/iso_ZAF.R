#' South Africa
#'
#' @source \url{`r repo("ZAF")`}
#' 
ZAF <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("ZAF", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.dsfsi.covid19za")`}{Data Science for Social Impact research group, University of Pretoria}:
    #' confirmed cases,
    #' deaths,
    #' recovered.
    #'
    x1 <- github.dsfsi.covid19za(level = level) %>%
      select(-c("tests"))
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care.
    #'
    x2 <- ourworldindata.org(id = "ZAF")    
    
    # merge 
    x <- full_join(x1, x2, by = "date")
    
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("ZAF", 2)`
  #' 
  if(level==2){
    
    #' - \href{`r repo("github.dsfsi.covid19za")`}{Data Science for Social Impact research group, University of Pretoria}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' tests.
    #'
    x <- github.dsfsi.covid19za(level = level)
    x$id <- id(x$state, iso = "ZAF", ds = "github.dsfsi.covid19za", level = level)
    
  }
  
  return(x)
}
