BES <- function(level, ...){
  if(level>1) return(NULL)
  
  x <- github.cssegisanddata.covid19(file = "global", cache = TRUE, level = 2, state = "Bonaire, Sint Eustatius and Saba")
  
  return(x)
  
}
