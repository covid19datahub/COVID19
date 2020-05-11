require(COVID19dev)

fileName <- 'inst/ISO.Rmd'
template <- readChar(fileName, file.info(fileName)$size)

x <- covid19(vintage = TRUE) %>% distinct(iso_alpha_3, administrative_area_level_1)

apply(x, 1, function(x){
  
  iso     <- x[['iso_alpha_3']]
  country <- x[['administrative_area_level_1']]
  
  rmd <- template
  rmd <- gsub("{ISO}", iso, rmd, fixed = TRUE)  
  rmd <- gsub("{country}", country, rmd, fixed = TRUE)  
  
  write(rmd, file = sprintf("vignettes/iso/%s.Rmd", iso))
  
})
