#' Turkey
#'
#' @source \url{`r repo("TUR")`}
#' 
TUR <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("TUR", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' confirmed cases,
    #' deaths,
    #' recovered.
    #'
    x1 <- github.cssegisanddata.covid19(country = "Turkey")
    x1 <- x1[x1$date <= "2023-03-10",]
    
    #' - \href{`r repo("who.int")`}{World Health Organization}:
    #' confirmed cases.
    #' 
    x2 <- who.int(level, id = "TR") %>% 
      select(-deaths)
    x2 <- x2[x2$date > "2023-03-10",]
    
    #' - \href{`r repo("github.ozanerturk.covid19turkeyapi")`}{Ozan Erturk}:
    #' intensive care,
    #' patients requiring ventilation.
    #'
    x3 <- github.ozanerturk.covid19turkeyapi(level = level) %>%
      select(-c("confirmed", "deaths", "recovered", "tests"))
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x4 <- ourworldindata.org(id = "TUR") %>%
      select(-c("icu", "hosp"))
    
    # merge
    x <-  bind_rows(x1, x2) %>%
      full_join(x3, by = "date") %>%
      full_join(x4, by = "date")
    
  }
  
  return(x)
}
