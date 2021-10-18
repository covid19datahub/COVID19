oppnadata_se <- function(level){

  # Source: Public Health Agency, Sweden
  # https://www.arcgis.com/home/item.html?id=b5e7488e117749c19881cce45db13f7e
  url <- "https://www.arcgis.com/sharing/rest/content/items/b5e7488e117749c19881cce45db13f7e/data"
  
  # level
  if(level==1){
    
    # confirmed
    confirmed <- read.excel(url, sheet = 1)
    confirmed <- map_data(confirmed, c(
      'Statistikdatum'    = 'date',
      'Totalt_antal_fall' = 'confirmed'
    ))
    confirmed$date <- as.Date(confirmed$date)
    
    # deaths (remove counts for which the date is not available)
    deaths <- suppressWarnings(read.excel(url, sheet = 2, col_types = c("date", "numeric")))
    deaths <- map_data(deaths, c(
      "Datum_avliden" = "date",
      "Antal_avlidna" = "deaths"
    ))
    deaths$date <- as.Date(deaths$date)
    deaths <- deaths[!is.na(deaths$date),]
    
    # icu
    icu <- read.excel(url, sheet = 3)
    colnames(icu) <- c("date", "icu")
    icu$date <- as.Date(icu$date)
    
    # join and cumulate
    x <- confirmed %>% 
      dplyr::full_join(deaths, on = "date") %>%
      dplyr::full_join(icu, on = "date") %>%
      dplyr::arrange(date) %>%
      dplyr::mutate(confirmed = cumsum(confirmed, na.rm = TRUE),
                    deaths = cumsum(deaths, na.rm = TRUE))
      
  }
  if(level==2){
    
    # confirmed
    x <- read.excel(url, sheet = 1)
    
    # drop national data
    x <- x[,-2]
    
    # date
    colnames(x)[1] <- "date"
    x$date <- as.Date(x$date)
    
    # sort by date and cumulate
    x <- x[order(x$date),]
    x[,-1] <- cumsum(x[,-1])
    
    # formatting
    x <- tidyr::pivot_longer(x, -1, names_to = "state", values_to = "confirmed")
    
  }
    
  # return
  return(x)
}

