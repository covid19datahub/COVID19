oppnadata_se <- function(cache, level){
  # Author: Martin Benes

  #  Source: Public Health Agency, Sweden
  # https://oppnadata.se/datamangd/#esc_entry=1424&esc_context=525
  url <- "https://free.entryscape.com/store/360/resource/15"
  
  # number of cases, deaths, icu - whole Sweden
  x <- read.csv(url, cache = cache)
  
  # level
  if(level==1){
    
    # formatting
    x <- map_data(x, c(
      'Kumulativa_fall'       = 'confirmed',
      'Kumulativa_avlidna'    = 'deaths',
      'Antal_intensivvardade' = 'icu',
      'Statistikdatum'        = 'date'
    ))
    
  }
  if(level==2){
    
    # map_data
    x <- x[,c(28,3:23)] 
    colnames(x) <- map_values(colnames(x), c(
      'Statistikdatum' = 'date'
    ))
    
    # bindings
    date <- NULL
    
    # sort date
    x <- x %>%
      dplyr::arrange(date) 
    
    # cumulate
    x[,-1] <- cumsum(x[,-1])
    
    # formatting
    x <- tidyr::pivot_longer(x, -1, names_to = "state", values_to = "confirmed")
    
  }
    
  # TODO: other datasets available
  #   * confirmed by age: https://oppnadata.se/datamangd/#esc_entry=1425&esc_context=525
  #   * confirmed by region: https://oppnadata.se/datamangd/#esc_entry=1426&esc_context=525
  #   * confirmed by gender: https://oppnadata.se/datamangd/#esc_entry=1427&esc_context=525
  
  # date
  x$date <- as.Date(x$date, format = "%Y-%m-%d")
  x <- x[!is.na(x$date),]
  
  # return
  return(x)
}

