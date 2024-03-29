% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/covid19.R
\name{read.zip}
\alias{read.zip}
\title{Data Input (zip)}
\usage{
read.zip(
  zip,
  files,
  cache = FALSE,
  fread = FALSE,
  xsv = FALSE,
  method = "auto",
  ...
)
}
\arguments{
\item{zip}{path (url) to the zip folder.}

\item{files}{vector of filenames to read inside the zip folder.}

\item{cache}{logical. Memory caching? Default \code{FALSE}.}

\item{fread}{logical indicating whether \code{\link[data.table]{fread}} should be used}

\item{xsv}{logical indicating whether \code{\link{xsv}} should be used. If \code{TRUE}, the argument \code{select} must be specified}

\item{method}{the download method passed to \code{\link[utils]{download.file}}}

\item{...}{arguments passed to \code{\link{read.csv}} or \code{\link{read.excel}}.}
}
\value{
list of data frames
}
\description{
Reads files from a zip folder.
}
\keyword{internal}
