covid19score <- function(x, by = 'id', drop = c('id','date','country','state','city')){

  drop <- drop[!(drop %in% c(by,'confirmed'))]
  x    <- x[,!(colnames(x) %in% drop)]
  
  x <- x %>%
    
    dplyr::group_by_at(by) %>%
    
    dplyr::group_map(function(x, g){
      
      x <- x[which(x$confirmed>0),]
      c(g, colMeans(!is.na(x)))
      
    })  %>%
    
    dplyr::bind_rows()
  
  x[is.na(x)] <- 0
  
  return(x)
  
}

