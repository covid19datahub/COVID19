#' Demographic indicators - Global
#'
#' Tidy format dataset of global demographic indicators from the
#' \href{https://data.worldbank.org}{World Bank Open Data} and the
#' \href{https://www.cia.gov/library/publications/resources/the-world-factbook/fields/343rank.html}{World Factbook by CIA}.
#'
#' @format \code{data.frame}
#'
#' @source \url{https://data.worldbank.org}, \url{https://www.cia.gov}
#'
#' @seealso \code{\link{IT}}, \code{\link{CH}}
#'
"WB"


#' Demographic indicators - Switzerland
#'
#' Tidy format dataset of Swiss demographic indicators from the
#' \href{https://www.bfs.admin.ch/bfs/en/home/statistics/regional-statistics/regional-portraits-key-figures/cantons/data-explanations.html}{Swiss Federal Statistical Office}.
#'
#' @details The columns \code{pop_14}, \code{pop_15_64} and \code{pop_65} correspond to the fraction of people
#' under age 19, between 20 and 64, or over 65. The labels \code{pop_14}, \code{pop_15_64} and \code{pop_65} are kept
#' for compatibility with the datasets \code{\link{WB}}, \code{\link{IT}}.
#'
#' @format \code{data.frame}
#'
#' @source \url{https://www.bfs.admin.ch}
#'
#' @seealso \code{\link{WB}}, \code{\link{IT}}
#'
"CH"


#' Demographic indicators - Italy
#'
#' Tidy format dataset of Italian demographic indicators from
#' \href{https://www.istat.it/en/population-and-households?data-and-indicators}{Istituto Nazionale di Statistica}.
#'
#' @format \code{data.frame}
#'
#' @source \url{https://www.istat.it}
#'
#' @seealso \code{\link{WB}}, \code{\link{CH}}
#'
"IT"
