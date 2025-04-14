#' Peru
#'
#' @source \url{`r repo("PER")`}
#' 
PER <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("PER", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.jmcastagnetto.covid19perudata")`}{Jesus M. Castagnetto}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' tests,
    #' hospitalizations,
    #' intensive care,
    #' patients requiring ventilation.
    #'
    x1 <- github.jmcastagnetto.covid19perudata(level = level)
    
    #' - \href{`r repo("who.int")`}{World Health Organization}:
    #' confirmed cases,
    #' deaths.
    x2 <- who.int(level = 1, id = "PE")
    x2 <- x2[x2$date > "2022-04-05",]
    
    #' - \href{`r repo("gob.pe")`}{Ministerio de Salud}:
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x3 <- gob.pe(level = level)
    
    # merge
    x <- bind_rows(x1, x2) %>% 
      full_join(x3, by = "date")
    
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("PER", 2)`
  #' 
  if(level==2){
    
    #' - \href{`r repo("github.jmcastagnetto.covid19perudata")`}{Jesus M. Castagnetto}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' tests.
    #'
    x1 <- github.jmcastagnetto.covid19perudata(level = level)
    x1$id <- id(x1$region, iso = "PER", ds = "github.jmcastagnetto.covid19perudata", level = level)
    
    #' - \href{`r repo("gob.pe")`}{Ministerio de Salud}:
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x2 <- gob.pe(level = level)
    x2$id <- id(x2$department, iso = "PER", ds = "gob.pe", level = level)
    
    # merge
    x <- full_join(x1, x2, by = c("id", "date"))
    
  }
  
  return(x)
}
