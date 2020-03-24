#' Coronavirus COVID-19 Data - Global
#'
#' Download global COVID-19 data from the repository for the 2019 Novel Coronavirus
#' Visual Dashboard operated by the Johns Hopkins University Center for Systems
#' Science and Engineering (JHU CSSE). Also, Supported by ESRI Living Atlas Team
#' and the Johns Hopkins University Applied Physics Lab (JHU APL).
#'
#' @param date date object or string in the format \code{"YYYY-MM-DD"}. If provided, intraday data are downloaded for the given date. Default \code{NULL}.
#'
#' @details
#' This \href{https://github.com/CSSEGISandData/COVID-19}{GitHub repo} and its contents herein, including all data, mapping, and analysis,
#' copyright 2020 Johns Hopkins University, all rights reserved, is provided to the
#' public strictly for educational and academic research purposes.
#' The Website relies upon publicly available data from multiple sources,
#' that do not always agree. The Johns Hopkins University hereby disclaims any and
#' all representations and warranties with respect to the Website, including accuracy,
#' fitness for use, and merchantability. Reliance on the Website for medical guidance or
#' use of the Website in commerce is strictly prohibited. Data Sources:
#' \itemize{
#'  \item World Health Organization (WHO): \url{https://www.who.int/}
#'  \item DXY.cn. Pneumonia. 2020. \url{http://3g.dxy.cn/newh5/view/pneumonia}
#'  \item BNO News: \url{https://bnonews.com/index.php/2020/02/the-latest-coronavirus-cases/}
#'  \item National Health Commission of the People’s Republic of China (NHC): \url{http://www.nhc.gov.cn/xcs/yqtb/list_gzbd.shtml}
#'  \item China CDC (CCDC): \url{http://weekly.chinacdc.cn/news/TrackingtheEpidemic.htm}
#'  \item Hong Kong Department of Health: \url{https://www.chp.gov.hk/en/features/102465.html}
#'  \item Macau Government: \url{https://www.ssm.gov.mo/portal/}
#'  \item Taiwan CDC: \url{https://sites.google.com/cdc.gov.tw/2019ncov/taiwan?authuser=0}
#'  \item US CDC: \url{https://www.cdc.gov/coronavirus/2019-ncov/index.html}
#'  \item Government of Canada: \url{https://www.canada.ca/en/public-health/services/diseases/coronavirus.html}
#'  \item Australia Government Department of Health: \url{https://www.health.gov.au/news/coronavirus-update-at-a-glance}
#'  \item European Centre for Disease Prevention and Control (ECDC): \url{https://www.ecdc.europa.eu/en/geographical-distribution-2019-ncov-cases}
#'  \item Ministry of Health Singapore (MOH): \url{https://www.moh.gov.sg/covid-19}
#'  \item Italy Ministry of Health: \url{http://www.salute.gov.it/nuovocoronavirus}
#' }
#'
#' @source \url{https://github.com/CSSEGISandData/COVID-19}
#'
#' @return data.frame
#' \describe{
#'  \item{Province.State}{province name; US/Canada/Australia/ - city name, state/province name; Others - name of the event (e.g., "Diamond Princess" cruise ship); other countries - blank.}
#'  \item{Country.Region}{country/region name conforming to WHO.}
#'  \item{Lat}{latitude}
#'  \item{Long}{longitude}
#'  \item{Date}{date}
#'  \item{Confirmed}{the number of confirmed cases. For Hubei Province: from Feb 13 (GMT +8), we report both clinically diagnosed and lab-confirmed cases. For lab-confirmed cases only (Before Feb 17), please refer to \href{https://github.com/CSSEGISandData/COVID-19/tree/master/who_covid_19_situation_reports}{who_covid_19_situation_reports}. For Italy, diagnosis standard might be changed since Feb 27 to "slow the growth of new case numbers." (\href{https://apnews.com/6c7e40fbec09858a3b4dbd65fe0f14f5}{Source})}
#'  \item{Deaths}{the number of deaths.}
#'  \item{Recovered}{the number of recovered cases.}
#' }
#'
#' @examples
#' \dontrun{
#'
#' # download historical data
#' x <- world()
#'
#' # download intraday data
#' x <- world(Sys.Date()-2)
#'
#' }
#'
#' @importFrom utils read.csv
#'
#' @export
#'
world <- function(date = NULL){

  repo <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/"

  if(!is.null(date)){

    url <- sprintf("%s/csse_covid_19_daily_reports/%s.csv", repo, format(as.Date(date), "%m-%d-%Y"))

    data             <- read.csv(url)
    data$Last.Update <- as.POSIXct(data$Last.Update, format = "%Y-%m-%dT%H:%M:%S", tz = 'GMT')

    cn <- colnames(data)
    colnames(data)[cn=="Last.Update"] <- "Date"
    colnames(data)[cn=="Latitude"]    <- "Lat"
    colnames(data)[cn=="Longitude"]   <- "Long"

    data <- data[,c("Province.State", "Country.Region", "Lat", "Long", "Date", "Confirmed", "Deaths", "Recovered")]

  } else {

    files = c(
      "Confirmed"        = "time_series_19-covid-Confirmed.csv",
      "Deaths"           = "time_series_19-covid-Deaths.csv",
      "Recovered"        = "time_series_19-covid-Recovered.csv",
      "Confirmed.global" = "time_series_covid19_confirmed_global.csv",
      "Deaths.global"    = "time_series_covid19_deaths_global.csv"
    )

    data <- NULL
    for(i in 1:length(files)){

      url    <- sprintf("%s/csse_covid_19_time_series/%s", repo, files[i])
      x      <- read.csv(url)
      x      <- reshape2::melt(x, id = c("Province.State", "Country.Region", "Lat", "Long"), value.name = names(files[i]), variable.name = "Date")
      x$Date <- as.Date(x$Date, format = "X%m.%d.%y")

      if(!is.null(data))
        data <- merge(data, x, all = TRUE, by = c("Province.State", "Country.Region", "Lat", "Long", "Date"))
      else
        data <- x

    }

  }

  return(data)

}
