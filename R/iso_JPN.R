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
    
    #' - \href{`r repo("github.lisphilar.covid19sir")`}{Hirokazu Takaya}:
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
    x1 <- github.lisphilar.covid19sir(level = level) %>% 
      filter(date <= "2023-05-08")
    
    #' - \href{`r repo("who.int")`}{World Health Organization}:
    #' confirmed cases,
    #' deaths.
    x2 <- who.int(level = level, id = "JP") %>% 
      filter(date > "2023-05-08")
    
    #merge 
    x <- bind_rows(x1, x2)
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("JPN", 2)`
  #' 
  if(level==2){
    
    #' - \href{`r repo("github.lisphilar.covid19sir")`}{Hirokazu Takaya}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' tests,
    #' hospitalizations,
    #' intensive care.
    #'
    x <- github.lisphilar.covid19sir(level = level)
    x$id <- id(x$prefecture, iso = "JPN", ds = "github.lisphilar.covid19sir", level = level)
    
  }
  
  return(x)
}
