ITA <- function(level, ...){
  if(level>3) return(NULL)

  if(level==1){

    # confirmed cases, deaths, recovered, tests, hospitalizations
    x <- pcmdpc_git(level = level)
    
    # vaccines  
    y <- covid19vaccini_git(level = level)
    
    # merge
    x <- merge(x, y, by = "date", all = TRUE)
    
  }
  
  if(level==2){
    
    # confirmed cases, deaths, recovered, tests, hospitalizations
    x <- pcmdpc_git(level = level)
    x$id <- id(x$state, iso = "ITA", ds = "pcmdpc_git", level = level)
    
    # vaccines  
    y <- covid19vaccini_git(level = level)
    y$id <- id(y$state, iso = "ITA", ds = "covid19vaccini_git", level = level)
    
    # merge
    x <- merge(x, y, by = c("id", "date"), all = TRUE)
    
  }
  if(level==3){
    
    # confirmed cases
    x <- pcmdpc_git(level = level)
    x$id <- id(x$city, iso = "ITA", ds = "pcmdpc_git", level = level)
    
    # Remove this until the issue if fixed:
    # https://github.com/CEEDS-DEMM/COVID-Pro-Dataset/issues/6
    #
    # # deaths
    # y <- ceeds_git(level = level) 
    # y$id <- id(y$city_code, iso = "ITA", ds = "ceeds_git", level = level)
    # 
    # # merge
    # x <- merge(x, y, by = c("id", "date"), all = TRUE)
    
  }
  
  return(x)

}
