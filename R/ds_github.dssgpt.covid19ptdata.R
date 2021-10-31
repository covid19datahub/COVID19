#' Data Science for Social Good Portugal
#'
#' Data source for: Portugal
#'
#' @param level 1, 2
#'
#' @section Level 1:
#' - confirmed cases
#' - deaths
#' - recovered
#' - hospitalizations
#' - intensive care
#'
#' @section Level 2:
#' - confirmed cases
#' - deaths
#'
#' @source https://github.com/dssg-pt/covid19pt-data
#'
#' @keywords internal
#'
github.dssgpt.covid19ptdata <- function(level) {
  if(!level %in% 1:2) return(NULL)
  
  # download
  url <- "https://raw.githubusercontent.com/dssg-pt/covid19pt-data/master/data.csv"
  x   <- read.csv(url)
  
  # map data
  x <- map_data(x, c(
    "data"                    = "date",
    # country
    "confirmados"             = "confirmed",
    "confirmados_novos"       = "confirmed_daily",
    "recuperados"             = "recovered",
    "obitos"                  = "deaths",
    "internados"              = "hosp",
    "internados_uci"          = "icu",
    # confirmed by region
    "confirmados_arsnorte"    = "confirmed_PT11",
    "confirmados_arsalgarve"  = "confirmed_PT15",
    "confirmados_arscentro"   = "confirmed_PT16",
    "confirmados_arslvt"      = "confirmed_PT17",
    "confirmados_arsalentejo" = "confirmed_PT18",
    "confirmados_acores"      = "confirmed_PT20",
    "confirmados_madeira"     = "confirmed_PT30",
    # deaths by region
    "obitos_arsnorte"         = "deaths_PT11",
    "obitos_arsalgarve"       = "deaths_PT15",
    "obitos_arscentro"        = "deaths_PT16",
    "obitos_arslvt"           = "deaths_PT17",
    "obitos_arsalentejo"      = "deaths_PT18",
    "obitos_acores"           = "deaths_PT20",
    "obitos_madeira"          = "deaths_PT30"
  ))
  
  if(level == 1) {
    
    # select national data
    x <- x[,c("date","confirmed","recovered","deaths","hosp","icu")]
    
  }
  
  if(level == 2) {
    
    # region columns
    regions           <- c("PT11","PT15","PT16","PT17","PT18","PT20","PT30")
    regions.confirmed <- sapply(regions, function(r) paste("confirmed", r, sep = "_"))
    regions.deaths    <- sapply(regions, function(r) paste("deaths", r, sep = "_"))
    
    # cases
    x.cases <- x[,c("date", regions.confirmed)] %>%
      pivot_longer(!date, names_to = "region", names_prefix = "confirmed_", values_to = "confirmed")
    
    # deaths
    x.deaths <- x[,c("date", regions.deaths)] %>%
      pivot_longer(!date, names_to = "region", names_prefix = "deaths_", values_to = "deaths")
    
    # merge
    x <- full_join(x.cases, x.deaths, by = c("date", "region"))
    
  }
  
  # date
  x$date <- as.Date(x$date, "%d-%m-%Y")
  
  return(x)
}
