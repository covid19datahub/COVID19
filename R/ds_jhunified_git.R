#' Johns Hopkins Center for Systems Science and Engineering
#' 
#' Imports worldwide confirmed cases, recovered, deaths, tests, and hospitalizations at various 
#' levels from the JHU CSSE Unified Dataset.
#' 
#' @source 
#' https://github.com/CSSEGISandData/COVID-19_Unified-Dataset
#' 
#' @keywords internal
#' 
jhunified_git <- function(iso, level){
  if(level>3) return(NULL)
  
  # retrieve ids
  e <- extdata(sprintf("db/%s.csv", iso))
  e <- e[e$administrative_area_level==level,]
  
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
    "ID"           = "id",
    "Date"         = "date",
    "Tests"        = "tests",
    "Recovered"    = "recovered",
    "Confirmed"    = "confirmed",
    "Deaths"       = "deaths",
    "Hospitalized" = "hosp",
    "ICU"          = "icu"
  ))
  
  # date
  x$date <- as.Date(x$date)
  
  # map ids
  map <- e$id
  names(map) <- e$key_jhu_csse
  x$id <- map_values(x$id, map, force = TRUE)
  
  # return
  return(x)

}
