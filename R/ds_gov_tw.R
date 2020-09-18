gov_tw <- function(level, cache) {
  # author: Lim Jone Keat <jonekeat@gmail.com>
  
  # suppress warning
  warn_opt <- options(warn = -1)
  on.exit(options(warn_opt))
  
  # download
  url <- "https://od.cdc.gov.tw/eic/Day_Confirmation_Age_County_Gender_19CoV.csv"
  x   <- read.csv(url, cache = cache)
  
  # map data
  x <- map_data(x, c(
    "X.U.500B..U.6848..U.7814..U.5224..U.65E5."                 = "date",
    "X.U.7E23..U.5E02."                                         = "county", 
    "X.U.6027..U.5225."                                         = "gender",
    "X.U.662F..U.5426..U.70BA..U.5883..U.5916..U.79FB..U.5165." = "imported",
    "X.U.5E74..U.9F61..U.5C64."                                 = "age_group",
    "X.U.78BA..U.5B9A..U.75C5..U.4F8B..U.6578."                 = "confirmed" #confirmed (not cumulative)
  ))
  
  # # recode chinese character to english
  # x$gender <- ifelse(x$gender == "女", "female", "male")
  # x$imported <- x$imported == "是"
  
  # turn date into Date
  x$date <- as.Date(x$date, "%Y/%m/%d")
  
  # fill in implicit missing values
  all_dates <- seq.Date(x$date[1L], x$date[length(x$date)], by = "day")
  fill_missing <- function(x, by = "day") {
    date_to_fill <- data.frame(date = all_dates[!all_dates %in% x$date],
                               confirmed = 0)
    if (NCOL(x) > 2L) {
      for (ex_col in setdiff(colnames(x), colnames(date_to_fill))) {
        date_to_fill[[ex_col]] <- NA
      }
    }
    x <- rbind(x, date_to_fill)
    x <- x[order(x$date), ]
    rownames(x) <- NULL
    return(x)
  }
  
  xx <- unlist(tapply(x$confirmed, x$date, sum, simplify = FALSE))
  xx <- data.frame(date = as.Date(names(xx), "%Y-%m-%d"), 
                   confirmed = xx, row.names = NULL)
  xx <- fill_missing(xx)
  xx$confirmed <- cumsum(xx$confirmed)
  
  # return
  return(xx)
}
