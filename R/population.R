# make sure to be using the latest version
remotes::install_github("covid19datahub/COVID19", upgrade = "never")
library(COVID19)

# load and view sources
src <- extdata("src.csv")
#View(src)

## -----------------------------------------
# define function to automate
impute_population_source <- function(x, level, iso){
  src_sub_level_n <- src_sub %>% filter(administrative_area_level == level)
  
  # Only one source for a level
  if(nrow(src_sub_level_n) == 1){
    if(is.na(src_sub_level_n$author)){
      data_source <- paste0(src_sub_level_n$title, " (", src_sub_level_n$year, ")")
    }else{
      data_source <- paste0(src_sub_level_n$author, " (", src_sub_level_n$year, ")")
    }
    
    # add population data source for level 
    idx <- which(x$administrative_area_level==level)
    x$population_data_source[idx] <- data_source
    x$population_data_source_url[idx] <- src_sub_level_n$url
  }
  
  return(x)
}

## --------------------------------------------
# load csv file
iso <- "ISO"
x <- extdata(sprintf("db/%s.csv", iso))
table(x$administrative_area_level)

# initialize data source columns
x$population_data_source <- x$population_data_source_url <- NA

# get the source name and url from the src file:
src_sub <- src %>% filter(iso_alpha_3 == iso & data_type == "population") 
table(src_sub$administrative_area_level)

if (iso %in% c("BRA", "CHN", "COL", "DNK", "GBR", "HRV", "ISO",
               "LVA", "MEX", "PAK", "RUS", "UKR")) {
  ## --------------------------------
  ## Special case
  if(iso == "BRA"){
    which(grepl("Espirito Santo", x$administrative_area_level_2))
    
    # add population data source for level 2 - Brazil
    idx <- which(x$administrative_area_level == 2 & x$administrative_area_level_2 != "Espirito Santo")
    x$population_data_source[idx] <- "Instituto Brasileiro de Geografia e Estatistica - IBGE (2020)"
    x$population_data_source_url[idx] <- "https://www.ibge.gov.br/en/cities-and-states.html"
    
    # add population data source for level 2 - Espirito Santo
    idx <- which(x$administrative_area_level == 2 & x$administrative_area_level_2 == "Espirito Santo")
    x$population_data_source[idx] <- "Wikipedia (2019)"
    x$population_data_source_url[idx] <- "https://en.wikipedia.org/wiki/Esp%C3%ADrito_Santo"
    
    # add population data source for level 3 - Brazil
    idx <- which(x$administrative_area_level == 3 & x$administrative_area_level_2 != "Espirito Santo")
    x$population_data_source[idx] <- "Wesley Cota (2020)"
    x$population_data_source_url[idx] <- "https://github.com/wcota/covid19br"
    
    # add population data source for level 3 - Espirito Santo
    idx <- which(x$administrative_area_level == 3 & x$administrative_area_level_2 == "Espirito Santo")
    x$population_data_source[idx] <- "Wikipedia (2019)"
    x$population_data_source_url[idx] <- "https://pt.wikipedia.org/wiki/Lista_de_munic%C3%ADpios_do_Esp%C3%ADrito_Santo_por_popula%C3%A7%C3%A3o"
  }
  
  ## Special case
  if(iso == "CHN"){
    # add population data source for level 2 - mainland
    idx <- which(x$administrative_area_level == 2 & (!(x$id_github.cssegisanddata.covid19 %in% c("Hong Kong", "Macau"))))
    x$population_data_source[idx] <- "National Bureau of Statistics of China NBS (2018)"
    x$population_data_source_url[idx] <- "http://data.stats.gov.cn/english/easyquery.htm?cn=E0103"
    
    # add population data source for level 2 - hong kong
    idx <- which(x$administrative_area_level == 2 & x$id_github.cssegisanddata.covid19 == "Hong Kong")
    x$population_data_source[idx] <- "CIA - Central Intelligence Agency (2020)"
    x$population_data_source_url[idx] <- "https://www.cia.gov/library/publications/the-world-factbook/geos/hk.html"
    
    # add population data source for level 2 - macau
    idx <- which(x$administrative_area_level == 2 & x$id_github.cssegisanddata.covid19 == "Macau")
    x$population_data_source[idx] <- "CIA - Central Intelligence Agency (2020)"
    x$population_data_source_url[idx] <- "https://www.cia.gov/library/publications/the-world-factbook/geos/mc.html"
  }
  
  ## Special case
  if(iso == "COL"){
    which(grepl("Buenaventura", x$administrative_area_level_3))
    
    # add population data source for level 2 - Columbia
    idx <- which(x$administrative_area_level == 2)
    x$population_data_source[idx] <- "Wikipedia (2018)"
    x$population_data_source_url[idx] <- "https://en.wikipedia.org/wiki/Departments_of_Colombia"
    
    # add population data source for level 2 (should be 3) - Valle del Cauca - Buenaventura
    idx <- which(x$administrative_area_level == 3 & x$administrative_area_level_2 == "Valle del Cauca" & x$administrative_area_level_3 == "Buenaventura")
    x$population_data_source[idx] <- "Wikipedia (2019)"
    x$population_data_source_url[idx] <- "https://en.wikipedia.org/wiki/Buenaventura,_Valle_del_Cauca"
    
    # add population data source for level 3 - Columbia # ED 12022021 per email discussion
    idx <- which(x$administrative_area_level == 3)
    x$population_data_source[idx] <- "Johns Hopkins Center for Systems Science and Engineering"
    x$population_data_source_url[idx] <- "https://github.com/CSSEGISandData/COVID-19_Unified-Dataset"
    
  }
  
  ## Special case
  if(iso == "DNK"){ # ED 12022021 per email discussion
    # add population data source for level 2 - Denmark 
    idx <- which(x$administrative_area_level == 2)
    x$population_data_source[idx] <- "Statoids (2005)"
    x$population_data_source_url[idx] <- "http://www.statoids.com/udk.html"
    
    # add population data source for level 3 - Denmark 
    idx <- which(x$administrative_area_level == 3)
    x$population_data_source[idx] <- "Statoids (2005)"
    x$population_data_source_url[idx] <- "http://www.statoids.com/ydk.html"
    
  }
  
  ## Special case
  if(iso == "GBR"){# ED 12022021 per email discussion
    # add population data source for level 2 #TODO: not specific 3 repeats
    idx <- which(x$administrative_area_level == 2)
    x$population_data_source[idx] <- "Office for National Statistics (2021)"
    x$population_data_source_url[idx] <- "https://coronavirus.data.gov.uk/details/download"
    
    # add population data source for level 3
    idx <- which(x$administrative_area_level == 3)
    x$population_data_source[idx] <- "Office for National Statistics (2021)"
    x$population_data_source_url[idx] <- "https://coronavirus.data.gov.uk/details/download"
    
  }
  
  ## Special case
  if(iso == "HRV"){ # ED 12022021 per email discussion
    # add population data source for level 2 - Croatia 
    idx <- which(x$administrative_area_level == 2)
    x$population_data_source[idx] <- "Croatian Bureau of Statistics"
    x$population_data_source_url[idx] <- "https://www.citypopulation.de/en/croatia/admin/"
    
  }
  
  ## Special case
  if(iso == "ISO"){ # ED 12022021 per email discussion
    #View(x[x$id_covid19datahub.io %in% c("CHE", "JPN", "TWN", "USA"), ])
    src_df <- src[src$iso_alpha_3 %in% c("CHE", "JPN", "TWN", "USA") & src$administrative_area_level == 1 & src$data_type == "population", ]
    #View(src_df)
    
    x[x$id_covid19datahub.io == "CHE", "population_data_source"] <- paste0(src_df[src_df$iso_alpha_3 == "CHE", "title"], " (", src_df[src_df$iso_alpha_3 == "CHE", "year"], ")")
    x[x$id_covid19datahub.io == "JPN", "population_data_source"] <- paste0(src_df[src_df$iso_alpha_3 == "JPN", "title"], " (", src_df[src_df$iso_alpha_3 == "JPN", "year"], ")")
    x[x$id_covid19datahub.io == "TWN", "population_data_source"] <- paste0(src_df[src_df$iso_alpha_3 == "TWN", "title"], " (", src_df[src_df$iso_alpha_3 == "TWN", "year"], ")")
    x[x$id_covid19datahub.io == "USA", "population_data_source"] <- paste0(src_df[src_df$iso_alpha_3 == "USA", "title"], " (", src_df[src_df$iso_alpha_3 == "USA", "year"], ")")
    
    x[x$id_covid19datahub.io == "CHE", "population_data_source_url"] <- src_df[src_df$iso_alpha_3 == "CHE", "url"]
    x[x$id_covid19datahub.io == "JPN", "population_data_source_url"] <- src_df[src_df$iso_alpha_3 == "JPN", "url"]
    x[x$id_covid19datahub.io == "TWN", "population_data_source_url"] <- src_df[src_df$iso_alpha_3 == "TWN", "url"]
    x[x$id_covid19datahub.io == "USA", "population_data_source_url"] <- src_df[src_df$iso_alpha_3 == "USA", "url"]
    
  }

  ## Special case
  if(iso == "LVA"){ # ED 12022021 per email discussion
    # add population data source for level 3 - Latvia
    idx <- which(x$administrative_area_level == 3)
    x$population_data_source[idx] <- "Oficiālās statistikas portāls (2019)"
    x$population_data_source_url[idx] <- "https://data.stat.gov.lv/pxweb/en/OSP_PUB/START__POP__IR__IRD/IRD060/"
    
  }
  
  ## Special case
  if(iso == "MEX"){ # ED 12022021 per email discussion
    # add population data source for level 2 - Mexico
    idx <- which(x$administrative_area_level == 2)
    x$population_data_source[idx] <- "Statoids (2010)"
    x$population_data_source_url[idx] <- "http://www.statoids.com/umx.html"
    
  }
  
  ## Special case
  if(iso == "PAK"){ # ED 12022021 per email discussion
    # add population data source for level 2 - Parkistan
    idx <- which(x$administrative_area_level == 2)
    x$population_data_source[idx] <- "Johns Hopkins Center for Systems Science and Engineering"
    x$population_data_source_url[idx] <- "https://github.com/CSSEGISandData/COVID-19_Unified-Dataset"
    
  }
  
  ## Special case
  if(iso == "RUS"){ # ED 12022021 per email discussion
    # add population data source for level 2 - Russia
    idx <- which(x$administrative_area_level == 2)
    x$population_data_source[idx] <- "Wikipedia (2010)"
    x$population_data_source_url[idx] <- "https://en.wikipedia.org/wiki/List_of_federal_subjects_of_Russia_by_population"
    
  }
  
  ## Special case
  if(iso == "UKR"){ # ED 12022021 per email discussion
    # add population data source for level 2 - Ukraine
    idx <- which(x$administrative_area_level == 2)
    x$population_data_source[idx] <- "Statoids (2001)"
    x$population_data_source_url[idx] <- "http://www.statoids.com/uua.html"
    
  }
  
} else {
  
  ## General case where src_sub admin level consistent with iso.csv admin level
  if (2 %in% src_sub$administrative_area_level){
    x <- impute_population_source(x, level = 2, iso)
  }
  
  if (3 %in% src_sub$administrative_area_level){
    x <- impute_population_source(x, level = 3, iso)
  }
  
}


# write to file in the current directory
data.table::fwrite(x, file = sprintf("%s.csv", iso), quote = TRUE)

# submit this file with a pull request
# https://github.com/covid19datahub/COVID19/pulls





