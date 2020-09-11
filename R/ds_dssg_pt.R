dssg_pt <- function(level, cache) {
  # author: Martin Benes <martinbenes1996@gmail.com>
  
  # download
  url <- "https://raw.githubusercontent.com/dssg-pt/covid19pt-data/master/data.csv"
  x   <- read.csv(url, cache = cache)
  
  # map data
  x <- map_data(x, c(
    "data"                    = "date",
    # country
    "confirmados"             = "confirmed",
    "confirmados_novos"       = "confirmed_daily",
    "recuperados"             = "recovered",
    "obitos"                  = "deaths",
    "internados"              = "hospitalized",
    "internados_uci"          = "icu",
    # regions
    "confirmados_arsnorte"    = "confirmed_PT11", # confirmed
    "confirmados_arsalgarve"  = "confirmed_PT15",
    "confirmados_arscentro"   = "confirmed_PT16",
    "confirmados_arslvt"      = "confirmed_PT17",
    "confirmados_arsalentejo" = "confirmed_PT18",
    "confirmados_acores"      = "confirmed_PT20",
    "confirmados_madeira"     = "confirmed_PT30",
    "obitos_arsnorte"         = "deaths_PT11", # deaths
    "obitos_arsalgarve"       = "deaths_PT15",
    "obitos_arscentro"        = "deaths_PT16",
    "obitos_arslvt"           = "deaths_PT17",
    "obitos_arsalentejo"      = "deaths_PT18",
    "obitos_acores"           = "deaths_PT20",
    "obitos_madeira"          = "deaths_PT30",
    "recuperados_arsnorte"    = "recovered_PT11", # recovered
    "recuperados_arsalgarve"  = "recovered_PT15",
    "recuperados_arscentro"   = "recovered_PT16",
    "recuperados_arslvt"      = "recovered_PT17",
    "recuperados_arsalentejo" = "recovered_PT18",
    "recuperados_acores"      = "recovered_PT20",
    "recuperados_madeira"     = "recovered_PT30"
  ))
  
  if(level == 1) {
    xx <- x[,c("date","confirmed","recovered","deaths","hospitalized","icu")]
  }
  if(level == 2) {
    
    # region columns
    regions           <- c("PT11","PT15","PT16","PT17","PT18","PT20","PT30")
    regions.confirmed <- sapply(regions, function(r) paste("confirmed", r, sep = "_"))
    regions.deaths    <- sapply(regions, function(r) paste("deaths", r, sep = "_"))
    regions.recovered <- sapply(regions, function(r) paste("recovered", r, sep = "_"))
    
    # pivot longer
    xx <- x[,c("date",regions.confirmed)] %>%
      tidyr::pivot_longer(!date, names_to = "region", names_prefix = "confirmed_", values_to = "confirmed")
    xx <- x[,c("date",regions.deaths)] %>%
      tidyr::pivot_longer(!date, names_to = "region", names_prefix = "deaths_", values_to = "deaths") %>%
      dplyr::full_join(xx, by = c("date","region"))
    xx <- x[,c("date",regions.recovered)] %>%
      tidyr::pivot_longer(!date, names_to = "region", names_prefix = "recovered_", values_to = "recovered") %>%
      dplyr::full_join(xx, by = c("date","region"))
  }
  
  # date
  xx$date <- as.Date(xx$date, "%d-%m-%Y")
  
  # return
  return(xx)
  
}