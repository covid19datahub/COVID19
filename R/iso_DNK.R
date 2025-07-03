#' Denmark
#'
#' @source \url{`r repo("DNK")`}
#' 
DNK <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("DNK", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("ssi.dk")`}{Statens Serum Institut}:
    #' confirmed cases,
    #' deaths,
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations.
    #'
    x1 <- ssi.dk(level = level)
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' recovered.
    #'
    x2 <- github.cssegisanddata.covid19(country = "Denmark") %>%
      select(date, recovered) %>%
      filter(date <= "2023-10-24")

    #' - \href{`r repo("who.int")`}{World Health Organization}:
    #' confirmed cases,
    #' deaths.
    #' 
    x3 <- who.int(level, id = "DK")
    x3 <- x3[x3$date > "2023-10-24",]
    
    # merge
    x <- full_join(x1, x2, by = "date") %>%
      bind_rows(x3)
    
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("DNK", 2)`
  #' 
  if(level==2){
    
    #' - \href{`r repo("ssi.dk")`}{Statens Serum Institut}:
    #' confirmed cases,
    #' deaths,
    #' tests,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations.
    #'
    x <- ssi.dk(level = level)
    x$id <- id(x$region, iso = "DNK", ds = "ssi.dk", level = level)

  }
  
  #' @concept Level 3
  #' @section Data Sources:
  #' 
  #' ## Level 3
  #' `r docstring("DNK", 3)`
  #' 
  if(level==3){  
    
    #' - \href{`r repo("ssi.dk")`}{Statens Serum Institut}:
    #' confirmed cases,
    #' tests,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x <- ssi.dk(level = level)
    x$id <- id(x$code, iso = "DNK", ds = "ssi.dk", level = level)
    
  }
  
  return(x)
}
