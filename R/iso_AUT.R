#' Austria
#'
#' @source \url{`r repo("AUT")`}
#' 
AUT <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("AUT", 1)`
  #' 
  if(level==1){
    
    #' As the original files are no longer available,  
    #' - \href{`r repo("covid19datahub.io")`}{COVID-19 Data Hub} 
    #' now provides historical data, which was previously sourced from:
    #' 
    #' - \href{`r repo("gv.at")`}{Federal Ministry of Social Affairs, Health, Care and Consumer Protection, Austria}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care.
    #' 
    x1 <- covid19datahub.io(iso = "AUT", level)
    
    #' - \href{`r repo("who.int")`}{World Health Organization}:
    #' confirmed cases,
    #' deaths.
    #'
    x2 <- who.int(level = 1, id = "AT")
    x2 <- x2[x2$date > "2023-04-30",] 

    x <- full_join(x1, x2, by = "date") %>%
      mutate(confirmed = coalesce(confirmed.x, confirmed.y),
             deaths = coalesce(deaths.x, deaths.y))
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("AUT", 2)`
  #' 
  if(level==2){
    
    #' As the original files are no longer available,  
    #' - \href{`r repo("covid19datahub.io")`}{COVID-19 Data Hub} 
    #' now provides historical data, which was previously sourced from:
    #' 
    #' - \href{`r repo("gv.at")`}{Federal Ministry of Social Affairs, Health, Care and Consumer Protection, Austria}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care.
    #' 
    x <- covid19datahub.io(iso = "AUT", level)
    
  }
  
  #' @concept Level 3
  #' @section Data Sources:
  #' 
  #' ## Level 3
  #' `r docstring("AUT", 3)`
  #' 
  if(level==3){  
    
    #' As the original files are no longer available,  
    #' - \href{`r repo("covid19datahub.io")`}{COVID-19 Data Hub} 
    #' now provides historical data, which was previously sourced from:
    #' 
    #' - \href{`r repo("gv.at")`}{Federal Ministry of Social Affairs, Health, Care and Consumer Protection, Austria}:
    #' confirmed cases,
    #' deaths,
    #' recovered.
    #'
    x <- covid19datahub.io(iso = "AUT", level)
  }
  
  return(x)
}
