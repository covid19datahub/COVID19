#' Ministry of Health and Welfare of Taiwan
#'
#' Data source for: Taiwan
#'
#' @param level 1, 2
#'
#' @section Level 1:
#' - confirmed cases
#' - tests
#'
#' @section Level 2:
#' - confirmed cases
#'
#' @source https://data.gov.tw
#'
#' @keywords internal
#'
gov.tw <- function(level) {
  if(!level %in% 1:2) return(NULL)

  # download cases
  url <- "https://od.cdc.gov.tw/eic/Day_Confirmation_Age_County_Gender_19CoV.csv"
  x   <- read.csv(url, encoding = "UTF-8")
  
  # format cases
  x <- x[,-1]
  colnames(x) <- c("date", "county", "city", "gender", "imported", "age_group", "confirmed",
                   "county_code", "city_code")
  
  # convert date
  x$date <- as.Date(x$date)

  if(level == 1) {
    
    # cases
    x <- x %>% 
      # for each date
      group_by(date) %>%
      # compute total counts
      summarise(confirmed = sum(confirmed)) %>%
      # sort by date
      arrange(date) %>%
      # cumulate
      mutate(confirmed = cumsum(confirmed))
    
  }
  
  if(level == 2) {
    
    # drop unassigned
    x <- filter(x, x$county!="空值")

    # cases
    x <- x %>% 
      # for each date and county
      group_by(date, county) %>%
      # compute total counts
      summarise(confirmed = sum(confirmed)) %>%
      # group by county
      group_by(county) %>%
      # sort by date
      arrange(date) %>%
      # cumulate
      mutate(confirmed = cumsum(confirmed))
    
  }
    
  # fix date
  x <- x[x$date<=Sys.Date(),]
  
  return(x)
}
