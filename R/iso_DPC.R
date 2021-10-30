#' Cruise Ship Diamond Princess
#'
#' @source \url{`r repo("DPC")`}
#' 
DPC <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("DPC", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' confirmed cases,
    #' deaths,
    #' recovered.
    #'
    x1 <- github.cssegisanddata.covid19(country = "Diamond Princess") %>%
      filter(date >= "2020-02-01" & date <= "2020-12-03")
    
    #' - \href{`r repo("wikipedia.dp")`}{Wikipedia}:
    #' confirmed cases,
    #' tests.
    #'
    x2 <- wikipedia.dp(level = level)
    
    # use x2 (Wikipedia data) to overwrite x1 (JHU)
    x <- bind_rows(x1, x2) %>%
      # for each date
      group_by(date) %>%
      # take last non-NA element
      summarise_all(function(x) last(na.omit(x)))

  }
  
  return(x)
}
