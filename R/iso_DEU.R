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
    
    #' - \href{`r repo("arcgis.de")`}{Robert Koch Institute}:
    #' confirmed cases,
    #' deaths,
    #' recovered.
    #'
    x1 <- arcgis.de(level = level)
    
    #' - \href{`r repo("impfdashboard.de")`}{Robert Koch Institute and the Federal Ministry of Health}:
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x2 <- impfdashboard.de(level = level)
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' tests,
    #' hospitalizations,
    #' intensive care.
    #'
    x3 <- ourworldindata.org(id = "DEU") %>%
      select(-c("vaccines", "people_vaccinated", "people_fully_vaccinated"))
    
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
    
    #' - \href{`r repo("arcgis.de")`}{Robert Koch Institute}:
    #' confirmed cases,
    #' deaths,
    #' recovered.
    #'
    x1 <- arcgis.de(level = level)
    x1$id <- id(x1$id_state, iso = "DEU", ds = "arcgis.de", level = level)
    
    #' - \href{`r repo("github.robertkochinstitut.covid19impfungenindeutschland")`}{Robert Koch Institut}:
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x2 <- github.robertkochinstitut.covid19impfungenindeutschland(level = level)
    x2$id <- id(x2$id, iso = "DEU", ds = "github.robertkochinstitut.covid19impfungenindeutschland", level = level)
   
    # merge
    x <- full_join(x1, x2, by = c("id", "date"))
     
  }
  
  #' @concept Level 3
  #' @section Data Sources:
  #' 
  #' ## Level 3
  #' `r docstring("DEU", 3)`
  #' 
  if(level==3){  
    
    #' - \href{`r repo("arcgis.de")`}{Robert Koch Institute}:
    #' confirmed cases,
    #' deaths,
    #' recovered.
    #'
    x1 <- arcgis.de(level = level)
    x1$id <- id(x1$id_district, iso = "DEU", ds = "arcgis.de", level = level)
   
    #' - \href{`r repo("github.robertkochinstitut.covid19impfungenindeutschland")`}{Robert Koch Institut}:
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x2 <- github.robertkochinstitut.covid19impfungenindeutschland(level = level)
    x2$id <- id(x2$id, iso = "DEU", ds = "github.robertkochinstitut.covid19impfungenindeutschland", level = level)
    
    # merge
    x <- full_join(x1, x2, by = c("id", "date"))
     
  }
  
  return(x)
}
