test_that("vintage", {
  
  t   <- NULL
  cn  <- vars("test")
  end <- Sys.Date()-3
  for(level in 1:3) for(raw in c(TRUE, FALSE)){
    
    x <- covid19(level = level, end = end, raw = raw, vintage = FALSE, verbose = FALSE)
    y <- covid19(level = level, end = end, raw = raw, vintage = TRUE, verbose = FALSE)
    
    l <- x %>% 
      
      dplyr::group_by(iso_alpha_3) %>%
      
      dplyr::group_map(.keep = TRUE, function(x, iso){
        
        t <- is_equal(x[,cn], y[,cn])
        
        if(class(t)=='character'){
          
          print(paste(iso[[1]], paste(t, collapse = "\n   "), sep = "\n   "))
          
          # return(FALSE)
          
        }
        
        return(TRUE)
        
      })
    
    t <- c(t, unlist(l))
    
  }
  
  expect_equal(t, rep(TRUE, length(t)))
  
})
