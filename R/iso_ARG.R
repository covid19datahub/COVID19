#' Argentina
#'
#' @source \url{`r repo("ARG")`}
#' 
ARG <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("ARG", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' confirmed cases,
    #' deaths,
    #' recovered.
    #'
    x1 <- github.cssegisanddata.covid19(country = "Argentina")
    x1 <- x1[x1$date <= "2023-03-10",]

    #' - \href{`r repo("who.int")`}{World Health Organization}:
    #' confirmed cases,
    #' deaths.
    #'
    x2 <- who.int(level = 1, id = "AR")
    x2 <- x2[x2$date > "2023-03-10",]

    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' tests,
    #' intensive care.
    #'
    x3 <- ourworldindata.org(id = "ARG") %>% 
      select(c("date", "tests", "icu"))
    
    #' - \href{`r repo("gob.ar")`}{Argentine Ministry of Health}:
    #' - total vaccine doses administered
    #' - people with at least one vaccine dose
    #' - people fully vaccinated
    #' 
    x4 <- gob.ar(level = level) %>% 
      select(c("date", "vaccines", "people_vaccinated", "people_fully_vaccinated"))
    
    # merge
    x <- bind_rows(x1, x2) %>%
      full_join(x3, by = "date") %>% 
      full_join(x4, by = "date")
    
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("ARG", 2)`
  #' 
  if(level==2){
   
    #' - \href{`r repo("gob.ar")`}{Argentine Ministry of Health}:
    #' confirmed cases,
    #' deaths,
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x <- gob.ar(level = level)
    x$id <- id(x$prov, iso = "ARG", ds = "gob.ar", level = level)
    
  }
  
  #' @concept Level 3
  #' @section Data Sources:
  #' 
  #' ## Level 3
  #' `r docstring("ARG", 3)`
  #' 
  if(level==3){
    
    #' - \href{`r repo("gob.ar")`}{Argentine Ministry of Health}:
    #' confirmed cases,
    #' deaths,
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x <- gob.ar(level = level)
    x$id <- id(x$dep, iso = "ARG", ds = "gob.ar", level = level)
    
  }
  
  return(x)
}
