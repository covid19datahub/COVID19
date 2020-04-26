covid19cite <- function(x, style = "citation", bibtex = FALSE, verbose = TRUE){
  
  src <- db("_src")

  x <- x %>% 
    
    dplyr::group_by(id) %>%
    
    dplyr::group_map(keep = TRUE, function(x, g){
      
      id    <- strsplit(x$id[1], ", ")[[1]]
      iso   <- id[1]
      level <- 1 + any(!is.na(x$state)) + any(!is.na(x$city))
      
      var <- apply(x, 2, function(x) !all(is.na(x) | x==0))
      var <- names(var)[var]
      
      s <- merge(src, data.frame(iso = iso, level = level, var = var))
      
      var <- var[!(var %in% s$var)]
      if(level==1 & length(var)>0)
        s <- s %>% 
          dplyr::bind_rows(merge(src, data.frame(iso = "ISO", level = 1, var = var)))
      
      return(s)
      
    }) %>%
    
    dplyr::bind_rows()
  
    x <- x[!duplicated(x),]
    y <- x[,c('title','url','year')]
    y <- y[!duplicated(y),]
    y <- apply(y, 1, function(y){
      utils::bibentry(
        bibtype ="Misc",
        title   = y['title'], 
        url     = y['url'],
        year    = y['year']
      )  
    })
    
    cit <- utils::citation("COVID19")
    for(i in 1:length(y))
      cit <- c(cit, y[[i]])
     
    if(verbose) 
      print(cit, style = style, bibtex = bibtex)
    
    return(x)
    
}