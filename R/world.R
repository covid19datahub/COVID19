#' Coronavirus COVID-19 data - Global
#'
#' Tidy format dataset of the 2019 Novel Coronavirus COVID-19 (2019-nCoV) epidemic.
#' Global data by state.
#' The data are downloaded in real-time, processed and merged with demographic indicators (\code{\link{WB}}).
#'
#' @seealso \code{\link{diamond}}, \code{\link{italy}}, \code{\link{switzerland}}, \code{\link{liechtenstein}}
#'
#' @param type one of \code{country} (data by country) or \code{state} (data by state). Default \code{state}, data by state.
#'
#' @details
#' Data pulled from the repository for the 2019 Novel Coronavirus
#' Visual Dashboard operated by the Johns Hopkins University Center for Systems
#' Science and Engineering (JHU CSSE). Also, Supported by ESRI Living Atlas Team
#' and the Johns Hopkins University Applied Physics Lab (JHU APL).
#' This \href{https://github.com/CSSEGISandData/COVID-19}{repository} and its contents herein, including all data, mapping, and analysis,
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
#' @return Return of the internal function \code{\link{covid19}}
#'
#' @examples
#' # data by country
#' x <- world("country")
#'
#' # data by state
#' x <- world("state")
#'
#' @export
#'
world <- function(type = "state"){

  # check
  if(!(type %in% c("country","state")))
    stop("type must be one of 'country', 'state'")

  # download data
  x <- jhuCSSE()

  # drop "Taiwan*" and "Holy See"
  x <- x[!(x$country %in% c("Taiwan*","Holy See")),]

  # type
  if(type=="country"){

    # bindings
    country <- date <- lat <- lng <- confirmed <- deaths <- tests <- NULL

    # aggregate
    x <- x %>%
      dplyr::group_by(country, date) %>%
      dplyr::summarize(lat = mean(lat, na.rm = TRUE),
                       lng = mean(lng, na.rm = TRUE),
                       confirmed = sum(confirmed, na.rm = TRUE),
                       deaths = sum(deaths, na.rm = TRUE),
                       tests = sum(tests, na.rm = TRUE))

  }

  # population info
  x <- merge(x, COVID19::WB, by.x = "country", by.y = "id", all.x = TRUE)

  # return
  return(covid19(x))

}
