openBOL <- function(cache, level){
  
  if(level == 1) {
    library(tidyr)
    #data Source
    data<-read.csv('https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv')
    bolivia_deaths<-read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv")
    
    #Formatting
    
    bolivia_deaths$Province.State<-NULL
    bolivia_deaths$Lat<-NULL
    bolivia_deaths$Long<-NULL
    data$Province.State<-NULL
    data1<-data.frame(data$Lat,data$Long)
    data$Lat<-NULL
    data$Long<-NULL
    colnames(bolivia_deaths)[1] <- "country"
    colnames(data)[1] <- "country"
    deaths2<-gather(bolivia_deaths,date,deaths,-country)
    data2 <- gather(data,Date,Cases,-country)
    data2 <- cbind(data2,data1)
    data2<-data.frame(data2)
    bolivia_death<-subset(deaths2,deaths2$country == "Bolivia")
    bolivia_data<-subset(data2,data2$country == "Bolivia")
    bolivia_data$Date<- gsub( "X", "", as.character(bolivia_data$Date))
    bolivia_death$date<- gsub( "X", "", as.character(bolivia_death$date))
    str(bolivia_data)
    str(bolivia_death)
    bolivia_data$Date <- as.Date(bolivia_data$Date , format = "%m.%d.%Y")
    bolivia_data$Date <-format(as.Date(bolivia_data$Date ), "%d/%m/%Y")
    bolivia_death$date<-as.Date(bolivia_death$date, format = "%m.%d.%Y")
    bolivia_death$date <-format(as.Date(bolivia_death$date ), "%d/%m/%Y")
    
    
    bolivia_population<-10027254 #2012-Census Data
    bolivia_density<-9.1
    bolivia_deathrate<-0.006793 #source- United Nations World Population Prospects-https://www.macrotrends.net/countries/BOL/bolivia/death-rate
    bolivia_median_age<-25.6 #Source-https://www.worldometers.info/world-population/bolivia-population/
    bolivia_0_14<-0.31074 #source-https://data.worldbank.org/indicator/SP.POP.0014.TO.ZS?locations=BO
    bolivia_15_64<-0.61735 #source-https://data.worldbank.org/indicator/SP.POP.1564.TO.ZS?locations=BO&view=chart
    bolivia_65<-0.07192 #source-https://data.worldbank.org/indicator/SP.POP.65UP.TO.ZS?locations=BO&view=chart
    
    bolivia_data <- cbind(bolivia_data,bolivia_death$deaths)
    bolivia_data$pop<-rep(bolivia_population,nrow(bolivia_data))
    bolivia_data$pop_density<-rep(bolivia_density,nrow(bolivia_data))
    bolivia_data$pop_death_rate<-rep(bolivia_deathrate,nrow(bolivia_data))
    bolivia_data$pop_age<-rep(bolivia_median_age,nrow(bolivia_data))
    bolivia_data$pop_14<-rep(bolivia_0_14,nrow(bolivia_data))
    bolivia_data$pop_15_64<-rep(bolivia_15_64,nrow(bolivia_data))
    bolivia_data$pop_65<-rep(bolivia_65,nrow(bolivia_data))
  }
  if(level > 1){
    return(NULL)
  }
  
  #return
  return(bolivia_data)
}
  
  
  
  
  
  

