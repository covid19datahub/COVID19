#' Apply a function to each group
#'
#' Wrapper for \link[dplyr]{group_map} from package \code{dplyr}.
#' Can be used to iterate on grouped \code{tibbles}.
#'
#' @seealso \link[dplyr]{group_map}
#'
#' @param x a grouped \code{tibble}.
#' @param f a function to apply to each group. It should have at least 2 formal arguments: (1) the group data and (2) the group key.
#'
#' @return list of results from calling \code{f} on each group.
#'
#' @examples
#' # plot by country
#' x <- world('country')
#' f <- function(x, group) {
#'   plot(x$confirmed~x$date, main = group)
#' }
#' group_map(x, f)
#'
#' @export
#'
group_map <- function(x, f){
  dplyr::group_map(x, f)
}
