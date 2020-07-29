require(COVID19)

x <- COVID19:::nytimes_git(T, 3)
c <- extdata("db", "USA.csv")

idx <- which(!x$fips %in% c$id_nytimes_git)
miss <- x[idx,]


miss$id <- miss$fips
add_iso(miss, iso = "USA", level = 3, ds = "nytimes_git", map = c(
  "fips" = "key_numeric",
  "city" = "administrative_area_level_3",
  "state" = "administrative_area_level_2",
  "id"
))
