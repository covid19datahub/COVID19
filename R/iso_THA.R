#' Thailand
#'
#' @source \url{`r repo("THA")`}
#' 
THA <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("THA", 1)`
  #' 
  if(level==1){

    #' - \href{`r repo("who.int")`}{World Health Organization}:
    #' confirmed cases,
    #' deaths.
    #' 
    x1 <- who.int(level, id = "TH")
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' recovered.
    #'
    x2 <- github.cssegisanddata.covid19(country = "Thailand") %>%
      select(-c("confirmed", "deaths"))
    
    #' - \href{`r repo("ourworldindata.org")`}{Our World in Data}:
    #' tests,
    #' total vaccine doses administered,
    #' people with at least one vaccine dose,
    #' people fully vaccinated.
    #'
    x3 <- ourworldindata.org(id = "THA")
    
    # merge
    x <- full_join(x1, x2, by = "date") %>%
      full_join(x3, by = "date")
    
  }
  
  #' @concept Level 2
  #' @section Data Sources:
  #' 
  #' ## Level 2
  #' `r docstring("THA", 2)`
  #' 
  if(level==2){
    
    #' - \href{`r repo("go.th")`}{Department of Disease Control, Thailand Ministry of Public Health}:
    #' confirmed cases,
    #' deaths.
    #'
    x1 <- go.th(level = level) %>% 
      filter(date >= "2022-09-20") # last day of vintage data
    x1$id <- id(x1$province, iso = "THA", ds = "go.th", level = level) 
    
    # use vintage data because daily data was removed from updated go.th 
    x2 <- covid19datahub.io(iso = "THA", level) %>% 
      select(id, date, confirmed, deaths)
    
    # merge
    x <- bind_rows(x1, x2)
  }
  
  return(x)
}
