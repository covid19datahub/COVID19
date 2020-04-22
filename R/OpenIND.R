
OpenIND <- function(cache,file){
  
  # reading source data
  ts_data <- read.csv("https://api.covid19india.org/csv/latest/case_time_series.csv")
  
  #formatting
  ts_data$Date <- as.character(ts_data$Date)
  ts_data$Date <- paste(ts_data$Date,"2020")
  ts_data$Date <- lubridate::parse_date_time2(ts_data$Date, orders = "dmY")
  ts_data$Date <- as.Date(ts_data$Date)
  
  #final dataframe
  ts_data <-ts_data[,c("Date","Daily.Deceased","Daily.Confirmed","Daily.Recovered")] 
  colnames(ts_data) <- c("date","deaths","confirmed","recovered")
  
  # state data
  state_data <- read.csv("https://api.covid19india.org/csv/latest/state_wise_daily.csv")
  
  #formatting
  state_data <- reshape2::melt(state_data,id=c("Date","Status"))
  state_data <- reshape2::dcast(state_data, Date + variable ~ Status)
  state_data$date <- as.character(state_data$Date)
  state_data$date <- gsub("-"," ",state_data$date)
  state_data$date <- lubridate::parse_date_time2(state_data$date, orders = "dmy")
  state_data$date <- as.Date(state_data$date);state_data$Date <-NULL
  state_data$variable <- as.character(state_data$variable)
  state_data <- state_data[-which(state_data$variable=="TT"),]
  colnames(state_data)[which(colnames(state_data)=="variable")] <- "state"
  
  #final dataset
  ind_final <- merge(ts_data,state_data,by="date",all = T)
  ind_final$Confirmed <- ifelse(is.na(ind_final$Confirmed),ind_final$confirmed,ind_final$Confirmed)
  ind_final$Deceased <- ifelse(is.na(ind_final$Deceased),ind_final$deaths,ind_final$Deceased)
  ind_final$Recovered <- ifelse(is.na(ind_final$Recovered),ind_final$recovered,ind_final$Recovered)
  ind_final$deaths <- NULL;ind_final$recovered <- NULL;ind_final$confirmed <- NULL
  colnames(ind_final) <- c("date","state","confirmed","deaths","recovered")
  
  #return
  if(file=="nation")
    return(ts_data)
  if(file=="state")
    return(ind_final)
  else
    stop("file not supported")
}
