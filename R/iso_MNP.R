#' Northern Mariana Islands
#'
#' @source \url{`r repo("MNP")`}
#' 
MNP <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("MNP", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("who.int")`}{World Health Organization}:
    #' confirmed cases,
    #' deaths.
    #'
    x1 <- who.int(level = 1, id = "MP")
    
    #' - \href{`r repo("sprep.org")`}{Secretariat of the Pacific Regional Environment Programme}:
    #' total vaccine doses administered,
    #' people vaccinated,
    #' people fully vaccinated.
    #'
    x2 <- sprep.org(id = "MP")
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' tests.
    x3 <- ourworldindata.org(id = "MNP") %>% 
      select(date, tests)
    
    # merge
    x <- full_join(x1, x2, by = "date") %>% 
      full_join(x3,  by = "date")
  }
  
  return(x)
}
