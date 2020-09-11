covid19brazil_git <- function(level, cache) {
  
  # download
  url.confirmed <- "https://raw.githubusercontent.com/elhenrico/covid19-Brazil-timeseries/master/transp-confirmed.csv"
  url.deaths    <- "https://raw.githubusercontent.com/elhenrico/covid19-Brazil-timeseries/master/transp-deaths.csv"
  x.confirmed   <- read.csv(url.confirmed, cache = cache)
  x.deaths      <- read.csv(url.deaths, cache = cache)
  
  # parse dataframes
  row1.to.colname.and.drop <- function(x) {
    x[1,1] <- "date"
    colnames(x) <- x[1,]
    x$date <- as.Date(paste(x$date,"2020",sep="/"), "%d/%m/%Y")
    return(x[-1,])
  }
  x.confirmed <- row1.to.colname.and.drop(x.confirmed)
  x.deaths    <- row1.to.colname.and.drop(x.deaths)

  # country
  if(level == 1) {
    
    # parse confirmed
    x.confirmed <- map_data(x.confirmed, c(
      "date" = "date",
      "BR"   = "confirmed"))
    
    # parse deaths
    x <- map_data(x.deaths, c(
      "date" = "date",
      "BR"   = "deaths")) %>%
    
      # join
      dplyr::full_join(x.confirmed, by = "date")
    
  }
  
  # region
  if(level == 2) {
    mapping <- c("date" = "date",
                 "(N)"  = "N", 
                 "(NE)" = "NE", 
                 "(SE)" = "SE", 
                 "(S)"  = "S", 
                 "(CO)" = "CO")
    
    # parse confirmed
    x.confirmed <- map_data(x.confirmed, mapping) %>%
      tidyr::pivot_longer(!date, names_to = "region", values_to = "confirmed")
    
    # parse deaths
    x <- map_data(x.deaths, mapping) %>%
      tidyr::pivot_longer(!date, names_to = "region", values_to = "deaths") %>%
      
      # join
      dplyr::full_join(x.confirmed, by = c("date", "region"))
  
  }
  # state
  if(level == 3) {
    
    # parse confirmed
    x.confirmed <- x.confirmed %>%
      dplyr::select(-c("BR","(N)","(NE)","(SE)","(S)","(CO)")) %>% # drop regions
      tidyr::pivot_longer(!date, names_to = "state", values_to = "confirmed")
    
    # parse deaths
    x <- x.deaths %>%
      dplyr::select(-c("BR","(N)","(NE)","(SE)","(S)","(CO)")) %>% # drop regions
      tidyr::pivot_longer(!date, names_to = "state", values_to = "deaths") %>%
      
      # join
      dplyr::full_join(x.confirmed, by = c("date","state"))
    
    x[which(x$state == "SE"),"state"] <- "SE3" # unit in level 2 and 3 has matching code
    
  }
  
  # convert to numeric
  x$confirmed <- as.numeric(x$confirmed)
  x$deaths <- as.numeric(x$deaths)
  
  # return
  return(x)
  
}