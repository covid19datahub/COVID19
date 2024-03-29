% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/covid19.R
\name{id}
\alias{id}
\title{Convert identifiers}
\usage{
id(x, iso, ds, level)
}
\arguments{
\item{x}{vector of identifiers used by the data source to identify administrative areas.}

\item{iso}{the 3 letter ISO code of the country.}

\item{ds}{the name of the data source function.}

\item{level}{the level of the administrative areas.}
}
\value{
converted vector of identifiers to use in the Data Hub.
}
\description{
Map the ids of administrative areas used by the data provider to the
identifiers used in the Data Hub.
}
\keyword{internal}
