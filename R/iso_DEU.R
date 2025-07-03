#' Germany
#'
#' @source \url{`r repo("DEU")`}
#' 
DEU <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("DEU", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.robertkochinstitut.covid19impfungenindeutschland")`}{Robert Koch Institut}:
    #' confirmed cases,
    #' deaths,
    #' recovered.
    #'
    x1 <- github.robertkochinstitut.covid19impfungenindeutschland(level = level)
    
    #' - \href{`r repo("impfdashboard.de")`}{Robert Koch Institute and the Federal Ministry of Health}:
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x2 <- impfdashboard.de(level = level)
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' tests,
    #' intensive care.
    #'
    x3 <- ourworldindata.org(id = "DEU") %>%
      select(date, tests, icu)
    
    # merge
    x <- x1 %>% 
      full_join(x2, by = "date") %>%
      full_join(x3, by = "date") 
    
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("DEU", 2)`
  #' 
  if(level==2){

    #' - \href{`r repo("github.robertkochinstitut.covid19impfungenindeutschland")`}{Robert Koch Institut}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x <- github.robertkochinstitut.covid19impfungenindeutschland(level = level)
    x$id <- id(x$id_state, iso = "DEU", ds = "github.robertkochinstitut.covid19impfungenindeutschland", level = level)
     
  }
  
  #' @concept Level 3
  #' @section Data Sources:
  #' 
  #' ## Level 3
  #' `r docstring("DEU", 3)`
  #' 
  if(level==3){  

    #' - \href{`r repo("github.robertkochinstitut.covid19impfungenindeutschland")`}{Robert Koch Institut}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x <- github.robertkochinstitut.covid19impfungenindeutschland(level = level)
    x$id <- id(x$id_district, iso = "DEU", ds = "github.robertkochinstitut.covid19impfungenindeutschland", level = level)
     
  }
  
  return(x)
}
