url.administrative <- 'https://www.datos.gov.co/resource/gdxc-w37w.csv?$limit=2000'
administrative <- read.csv(url.administrative, encoding="UTF-8", cache = cache)
cities <- administrative %>%
  dplyr::select(id = cod_mpio, city = nom_mpio)
states <- administrative %>%
  dplyr::group_by(cod_depto, dpto) %>%
  dplyr::summarise() %>%
  dplyr::ungroup() %>%
  dplyr::select(id = cod_depto, state = dpto)

x <- merge(states, cities, by="id", all=T)
x$pop_death_rate <- x$pop_density <- x$pop_age <- x$pop_65 <- x$pop_15_64 <- x$pop_14 <- x$pop <- x$lng <- x$lat <- NA

write.csv(x, file="inst/extdata/db/COL.csv",row.names = F, fileEncoding = "UTF-8", na="")
