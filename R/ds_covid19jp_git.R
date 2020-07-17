covid19jp_git <- function(cache, level, id = NULL) {
  
  # Visit https://github.com/swsoyee/2019-ncov-japan/blob/master/README.en.md to know more about the data.
  
  # repo
  repo <- "https://raw.githubusercontent.com/swsoyee/2019-ncov-japan"
  url  <- "/master/50_Data/covid19_jp.csv"
  
  # download
  x <- read.csv(paste0(repo,url), cache = cache)
  
  # fix severe
  if("severe" %in% colnames(x))
    x$icu <- x$severe
  
  # Minimal additional code as data already formatted as required
  x$date <- as.Date(x$date)
  
  # Filter for level
  # Note: levels 1 & 2 available only
  x <- x[x$administrative_area_level == level,]
  if(!is.null(id))
    x <- x[which(x$administrative_area_level_2 == id),]
  else if(level==1)
    x <- x[is.na(x$administrative_area_level_2),]
    
  # return
  return(x)
  
}