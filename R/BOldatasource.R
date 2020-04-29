#Bolivia Data Source
library(tidyr)
openBOL <- function(cache, level){
  
  if(level == 1) {
    #data Source
    data<-read.csv('https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv')
    bolivia_deaths<-read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv")
    bolivia_recovered<-read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv")
    bolivia_deaths$Province.State<-NULL
    bolivia_deaths$Lat<-NULL
    bolivia_deaths$Long<-NULL
    bolivia_recovered$Province.State<-NULL
    bolivia_recovered$Lat<-NULL
    bolivia_recovered$Long<-NULL
    data$Province.State<-NULL
    data$Lat<-NULL
    data$Long<-NULL
    colnames(bolivia_recovered)[1] <- "country"
    colnames(bolivia_deaths)[1] <- "country"
    colnames(data)[1] <- "country"
    recovered2<-gather(bolivia_recovered,date,recovered,-country)
    deaths2<-gather(bolivia_deaths,date,deaths,-country)
    data2 <- gather(data,Date,Cases,-country)
    bolivia_recovered<-subset(recovered2,recovered2$country == "Bolivia")
    bolivia_death<-subset(deaths2,deaths2$country == "Bolivia")
    bolivia_data<-subset(data2,data2$country == "Bolivia")
    bolivia_recovered$date<- gsub( "X", "", as.character(bolivia_recovered$date))
    bolivia_data$Date<- gsub( "X", "", as.character(bolivia_data$Date))
    bolivia_death$date<- gsub( "X", "", as.character(bolivia_death$date))
    str(bolivia_data)
    str(bolivia_death)
    str(bolivia_recovered)
    bolivia_recovered$date<-as.Date(bolivia_recovered$date,format = "%m.%d.%Y")
    bolivia_recovered$date<-format(as.Date(bolivia_recovered$date,format = "%d/%m/%Y"))
    bolivia_data$Date <- as.Date(bolivia_data$Date , format = "%m.%d.%Y")
    bolivia_data$Date <-format(as.Date(bolivia_data$Date ), "%d/%m/%Y")
    bolivia_death$date<-as.Date(bolivia_death$date, format = "%m.%d.%Y")
    bolivia_death$date <-format(as.Date(bolivia_death$date ), "%d/%m/%Y")
    bolivia_data$country<-NULL
    bolivia_recovered$date<-NULL
    bolivia_recovered$country<-NULL
    bolivia_data <- cbind(bolivia_data,bolivia_death$deaths,bolivia_recovered)
    names(bolivia_data)[names(bolivia_data) == "bolivia_death$deaths"]<- 'deaths'
  }
  if(level > 1){
    return(NULL)
  }
  
  #return
  return(bolivia_data)
}
