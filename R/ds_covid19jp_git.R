covid19jp_git <- function(level) {
  
  # Visit https://github.com/swsoyee/2019-ncov-japan/blob/master/README.en.md to know more about the data.
  
  # Read data
  repo <- "https://raw.githubusercontent.com/swsoyee/2019-ncov-japan"
  url  <- "/master/50_Data/covid19_jp.csv"
  
  x    <- read.csv(paste0(repo,url))
  
  # Minimal additional code as data already formatted as required
  x$date <- as.Date(x$date)
  
  # Filter for level
  # Note: levels 1 & 2 available only
  x <- x[x$administrative_area_level == level,]
  
  # return
  return(x)
}