gov_br <- function(cache, level){
  
  if(level!=3)
    return(NULL)
  
  # url
  url <- "https://s3-sa-east-1.amazonaws.com/ckan.saude.gov.br/PNI/vacina/2021/part-00000-090405dc-80c4-4889-84c3-a9a390d06947-c000.csv"
  
  # download
  tmp <- tempfile()
  download.file(url, tmp)
  
  # read
  colClasses <- rep("NULL", 32)
  colClasses[8] <- "character"
  colClasses[28] <- "Date"
  x <- read.csv(tmp, colClasses = colClasses)
  
  # clean 
  file.remove(tmp)
  
  # formatting
  colnames(x) <- c("city", "date")
  
  # cumulate
  x <- x %>%
    dplyr::filter(date > "2020-12-01") %>%
    dplyr::group_by(city, date) %>%
    dplyr::summarise(vaccines = dplyr::n()) %>%
    dplyr::group_by(city) %>%
    dplyr::arrange(date) %>%
    dplyr::mutate(vaccines = cumsum(vaccines))
  
  # return
  return(x)
}
