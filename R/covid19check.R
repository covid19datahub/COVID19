covid19check <- function(x){

  err <- list()

  idx <- which(x$deaths > x$confirmed & x$confirmed != 0) 
  if(length(idx))
    err$`DEATHS > CONFIRMED` <- x[idx,]
  
  
  idx <- which(x$confirmed > x$tests & x$tests != 0) 
  if(length(idx))
    err$`CONFIRMED > TESTS` <- x[idx,]
    
  
  idx <- which(x$recovered > x$confirmed & x$confirmed != 0) 
  if(length(idx))
    err$`RECOVERED > CONFIRMED` <- x[idx,]
  
  idx <- which(x$hosp > x$confirmed & x$confirmed != 0) 
  if(length(idx))
    err$`HOSP > CONFIRMED` <- x[idx,]

  idx <- which(x$icu > x$hosp & x$hosp != 0) 
  if(length(idx))
    err$`ICU > HOSP` <- x[idx,]

  idx <- which(x$vent > x$confirmed & x$confirmed != 0) 
  if(length(idx))
    err$`VENT > CONFIRMED` <- x[idx,]
  
  idx <- which(x$pop_female>1) 
  if(length(idx))
    err$`POP FEMALE NOT IN %` <- x[idx,]
  
  idx <- which(abs(x$pop_14+x$pop_15_64+x$pop_65-1)>1E-6) 
  if(length(idx))
    err$`POP 14 + 15_64 + 65 MUST SUM UP TO 1` <- x[idx,]
  
  idx <- which(x$pop_death_rate>1) 
  if(length(idx))
    err$`POP DEATH RATE NOT IN %` <- x[idx,]
  
  idx <- which(x$hosp_beds>100) 
  if(length(idx))
    err$`HOSP BEDS ARE PER 1,000 PEOPLE` <- x[idx,]
   
  idx <- which(x$smoking_male>1) 
  if(length(idx))
    err$`SMOKING MALE NOT IN %` <- x[idx,]
    
  idx <- which(x$smoking_female>1) 
  if(length(idx))
    err$`SMOKING FEMALE NOT IN %` <- x[idx,]
    
  idx <- which(x$health_exp>1) 
  if(length(idx))
    err$`HEATH EXP NOT IN %` <- x[idx,]
  
  idx <- which(x$health_exp_oop>1) 
  if(length(idx))
    err$`HEALTH EXP OOP NOT IN %` <- x[idx,]
  
  y <- x %>%
    dplyr::arrange_at('date') %>%
    dplyr::group_by_at('id') %>%
    dplyr::summarise(
      'deaths'    = any(diff(deaths)<0, na.rm = TRUE),
      'confirmed' = any(diff(confirmed)<0, na.rm = TRUE),
      'tests'     = any(diff(tests)<0, na.rm = TRUE),
      'recovered' = any(diff(recovered)<0, na.rm = TRUE)
    )
  
  idx <- which(y$deaths) 
  if(length(idx))
    err$`DECREASING CUMULATIVE DEATHS` <- y$id[idx]

  idx <- which(y$confirmed) 
  if(length(idx))
    err$`DECREASING CUMULATIVE CONFIRMED` <- y$id[idx]

  idx <- which(y$tests) 
  if(length(idx))
    err$`DECREASING CUMULATIVE TESTS` <- y$id[idx]

  idx <- which(y$recovered) 
  if(length(idx))
    err$`DECREASING CUMULATIVE RECOVERED` <- y$id[idx]
 
  if(length(err)){
    for(i in 1:length(err)){
      cat(sprintf("========== %s ==========\n", names(err)[i]))
      print(err[[i]])
    }
  }
   
  return(err)
  
}

