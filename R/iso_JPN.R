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
    
    #' - \href{`r repo("toyokeizai.net")`}{Toyo Keizai}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' tests,
    #' hospitalizations,
    #' intensive care.
    #'
    x1 <- toyokeizai.net(level = level)
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x2 <- ourworldindata.org(id = "JPN") %>%
      select(-c("tests", "hosp", "icu"))
    
    # merge
    x <- full_join(x1, x2, by = "date")
    
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("JPN", 2)`
  #' 
  if(level==2){
    
    #' - \href{`r repo("toyokeizai.net")`}{Toyo Keizai}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' tests,
    #' hospitalizations,
    #' intensive care.
    #'
    x <- toyokeizai.net(level = level)
    x$id <- id(x$prefecture, iso = "JPN", ds = "toyokeizai.net", level = level)
    
  }
  
  return(x)
}
