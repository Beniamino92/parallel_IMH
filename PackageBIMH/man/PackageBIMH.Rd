\name{PackageBIMH}
\alias{PackageBIMH}
\alias{BIMH}
\docType{package}
\title{
Package for Block Independent Metroplis-Hastings sampler targetting normal mixture, for both parallelised and serial implementation.
}

\details{
\tabular{ll}{
Package: \tab PackageBIMH\cr
Type: \tab Package\cr
Version: \tab 0.1\cr
Date: \tab 2015-12-02\cr
License: \tab OxWaSP\cr
}
}
\references{
"Using parallel computation to improve independent Metropolis-Hastings based estimation" P.Jacob, C.P Robert, M.H Smith 2011.
}

\author{
Hadj-Amar B., Jewson J., Wang A.
}

\examples{
\item GoodCaching_serial_BIMH_mixNorm(-2, 96, 1000)
\item diagn_GoodCaching_serial_BIMH_mixNorm(-2, 96, 1000)
}
