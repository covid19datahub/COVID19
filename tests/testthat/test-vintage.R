test_that("vintage", {

  eq  <- 0.98
  end <- Sys.Date()-3
  
  t <- NULL
  for(level in 1:3) for(raw in c(TRUE, FALSE)){
  
    x <- covid19(level = level, end = end, raw = raw)
    y <- covid19(level = level, end = end, raw = raw, vintage = TRUE)
    
    x$group <- sapply(strsplit(x$id, ", "), function(x) x[[1]])
    
    l <- x %>% 
      
      dplyr::group_by(group) %>%
      
      dplyr::group_map(keep = TRUE, function(x, id){
        
        t <- test(x, y)
        print(sprintf("%s: %s", id[[1]], t))
        
        if(t<eq) 
          warning(sprintf("%s: %s (lev %s - raw %s)", id[[1]], t, level, raw))
        
        return(t)
        
      })
    
    t <- c(t, unlist(l))
  
  }
  
  expect_equal(all(t>eq), TRUE)

})
