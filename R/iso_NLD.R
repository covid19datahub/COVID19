#' Netherlands
#'
#' @source \url{`r repo("NLD")`}
#' 
NLD <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("NLD", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("rivm.nl")`}{National Institute for Public Health and the Environment}:
    #' confirmed cases,
    #' deaths.
    #'
    x1 <- rivm.nl(level = level)
    
    #' - \href{`r repo("who.int")`}{World Health Organization}:
    #' confirmed cases.
    #' 
    x2 <- who.int(level = level, id = "NL") %>% 
      select(-deaths)
    x2 <- x2[x2$date >= "2023-04-01",]
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated,
    #' hospitalizations,
    #' intensive care.
    #'
    x3 <- ourworldindata.org(id = "NLD")
    
    # use vintage data because part of hosp, icu data disappeared from ourworldindata.org
    x4 <- covid19datahub.io(iso = "NLD", level) %>% 
      select(date, hosp, icu)
    
    # merge
    x <- bind_rows(x1, x2) %>%
      full_join(x3, by = "date") %>% 
      full_join(x4, by = "date") %>% 
      mutate(hosp = coalesce(hosp.y, hosp.x),
             icu = coalesce(icu.y, icu.x))
    
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("NLD", 2)`
  #' 
  if(level==2){
    
    #' - \href{`r repo("rivm.nl")`}{National Institute for Public Health and the Environment}:
    #' confirmed cases,
    #' deaths.
    #'
    x <- rivm.nl(level = level)
    x$id <- id(x$province, iso = "NLD", ds = "rivm.nl", level = level)
    
  }
  
  #' @concept Level 3
  #' @section Data Sources:
  #' 
  #' ## Level 3
  #' `r docstring("NLD", 3)`
  #' 
  if(level==3){  
    
    #' - \href{`r repo("rivm.nl")`}{National Institute for Public Health and the Environment}:
    #' confirmed cases,
    #' deaths.
    #'
    x <- rivm.nl(level = level)
    x$id <- id(x$municipality, iso = "NLD", ds = "rivm.nl", level = level)
    
  }
  
  return(x)
}
