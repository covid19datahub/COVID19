covid19turkey <- function(level, cache){
  read.csv("https://raw.githubusercontent.com/ozanerturk/covid19-turkey-api/master/dataset/timeline.csv")
  
  covid19turkey <- covid19turkey[ , -which(names(covid19turkey)%in%c("totalIntensiveCare", "totalIntubated"))]
  
  covid19turkey <- covid19turkey[ ,c(1 ,6 ,7 ,8 ,9 ,2 ,3 ,4 ,5 )]
return(covid19turkey)
}
