require(COVID19)

fileName <- 'pkgdown/iso.Rmd'
template <- readr::read_file(fileName)

x <- covid19(vintage = TRUE) %>% 
  distinct(iso_alpha_3, administrative_area_level_1, .keep_all = TRUE)

invisible(apply(x, 1, function(x){
  
  iso     <- x[['iso_alpha_3']]
  iso2    <- x[['iso_alpha_2']]
  country <- x[['administrative_area_level_1']]
  
  flag <- ""
  if(!is.na(iso2))
    flag <- sprintf('<img src="https://www.countryflags.io/%s/flat/64.png" align="right">', iso2)
  
  rmd <- template
  rmd <- gsub("{ISO}", iso, rmd, fixed = TRUE)  
  rmd <- gsub("{country}", country, rmd, fixed = TRUE)  
  rmd <- gsub("{flag}", flag, rmd, fixed = TRUE)  
  
  readr::write_file(rmd, sprintf("vignettes/iso/%s.Rmd", iso))
  
}))
