#' Public Health Agency of Sweden
#'
#' Data source for: Sweden
#'
#' @param level 1, 2
#'
#' @section Level 1:
#' - confirmed cases
#' - deaths
#'
#' @section Level 2:
#' - confirmed cases
#'
#' @source https://www.arcgis.com/home/item.html?id=b5e7488e117749c19881cce45db13f7e
#'
#' @keywords internal
#'
arcgis.se <- function(level){
  if(!level %in% 1:2) return(NULL)
  
  # excel file
  url <- "https://www.arcgis.com/sharing/rest/content/items/b5e7488e117749c19881cce45db13f7e/data"
  
  # level
  if(level==1){
    
    # cases
    x.cases <- read.excel(url, sheet = 1)
    
    # format cases
    x.cases <- map_data(x.cases, c(
      'Statistikdatum'    = 'date',
      'Totalt_antal_fall' = 'confirmed'
    ))
    
    # convert date
    x.cases$date <- as.Date(x.cases$date)
    
    # deaths
    x.deaths <- suppressWarnings(read.excel(url, sheet = 2, col_types = c("date", "numeric")))
    
    # format deaths
    x.deaths <- map_data(x.deaths, c(
      "Datum_avliden" = "date",
      "Antal_avlidna" = "deaths"
    ))
    
    # clean date
    x.deaths$date <- as.Date(x.deaths$date)
    x.deaths <- x.deaths[!is.na(x.deaths$date),]
    
    # merge
    x <- full_join(x.cases, x.deaths, by = "date")  %>% 
      # sort by date
      arrange(date) %>%
      # cumulate
      mutate(
        confirmed = cumsum(confirmed),
        deaths = cumsum(deaths))
      
  }
  if(level==2){
    
    # confirmed
    x <- read.excel(url, sheet = 1)
    
    # drop national data
    x <- x[,-2]
    
    # format date
    colnames(x)[1] <- "date"
    x$date <- as.Date(x$date)
    
    # sort by date and cumulate
    x <- x[order(x$date),]
    x[,-1] <- cumsum(x[,-1])
    
    # pivot
    x <- tidyr::pivot_longer(x, -1, names_to = "state", values_to = "confirmed")
    
  }
    
  return(x)
}
