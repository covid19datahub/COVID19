#' @export
diamond <- function(raw = FALSE){

  warning("This function is deprecated and will be REMOVED soon.
          Run instead -> covid19('DPC')")

  covid19("DPC", raw = raw)

}

#' @export
italy <- function(type = "state", raw = FALSE){

  warning("This function is deprecated and will be REMOVED soon.
          Run instead -> covid19('ITA')")

  level <- c("country" = 1, "state" = 2, "city" = 3)

  covid19("ITA", level = level[type], raw = raw)

}

#' @export
liechtenstein <- function(raw = FALSE){

  warning("This function is deprecated and will be REMOVED soon.
          Run instead -> covid19('LIE')")

  level <- c("country" = 1, "state" = 2, "city" = 3)

  covid19("LIE", raw = raw)

}

#' @export
switzerland <- function(type = "state", raw = FALSE){

  warning("This function is deprecated and will be REMOVED soon.
          Run instead -> covid19('CHE')")

  level <- c("country" = 1, "state" = 2, "city" = 3)

  covid19("CHE", level = level[type], raw = raw)

}

#' @export
us <- function(type = "state", raw = FALSE){

  warning("This function is deprecated and will be REMOVED soon.
          Run instead -> covid19('USA')")

  level <- c("country" = 1, "state" = 2, "city" = 3)

  covid19("USA", level = level[type], raw = raw)

}

#' @export
world <- function(type = "state", raw = FALSE){

  warning("This function is deprecated and will be REMOVED soon.
          Run instead -> covid19()")

  level <- c("country" = 1, "state" = 2, "city" = 3)

  covid19(level = level[type], raw = raw)

}
