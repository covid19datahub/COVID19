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
  
    y <- x[!duplicated(x[,c('title','url')]),]
    y <- apply(y, 1, function(y){
      
      # textVersion <- y['textVersion'] 
      # if(is.na(textVersion))
      #   textVersion <- NULL
      
      utils::bibentry(
        bibtype     = ifelse(is.na(y['bibtype']), "Misc", y['bibtype']),
        note        = y['note'],
        title       = y['title'], 
        url         = y['url'],
        year        = y['year'], 
        author      = y['author'],
        institution = y['institution'] 
        # textVersion = textVersion
      )  
      
    })
    
    cit <- utils::citation("COVID19")
    for(i in 1:length(y))
      cit <- c(y[[i]], cit)
     
    if(verbose) 
      print(cit, style = style, bibtex = bibtex)
    
    return(x)
    
}