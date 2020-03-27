#' Coronavirus COVID-19 data - Switzerland
#'
#' Tidy format dataset of the 2019 Novel Coronavirus COVID-19 (2019-nCoV) epidemic.
#' Swiss data by country or state (cantons).
#' The data are downloaded in real-time, processed and merged with demographic indicators (\code{\link{CH}}).
#'
#' @seealso \code{\link{world}}, \code{\link{diamond}}, \code{\link{italy}}
#'
#' @param type one of \code{country} (data by country) or \code{state} (data by canton). Default \code{state}, data by canton.
#'
#' @details
#' Data pulled from the \href{https://github.com/daenuprobst/covid19-cases-switzerland}{repository}
#' collecting the data published on the cantonal websites.
#'
#' @return Tidy format \code{tibble} (\code{data.frame}) grouped by id:
#' \describe{
#'  \item{id}{id in the form "country|state|city".}
#'  \item{date}{date.}
#'  \item{country}{administrative area level 1.}
#'  \item{state}{administrative area level 2.}
#'  \item{city}{administrative area level 3.}
#'  \item{lat}{latitude.}
#'  \item{lng}{longitude.}
#'  \item{deaths}{the number of deaths.}
#'  \item{confirmed}{the number of cases.}
#'  \item{tests}{the number of tests.}
#'  \item{deaths_new}{daily increase in the number of deaths.}
#'  \item{confirmed_new}{daily increase in the number of cases.}
#'  \item{tests_new}{daily increase in the number of tests.}
#'  \item{pop}{total population.}
#'  \item{pop_14}{population ages 0-19 (\% of total population).}
#'  \item{pop_15_64}{population ages 20-64 (\% of total population).}
#'  \item{pop_65}{population ages 65+ (\% of total population).}
#'  \item{pop_age}{median age of population.}
#'  \item{pop_density}{population density per km2.}
#'  \item{pop_death_rate}{population mortality rate.}
#' }
#'
#' @examples
#' # data by country
#' x <- switzerland("country")
#'
#' # data by canton
#' x <- switzerland("state")
#'
#' @export
#'
switzerland <- function(type = "state"){

  # check
  if(!(type %in% c("country","state")))
    stop("type must be one of 'country', 'state'")

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
    x      <- try(suppressWarnings(utils::read.csv(url)), silent = TRUE)

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
  data$country <- factor("Switzerland")

  # filter
  if(type=="country")
    data <- data[data$code=="CH",]
  else if(type=="state"){
    data <- data[data$code!="CH",]
  }

  # population info
  data <- merge(data, COVID19::CH, by.x = "code", by.y = "id", all.x = TRUE)

  # return
  return(clean(data))

}
