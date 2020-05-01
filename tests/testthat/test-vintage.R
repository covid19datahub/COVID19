test_that("vintage", {

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
        
        if(class(t)=='character'){
          warning(paste(id[[1]], paste(t, collapse = "\n   "), sep = "\n   "))
          return(FALSE)
        }
        
        return(TRUE)
        
      })
    
    t <- c(t, unlist(l))
  
  }
  
  expect_equal(all(t), TRUE)

})
