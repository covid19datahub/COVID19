#' Puerto Rico
#'
#' @source \url{`r repo("PRI")`}
#' 
PRI <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("PRI", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.nytimes.covid19data")`}{The New York Times}:
    #' confirmed cases,
    #' deaths.
    #'
    x1 <- github.nytimes.covid19data(fips = "72", level = 2)
    x1 <- x1[x1$date <= "2023-03-24",]
    
    #' - \href{`r repo("who.int")`}{World Health Organization}:
    #' confirmed cases,
    #' deaths.
    #'
    x2 <- who.int(level = level, id = "PR")
    x2 <- x2[x2$date > "2023-03-24",]
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' tests.
    #' 
    x3 <- ourworldindata.org(id = "PRI") %>% 
      select(date, tests)
    
    # merge
    x <- bind_rows(x1, x2) %>%
      full_join(x3, by = "date")
    
  }
  
  return(x)
}
