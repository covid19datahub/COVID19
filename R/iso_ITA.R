#' Italy
#'
#' @source \url{`r repo("ITA")`}
#' 
ITA <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("ITA", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.pcmdpc.covid19")`}{Ministero della Salute}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' tests,
    #' hospitalizations,
    #' intensive care.
    #'
    x1 <- github.pcmdpc.covid19(level = level)
    
    #' - \href{`r repo("github.italia.covid19opendatavaccini")`}{Commissario straordinario per l'emergenza Covid-19, Presidenza del Consiglio dei Ministri}:
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x2 <- github.italia.covid19opendatavaccini(level = level)
    
    # merge
    x <- full_join(x1, x2, by = "date")
    
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("ITA", 2)`
  #' 
  if(level==2){
    
    #' - \href{`r repo("github.pcmdpc.covid19")`}{Ministero della Salute}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' tests,
    #' hospitalizations,
    #' intensive care.
    #'
    x1 <- github.pcmdpc.covid19(level = level)
    x1$id <- id(x1$state, iso = "ITA", ds = "github.pcmdpc.covid19", level = level)
    
    #' - \href{`r repo("github.italia.covid19opendatavaccini")`}{Commissario straordinario per l'emergenza Covid-19, Presidenza del Consiglio dei Ministri}:
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x2 <- github.italia.covid19opendatavaccini(level = level)
    x2$id <- id(x2$state, iso = "ITA", ds = "github.italia.covid19opendatavaccini", level = level)
    
    # merge
    x <- merge(x1, x2, by = c("id", "date"))
    
  }
  
  #' @concept Level 3
  #' @section Data Sources:
  #' 
  #' ## Level 3
  #' `r docstring("ITA", 3)`
  #' 
  if(level==3){  
    
    #' - \href{`r repo("github.pcmdpc.covid19")`}{Ministero della Salute}:
    #' confirmed cases.
    #'
    x <- github.pcmdpc.covid19(level = level)
    x$id <- id(x$city, iso = "ITA", ds = "github.pcmdpc.covid19", level = level)
    
  }
  
  return(x)
}
