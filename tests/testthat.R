library(testthat)
library(COVID19dev)

is_equal <- function(x, y){
  
  x <- as.data.frame(x)
  y <- as.data.frame(y)
  
  rownames(x) <- paste(x$id, x$date)
  rownames(y) <- paste(y$id, y$date)
  
  rn <- intersect(rownames(x), rownames(y))
  
  x <- x[rn, , drop = FALSE]
  y <- y[rn, , drop = FALSE]
  
  if(nrow(x)==0 | nrow(y)==0)
    return(TRUE)
  
  x <- x[,colSums(x!=0, na.rm = TRUE)!=0, drop = FALSE]
  y <- y[,colSums(y!=0, na.rm = TRUE)!=0, drop = FALSE]
  
  cn <- intersect(colnames(x), colnames(y))
  
  x <- x[, cn, drop = FALSE]
  y <- y[, cn, drop = FALSE]
  
  if(nrow(x)==0 | nrow(y)==0)
    return(TRUE)
  
  return(all.equal(x,y))
  
}

test_check("COVID19dev")
