world <- function(level, cache){

  # fallback
  if(level>2)
    return(NULL)

  # download
  x <- jhucsse_git(file = "global", cache = cache, level = level)
  
  # iso
  x$iso_alpha_3 <- id(x$country, iso = "ISO", ds = "jhucsse_git", level = 1)

  # level
  if(level==1){
    
    # id
    x$id <- x$iso_alpha_3
    
    # tests
    o <- ourworldindata_org(cache = cache)  
    x <- merge(x, o, by = c('date','iso_alpha_3'), all.x = TRUE)
    
  }
  if(level==2){
    
    # id
    x <- x %>% 
      
      dplyr::group_by_at('iso_alpha_3') %>%
      
      dplyr::group_map(.keep = TRUE, function(x, iso){
        
        x$id <- id(x$state, iso = iso[[1]], ds = "jhucsse_git", level = level)
        
        return(x)
        
      }) %>%
      
      dplyr::bind_rows()
  
  }

  # return
  return(x)

}
