#' Johns Hopkins Center for Systems Science and Engineering
#'
#' Data source for: Worldwide
#'
#' @param level 1, 2, 3
#' @param iso the 2-letter (level=1) or 3-letter (level>1) ISO code of the country
#'
#' @section Level 1:
#' - confirmed cases
#' - deaths
#' - recovered
#' - tests
#' - hospitalizations
#' - intensive care
#' - patients requiring ventilation
#'
#' @section Level 2:
#' - confirmed cases
#' - deaths
#' - recovered
#' - tests
#' - hospitalizations
#' - intensive care
#' - patients requiring ventilation
#' 
#' @section Level 3:
#' - confirmed cases
#' - deaths
#' - recovered
#' - tests
#' - hospitalizations
#' - intensive care
#' - patients requiring ventilation
#'
#' @source https://github.com/CSSEGISandData/COVID-19_Unified-Dataset
#'
#' @keywords internal
#'
github.cssegisanddata.covid19unified <- function(level, iso){
  if(!level %in% 1:3) return(NULL)
  
  # generate JHU id
  if(level==1){
    e <- data.frame(key_jhu_csse = iso)
  }
  # retrieve JHU ids
  else{
    e <- extdata(sprintf("db/%s.csv", iso))
    e <- e[e$administrative_area_level==level,]
  }
  
  # download
  url <- "https://github.com/CSSEGISandData/COVID-19_Unified-Dataset/blob/master/COVID-19.rds?raw=true"
  file <- tempfile()
  download.file(url, file, mode = "wb", quiet = TRUE)
  x <- readRDS(file)

  # filter
  x <- x[which((x$ID %in% e$key_jhu_csse) & x$Age=="Total" & x$Sex=="Total" & x$Cases>0),]
  
  # select data source with best data coverage
  s <- names(which.max(table(x$Source)))
  x <- x[x$Source==s,]
  
  # pivot
  x <- tidyr::pivot_wider(x, id_cols = c("ID", "Date"), names_from = "Type", values_from = "Cases")
  
  # map values
  x <- map_data(x, c(
    "ID"               = "id",
    "Date"             = "date",
    "Tests"            = "tests",
    "Recovered"        = "recovered",
    "Confirmed"        = "confirmed",
    "Deaths"           = "deaths",
    "Hospitalized_Now" = "hosp",
    "ICU_Now"          = "icu",
    "Ventilator_Now"   = "vent"
  ))
  
  # date
  x$date <- as.Date(x$date)
  
  # map ids
  if(level==2 | level==3){
    map <- e$id
    names(map) <- e$key_jhu_csse
    x$id <- map_values(x$id, map, force = TRUE)
  }
  
  return(x)
}
