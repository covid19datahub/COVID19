covid19 <- function(x, id = "", type = "", raw = FALSE){

  # bindings
  date <- confirmed <- tests <- deaths <- NULL

  # merge
  if(id!="")
    x <- merge(x, db(id = id, type = type), by = "id", all.x = TRUE, suffixes = c('.drop',''))

  # create columns if missing
  col <- c('id','date',vars())
  x[,col[!(col %in% colnames(x))]] <- NA

  # check
  if(any(duplicated(x[,c('id','date')])))
    stop("the pair ('id','date') must be unique")

  # subset
  x <- x[,col]

  # fill dates
  x <- fill(x)

  # clean
  x <- x %>%
    dplyr::arrange(id, date) %>%
    dplyr::group_by(id)  %>%
    tidyr::fill(vars("slow"), .direction = "downup")

  if(!raw)
    x <- x %>%
    tidyr::fill(vars("fast"), .direction = "down") %>%
    tidyr::replace_na(list(confirmed = 0,
                           tests     = 0,
                           deaths    = 0))

  x <- x %>%
    dplyr::mutate(confirmed_new = c(confirmed[1], pmax(0,diff(confirmed))),
                  tests_new     = c(tests[1],     pmax(0,diff(tests))),
                  deaths_new    = c(deaths[1],    pmax(0,diff(deaths))))

  # convert
  x$date <- as.Date(x$date)
  for(i in c('id','country','state','city'))
    x[[i]] <- as.character(x[[i]])

  # return
  return(x)

}
