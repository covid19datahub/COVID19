USA <- function(level, cache){

  # fallback
  if(level>3)
    return(NULL)

  # level
  if(level==1){
    
    # fallback to worldwide data
    x <- NULL
    
  }
  if(level==2){

    # tests, hospitalized and icu
    h <- healthdata_gov(level = level, cache = cache)
    h$id <- id(h$state, iso = "USA", ds = "healthdata_gov", level = level)
    
    # confirmed and deaths 
    n <- nytimes_git(cache = cache, level = level)
    n$id <- id(n$fips, iso = "USA", ds = "nytimes_git", level = level)
    
    # recovered and vent
    r <- covidtracking_com(cache = cache) 
    r$id <- id(r$state, iso = "USA", ds = "covidtracking_com", level = level)
    
    # vaccines
    v <- owidus_git(cache = cache)
    v$id <- id(v$state, iso = "USA", ds = "owidus_git", level = level)
    
    # merge
    key <- c("date", "id")
    x <- n[,c(key, "confirmed", "deaths")] %>%
      dplyr::full_join(h[,c(key, "tests", "hosp", "icu")], by = key) %>%
      dplyr::full_join(v[,c(key, "vaccines")], by = key) %>%
      dplyr::full_join(r[,c(key, "recovered", "vent")], by = key)
    
  }
  if(level==3){
    
    # JHU
    x <- jhucsse_git(file = "US", cache = cache, level = level, country = "USA")
    x$id <- id(x$id, iso = "USA", ds = "jhucsse_git", level = level)
    
    # NyTimes
    y <- nytimes_git(cache = cache, level = level)
    y$id <- id(y$fips, iso = "USA", ds = "nytimes_git", level = level)
    
    # append
    x <- x[!(x$fips %in% y$fips),]
    x <- bind_rows(x, y)
    
  }
    
  # return
  return(x)

}
