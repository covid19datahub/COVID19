#' Afghanistan
#'
#' @source \url{`r repo("AFG")`}
#' 
AFG <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("AFG", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' confirmed cases,
    #' deaths,
    #' recovered.
    #'
    x1 <- github.cssegisanddata.covid19(country = "Afghanistan")
    x1 <- x1[x1$date <= "2023-03-10",]
    
    #' - \href{`r repo("who.int")`}{World Health Organization}:
    #' confirmed cases,
    #' deaths.
    #'
    x2 <- who.int(level, id = "AF")
    x2 <- x2[x2$date > "2023-03-10",]
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x3 <- ourworldindata.org(id = "AFG")
    
    # merge
    x <- bind_rows(x1, x2) %>%
      full_join(x3, by = "date")
    
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("AFG", 2)`
  #' 
  if(level==2){
    
    #' - \href{`r repo("humdata.af")`}{Afghanistan Ministry of Health}:
    #' confirmed cases,
    #' deaths,
    #' recovered,
    #' tests.
    #'
    x <- humdata.af(level = level)
    x$id <- id(x$state, iso = "AFG", ds = "humdata.af", level = level)
    
  }
  
  return(x)
}
