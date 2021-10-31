#' Liechtenstein
#'
#' @source \url{`r repo("LIE")`}
#' 
LIE <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("LIE", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("admin.ch")`}{Federal Office of Public Health}:
    #' confirmed cases,
    #' deaths,
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care.
    #'
    x1 <- admin.ch(state = "FL", level = 1)
    
    #' - \href{`r repo("github.openzh.covid19")`}{Specialist Unit for Open Government Data Canton of Zurich}:
    #' recovered,
    #' patients requiring ventilation.
    #'
    x2 <- github.openzh.covid19(state = "FL", level = 1) %>%
      select(-c("confirmed", "deaths", "tests", "hosp", "icu"))
    
    # merge
    x <- merge(x1, x2, by = "date")
    
  }
  
  return(x)
}
