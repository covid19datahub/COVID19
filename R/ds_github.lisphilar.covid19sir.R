#' Hirokazu Takaya
#'
#' Data source for: Japan
#'
#' @param level 1, 2
#'
#' @section Level 1:
#' - confirmed cases
#' - deaths
#' - recovered
#' - tests
#' - total vaccine doses administered
#' - people with at least one vaccine dose
#' - people fully vaccinated
#' - hospitalizations
#' - intensive care
#'
#' @section Level 2:
#' - confirmed cases
#' - deaths
#' - recovered
#' - tests
#' - hospitalizations
#' - intensive care
#'
#' @source https://github.com/lisphilar/covid19-sir
#'
#' @keywords internal
#'
github.lisphilar.covid19sir <- function(level) {
  if(!level %in% 1:2) return(NULL)
  
  if(level==1){  
    
    url <- "https://raw.githubusercontent.com/lisphilar/covid19-sir/main/data/japan/covid_jpn_total.csv"
    x <- read.csv(url, na.strings = c("0", "NA"))
    
    x <- x[x$Location=="Domestic",]
    x <- map_data(x, c(
      "Date" = "date",
      "Positive" = "confirmed",
      "Tested" = "tests",
      "Discharged" = "recovered",
      "Hosp_require" = "hosp",
      "Hosp_severe" = "icu",
      "Fatal" = "deaths",
      "Vaccinated_1st" = "people_vaccinated",
      "Vaccinated_2nd" = "people_fully_vaccinated",
      "Vaccinated_3rd" = "vaccines_3",
      "Vaccinated_4th" = "vaccines_4",
      "Vaccinated_5th" = "vaccines_5"
    ))
    
    x$vaccines <- x$people_vaccinated + 
      tidyr::replace_na(x$people_fully_vaccinated, 0) + 
      tidyr::replace_na(x$vaccines_3, 0) + 
      tidyr::replace_na(x$vaccines_4, 0) + 
      tidyr::replace_na(x$vaccines_5, 0)
    
  }
  
  if(level==2){
    
    url <- "https://raw.githubusercontent.com/lisphilar/covid19-sir/main/data/japan/covid_jpn_prefecture.csv"
    x <- read.csv(url, na.strings = c("0", "NA"))
    
    x <- map_data(x, c(
      "Date" = "date",
      "Prefecture" = "prefecture",
      "Positive" = "confirmed",
      "Tested" = "tests",
      "Discharged" = "recovered",
      "Hosp_require" = "hosp",
      "Hosp_severe" = "icu",
      "Fatal" = "deaths"
    ))
    
  }
  
  x$date <- as.Date(x$date)
  
  return(x)
}
