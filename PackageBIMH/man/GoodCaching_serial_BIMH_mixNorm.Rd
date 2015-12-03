\name{GoodCaching_serial_BIMH_mixNorm}
\alias{GoodCaching_serial_BIMH_mixNorm}

\title{
Block Independent Metropolis-Hastings sampler targetting a normal mixture, caching efficiently.
}
\description{
Given a initial value x_0, the algorithm generate a Markov-Chain (MC) with invariant distrubution a mixture of normal( 0.3*N(0, 1) + 0.7*N(5, 1)), of length T, where T = p * b. This algorithm used a block-wise independent Metropolis-Hastings method. The algorithm returns also an estimate (est) of the mean.
Alternatively to the paper cited, the proposals are generated locally within blocks in order to avoid over flowing the cache, hence reducing the number of memory operations required.

We provide two functions, one for running the algorithm, and the second to osberve the behaviour of the output (considering also the time). The diagnostic includes the histogram of the MC, the running estimate of the mean, the traceplot and the ACF plot.
}
\usage{
\item GoodCaching_serial_BIMH_mixNorm(x_start, p, b)
\item diagn_GoodCaching_serial_BIMH_mixNorm(x_start, p, b)
}

\arguments{
 \item{x_start}{Initial value for the Markov Chain}
 \item{p}{Number of chains in each block}
 \item{b}{Number of blocks}
}

\value{
\item{GoodCaching_serial_BIMH_mixNorm} Returns: Markov-Chain of length T = (b * p ), estimate for mean.
\item{diagn_GoodCaching_serial_BIMH_mixNorm} Returns: the time it takes to run the algorithm, the estimate for mean, and the 4 diagnostic graph mentioned above.
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
