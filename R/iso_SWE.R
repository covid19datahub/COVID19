#' Sweden
#'
#' @source \url{`r repo("SWE")`}
#' 
SWE <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("SWE", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("arcgis.se")`}{Public Health Agency of Sweden}:
    #' confirmed cases,
    #' deaths.
    #'
    
    # use vintage data because arcgis.se restricted access to the data (not available)
    x1 <- covid19datahub.io(iso = "SWE", level) %>% 
      select(date, confirmed, deaths) %>% 
     filter(date <= "2023-03-22")
    
    #' - \href{`r repo("who.int")`}{World Health Organization}:
    #' confirmed cases,
    #' deaths.
    #' 
    x2 <- who.int(level, id = "SE") %>% 
      filter(date > "2023-03-22")
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care.
    #'
    x3 <- ourworldindata.org(id = "SWE")
    
    # merge
    x <- bind_rows(x1, x2) %>% 
      full_join(x3, by = "date")
    
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("SWE", 2)`
  #' 
  if(level==2){
    
    #' - \href{`r repo("arcgis.se")`}{Public Health Agency of Sweden}:
    #' confirmed cases.
    #'
    # use vintage data because arcgis.se restricted access to the data (not available)
    x1 <- covid19datahub.io(iso = "SWE", level) %>% 
      select(id, date, confirmed)
    
  }
  
  return(x)
}
