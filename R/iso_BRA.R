#' Brazil 
#'
#' @source \url{`r repo("BRA")`}
#' 
BRA <- function(level, ...){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("BRA", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.wcota.covid19br")`}{Wesley Cota}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' tests,
    #' total vaccine doses administered.
    #'
    x1 <- github.wcota.covid19br(level = level)
    
    #' - \href{`r repo("who.int")`}{World Health Organization}:
    #' confirmed cases,
    #' deaths.
    #'
    x2 <- who.int(level, id = "BR")
    x2 <- x2[x2$date > "2023-03-31",]
    
    # merge
    x <- bind_rows(x1, x2)
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("BRA", 2)`
  #' 
  if(level==2){
    
    #' - \href{`r repo("github.wcota.covid19br")`}{Wesley Cota}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' tests,
    #' total vaccine doses administered.
    #'
    x <- github.wcota.covid19br(level = level)
    x$id <- id(x$state, iso = "BRA", ds = "github.wcota.covid19br", level = level)
    
  }
  
  #' @concept Level 3
  #' @section Data Sources:
  #' 
  #' ## Level 3
  #' `r docstring("BRA", 3)`
  #' 
  if(level==3){  

    #' - \href{`r repo("github.wcota.covid19br")`}{Wesley Cota}:
    #' confirmed cases,
    #' deaths.
    #'
    x <- github.wcota.covid19br(level = level)
    x$id <- id(x$code, iso = "BRA", ds = "github.wcota.covid19br", level = level)
    
    #' - \href{`r repo("github.wcota.covid19br.vac")`}{Wesley Cota}:
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    v <- github.wcota.covid19br.vac(level = level)
    v$id <- id(v$code, iso = "BRA", ds = "github.wcota.covid19br.vac", level = level)
    
    # merge
    x <- full_join(x, v, by = c("id", "date"))
    
  }
  
  return(x)
}
