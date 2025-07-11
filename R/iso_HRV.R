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
    
    # use vintage data because files form koronavirus.hr are not available
    x1 <- covid19datahub.io(iso = "HRV", level) %>% 
      select(date, confirmed, deaths, recovered)
    x1 <- x1[x1$date <= "2023-11-27",]
    
    #' - \href{`r repo("who.int")`}{World Health Organization}:
    #' confirmed cases,
    #' deaths.
    #'
    x2 <- who.int(level, id = "HR")
    x2 <- x2[x2$date > "2023-11-27",]
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations.
    #'
    x3 <- ourworldindata.org(id = "HRV")
    
    # merge
    x <- bind_rows(x1, x2) %>%
      full_join(x3, by = "date")
    
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
    
    # use vintage data because files form koronavirus.hr are not available
    x <- covid19datahub.io(iso = "HRV", level) %>% 
      select(id, date, confirmed, deaths, recovered)
   
  }
  
  return(x)
}
