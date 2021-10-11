covid19pl_git <- function(level){

  # This source is broken.
  # See https://github.com/covid19-eu-zh/covid19-eu-data/issues/64
  
  # check
  if(level!=2)
    return(NULL)
  
  # download
  x <- read.csv("https://raw.githubusercontent.com/covid19-eu-zh/covid19-eu-data/master/dataset/covid-19-pl.csv")

  # clean
  x$nuts_2 <- gsub("warmi.*sko-mazurskie", "warminsko-mazurskie", x$nuts_2)
  x$nuts_2 <- gsub("ma.*opolskie", "malopolskie", x$nuts_2)
  x$nuts_2 <- gsub("dolno.*skie", "dolnoslaskie", x$nuts_2)
  x$nuts_2 <- gsub(".*dzkie$", "lodzkie", x$nuts_2)
  x$nuts_2 <- gsub(".*tokrzyskie$", "swietokrzyskie", x$nuts_2)
  x$nuts_2 <- gsub(".*[^a-z]skie$", "slaskie", x$nuts_2)
  
  # format
  x <- map_data(x, c(
    "datetime" = "date",
    "nuts_2" = "nuts",
    "cases" = "confirmed",
    "deaths" = "deaths",
    "tests" = "tests"
  ))
  
  # date
  x$date <- as.Date(x$date, format = "%Y-%m-%d")

  # return
  return(x)

}
