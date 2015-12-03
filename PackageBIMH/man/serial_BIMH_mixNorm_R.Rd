\name{serial_BIMH_mixNorm_R}
\alias{serial_BIMH_mixNorm_R}

\title{
Block Independent Metropolis-Hastings sampler targetting a normal mixture, as describeed in the paper cited. Alternatively of all the other functions in this package (which are implemented in C), this is implemented in R.
}
\description{
Given a initial value x_0, the algorithm generate a Markov-Chain (MC) with invariant distrubution a mixture of normal( 0.3*N(0, 1) + 0.7*N(5, 1)), of length T, where T = p * b. This algorithm used a block-wise independent Metropolis-Hastings method.The algorithm returns also an estimate (est) of the mean.

We provide two functions, one for running the algorithm, and the second to osberve the behaviour of the output (considering also the time). The diagnostic includes the histogram of the MC, the running estimate of the mean, the traceplot and the ACF plot.
}
\usage{
\item serial_BIMH_mixNorm_R(x_start, p, b)
\item diagn_serial_BIMH_mixNorm_R(x_start, p, b)
}

\arguments{
 \item{x_start}{Initial value for the Markov Chain}
 \item{p}{Number of chains in each block}
 \item{b}{Number of blocks}
}

\value{
\item{serial_BIMH_mixNorm_R Returns: Markov-Chain of length T = (b * p ), estimate for mean.
\item{diagn_serial_BIMH_mixNorm_R} Returns: the time it takes to run the algorithm, the estimate for mean, and the 4 diagnostic graph mentioned above.
}

\references{
"Using parallel computation to improve independent Metropolis-Hastings based estimation" P.Jacob, C.P Robert, M.H Smith 2011.
}

\author{
Hadj-Amar B., Jewson J., Wang A.
}

\examples{
\item serial_BIMH_mixNorm_R(-2, 96, 1000)
\item diagn_serial_BIMH_mixNorm_R(-2, 96, 1000)
}
