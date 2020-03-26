#'
#'
#'
#'
#' @export
#'
switzerland <- function(type = "state"){

  # data source
  repo <- "https://raw.githubusercontent.com/daenuprobst/covid19-cases-switzerland/master/"

  # files
  files = c(
    "confirmed" = "covid19_cases_switzerland.csv",
    "deaths"    = "covid19_fatalities_switzerland.csv"
  )

  # download data
  data <- NULL
  for(i in 1:length(files)){

    url    <- sprintf("%s/%s", repo, files[i])
    x      <- try(suppressWarnings(read.csv(url)), silent = TRUE)

    if(class(x)=="try-error")
      next

    colnames(x)[1] <- 'date'
    x$CH <- pmax(x$CH, rowSums(x[,-c(1,ncol(x))]))

    x      <- reshape2::melt(x, id = c("date"), value.name = names(files[i]), variable.name = "code")
    x$date <- as.Date(x$date, format = "%Y-%m-%d")

    if(!is.null(data))
      data <- merge(data, x, all = TRUE, by = c("code", "date"))
    else
      data <- x

  }

  # country
  data$country <- "Switzerland"

  # filter
  if(type=="country")
    data <- data[data$code=="CH",]
  else if(type=="state"){
    data <- data[data$code!="CH",]
    data <- merge(data, COVID19::CH)
  }
  else
    stop("type must be one of 'country', 'state'")

  # return
  return(clean(data))

}
