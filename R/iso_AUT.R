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
    
    # use vintage data because most of the files form gv.at are not available
    x1 <- covid19datahub.io(iso = "AUT", level)
    x1 <- x1[x1$date <= "2023-04-30",]
    # fix vintage hosp by summing previous hosp (normal wards) with icu
    x1$hosp <- x1$hosp + x1$icu
    
    #' - \href{`r repo("who.int")`}{World Health Organization}:
    #' confirmed cases,
    #' deaths.
    #'
    x2 <- who.int(level, id = "AT")
    x2 <- x2[x2$date > "2023-04-30",] 
    
    # merge
    x <- bind_rows(x1, x2)
    
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("AUT", 2)`
  #' 
  if(level==2){

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
    
    # use vintage data because most of the files form gv.at are not available
    x <- covid19datahub.io(iso = "AUT", level)
    # fix vintage hosp by summing previous hosp (normal wards) with icu
    x$hosp <- x$hosp + x$icu
    
  }
  
  #' @concept Level 3
  #' @section Data Sources:
  #' 
  #' ## Level 3
  #' `r docstring("AUT", 3)`
  #' 
  if(level==3){  

    #' - \href{`r repo("gv.at")`}{Federal Ministry of Social Affairs, Health, Care and Consumer Protection, Austria}:
    #' confirmed cases,
    #' deaths,
    #' recovered.
    #'
    
    # use vintage data because most of the files form gv.at are not available 
    x <- covid19datahub.io(iso = "AUT", level)
    
  }
  
  return(x)
}
