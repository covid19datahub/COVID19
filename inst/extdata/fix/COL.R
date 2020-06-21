require(COVID19)

x <- COVID19:::gov_co(T, 3)
c <- extdata("db", "COL.csv")

idx <- which(!x$city_code %in% c$id_gov_co)
miss <- x[idx,]


miss$id <- as.character(miss$city_code)
add_iso(miss, iso = "COL", level = 3, ds = "gov_co", map = c(
  "city_code" = "key_numeric",
  "city" = "administrative_area_level_3" ,
  "id"
))
