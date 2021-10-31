#' COVID-19 European Chinese Channel
#'
#' Data source for: Poland
#'
#' @param level 2
#'
#' @section Level 2:
#' - confirmed cases
#' - deaths
#' - tests
#'
#' @source https://github.com/covid19-eu-zh/covid19-eu-data
#'
#' @keywords internal
#'
github.covid19euzh.covid19eudata <- function(level){
  if(level!=2) return(NULL)
  
  # download
  url <- "https://raw.githubusercontent.com/covid19-eu-zh/covid19-eu-data/master/dataset/covid-19-pl.csv"
  x <- read.csv(url)

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
  
  # remove broken nuts
  x <- x[which(!is.na(x$nuts) & !startsWith(x$nuts, "https://")),]
  
  # date
  x$date <- as.Date(x$date, format = "%Y-%m-%d")

  # return
  return(x)

}
