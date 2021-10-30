#' Cruise Ship Grand Princess
#'
#' @source \url{`r repo("GPC")`}
#' 
GPC <- function(level){
  x <- NULL
  
  #' @concept Level 1
  #' @section Data Sources:
  #' 
  #' ## Level 1
  #' `r docstring("GPC", 1)`
  #' 
  if(level==1){
    
    #' - \href{`r repo("github.cssegisanddata.covid19")`}{Johns Hopkins Center for Systems Science and Engineering}:
    #' confirmed cases,
    #' deaths,
    #' recovered.
    #'
    x <- COVID19:::github.cssegisanddata.covid19(country = "Grand Princess") %>%
      filter(date >= "2020-03-13" & date <= "2020-03-22")
    
  }
  
  return(x)
}
