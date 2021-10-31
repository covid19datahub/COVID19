#' Japan
#'
#' @source \url{`r repo("JPN")`}
#' 
JPN <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("JPN", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.swsoyee.2019ncovjapan")`}{Su Wei}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' tests,
    #' hospitalizations,
    #' intensive care,
    #' patients requiring ventilation.
    #'
    x1 <- github.swsoyee.2019ncovjapan(level = level)
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x2 <- ourworldindata.org(id = "JPN") %>%
      select(-c("tests", "hosp", "icu"))
    
    # merge
    x <- full_join(x1, x2, by = "date")
    
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("JPN", 2)`
  #' 
  if(level==2){
    
    #' - \href{`r repo("github.swsoyee.2019ncovjapan")`}{Su Wei}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' tests,
    #' hospitalizations,
    #' intensive care,
    #' patients requiring ventilation.
    #'
    x <- github.swsoyee.2019ncovjapan(level = level)
    x$id <- id(x$jis_code, iso = "JPN", ds = "github.swsoyee.2019ncovjapan", level = level)
    
  }
  
  return(x)
}
