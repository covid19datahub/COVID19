#' Coronavirus COVID-19 Data - Global
#'
#' Download the global COVID-19 dataset from the repository for the 2019 Novel Coronavirus
#' Visual Dashboard operated by the Johns Hopkins University Center for Systems
#' Science and Engineering (JHU CSSE). Also, Supported by ESRI Living Atlas Team
#' and the Johns Hopkins University Applied Physics Lab (JHU APL).
#'
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
#'  \item \href{https://www.who.int/}{World Health Organization (WHO)}
#'  \item \href{http://3g.dxy.cn/newh5/view/pneumonia}{DXY.cn. Pneumonia. 2020}
#'  \item \href{https://bnonews.com/index.php/2020/02/the-latest-coronavirus-cases/}{BNO News}
#'  \item \href{http://www.nhc.gov.cn/xcs/yqtb/list_gzbd.shtml}{National Health Commission of the People’s Republic of China (NHC)}
#'  \item \href{http://weekly.chinacdc.cn/news/TrackingtheEpidemic.htm}{China CDC (CCDC)}
#'  \item \href{https://www.chp.gov.hk/en/features/102465.html}{Hong Kong Department of Health}
#'  \item \href{https://www.ssm.gov.mo/portal/}{Macau Government}
#'  \item \href{https://sites.google.com/cdc.gov.tw/2019ncov/taiwan?authuser=0}{Taiwan CDC}
#'  \item \href{https://www.cdc.gov/coronavirus/2019-ncov/index.html}{US CDC}
#'  \item \href{https://www.canada.ca/en/public-health/services/diseases/coronavirus.html}{Government of Canada}
#'  \item \href{https://www.health.gov.au/news/coronavirus-update-at-a-glance}{Australia Government Department of Health}
#'  \item \href{https://www.ecdc.europa.eu/en/geographical-distribution-2019-ncov-cases}{European Centre for Disease Prevention and Control (ECDC)}
#'  \item \href{https://www.moh.gov.sg/covid-19}{Ministry of Health Singapore (MOH)}
#'  \item \href{http://www.salute.gov.it/nuovocoronavirus}{Italy Ministry of Health}
#' }
#'
#' @source \url{https://github.com/CSSEGISandData/COVID-19}
#'
#' @return data.frame
#' \describe{
#'  \item{Province_State}{province name; US/Canada/Australia/ - city name, state/province name; Others - name of the event (e.g., "Diamond Princess" cruise ship); other countries - blank.}
#'  \item{Country_Region}{country/region name conforming to WHO.}
#'  \item{Lat}{latitude}
#'  \item{Long}{longitude}
#'  \item{Date}{date}
#'  \item{Confirmed}{the number of confirmed cases.}
#'  \item{Deaths}{the number of deaths.}
#'  \item{Recovered}{the number of recovered cases.}
#' }
#'
#' @examples
#' \dontrun{
#'
#' # historical data
#' x <- world()
#'
#' # daily data
#' x <- world(Sys.Date()-2)
#'
#' }
#'
#' @importFrom utils read.csv
#'
#' @export
#'
world <- function(){

  # data source
  repo <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/"

  # clean column names
  clean_colnames <- function(x){

    colnames(x) <- gsub(pattern = ".", replacement = "_", x = colnames(x), fixed = TRUE)
    colnames(x) <- gsub(pattern = "^.\\_\\_", replacement = "", x = colnames(x), fixed = FALSE)
    colnames(x) <- gsub(pattern = "^_", replacement = "", x = colnames(x), fixed = FALSE)
    colnames(x) <- gsub(pattern = "_$", replacement = "", x = colnames(x), fixed = FALSE)

    cn <- colnames(x)
    colnames(x)[cn=="Last_Update"]              <- "date"
    colnames(x)[cn %in% c("Latitude","Lat")]    <- "lat"
    colnames(x)[cn %in% c("Longitude", "Long")] <- "lng"
    colnames(x)[cn=="Province_State"]           <- "state"
    colnames(x)[cn=="Country_Region"]           <- "country"

    return(x)

  }

  # files
  files = c(
    "confirmed" = "time_series_covid19_confirmed_global.csv",
    "deaths"    = "time_series_covid19_deaths_global.csv",
    "tests"     = "time_series_covid19_testing_global.csv"
  )

  # download data
  data <- NULL
  for(i in 1:length(files)){

    url    <- sprintf("%s/csse_covid_19_time_series/%s", repo, files[i])
    x      <- try(suppressWarnings(read.csv(url)), silent = TRUE)

    if(class(x)=="try-error")
      next

    x      <- clean_colnames(x)
    x      <- reshape2::melt(x, id = c("state", "country", "lat", "lng"), value.name = names(files[i]), variable.name = "date")
    x$date <- as.Date(x$date, format = "X%m_%d_%y")

    if(!is.null(data))
      data <- merge(data, x, all = TRUE, by = c("state", "country", "lat", "lng", "date"))
    else
      data <- x

  }

  # return
  return(clean(data))

}
