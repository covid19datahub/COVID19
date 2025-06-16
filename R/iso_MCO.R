#' Monaco
#'
#' @source \url{`r repo("MCO")`}
#' 
MCO <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("MCO", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' confirmed cases,
    #' deaths,
    #' recovered.
    #'
    x1 <- github.cssegisanddata.covid19(country = "Monaco")
    x1 <- x1[x1$date <= "2023-03-10",]
    
    #' - \href{`r repo("who.int")`}{World Health Organization}:
    #' confirmed cases.
    #' 
    x2 <- who.int(level, id = "MC") %>% 
      select(-deaths)
    x2 <- x2[x2$date > "2023-03-10",]
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x3 <- ourworldindata.org(id = "MCO")
    
    # merge
    x <- bind_rows(x1, x2) %>%
      full_join(x3, by = "date")
    
  }
  
  return(x)
}
