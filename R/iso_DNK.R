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
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' confirmed cases,
    #' deaths,
    #' recovered.
    #'
    x1 <- github.cssegisanddata.covid19(country = "Denmark")
    x1 <- x1[x1$date <= "2023-03-10",]
    
    #' - \href{`r repo("who.int")`}{World Health Organization}:
    #' confirmed cases.
    #' deaths.
    x2 <- who.int(level = 1, id = "DK")
    x2 <- x2[x2$date > "2023-03-10",]
    
    #' Due to changes in the original file,  
    #' - \href{`r repo("covid19datahub.io")`}{COVID-19 Data Hub}  
    #' now provides historical data, which was previously sourced from:  
    #'  
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care.
    #'
    x3 <- ourworldindata.org(id = "DNK") %>% 
      select(date, tests, hosp, icu)
    
    x4 <- covid19datahub.io(iso = "DNK", level) %>% 
      select(date, vaccines, people_vaccinated, people_fully_vaccinated)
    
   
    # merge
    x <- bind_rows(x1, x2) %>%
      full_join(x3, by = "date") %>% 
      full_join(x4, by = "date")
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
