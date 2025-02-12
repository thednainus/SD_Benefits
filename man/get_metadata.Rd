% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cosmetics.R
\name{get_metadata}
\alias{get_metadata}
\title{Get metadata of tip to use as deme in the phydynR model}
\usage{
get_metadata(tip_name)
}
\arguments{
\item{tip_name}{character}
}
\value{
character with the deme name that can be "I", "Tr", or "src". "I"
   corresponds to infected individuals; Tr corresponds to individuals
   on treatment and "src" corresponds to source sequences that account for
   importation in the phylodynamic analysis.
}
\description{
Get metadata of tip to use as deme in the phydynR model
}
