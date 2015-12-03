\name{ParallelProposal_BIMH_mixNorm}
\alias{ParallelProposal_BIMH_mixNorm}

\title{
Block Independent Metropolis-Hastings sampler targetting a normal mixture, with OMP parallelisation in the generations of proposals and evaluations of weights.
}
\description{
Given a initial value x_0, the algorithm generate a Markov-Chain (MC) with invariant distrubution a mixture of normal( 0.3*N(0, 1) + 0.7*N(5, 1)), of length T, where T = p * b. This algorithm used a block-wise independent Metropolis-Hastings method. When generating and evaluating weights, we parallelised the computation over the threads by using OMP. The algorithm returns also an estimate (est) of the mean.

We provide two functions, one for running the algorithm, and the second to osberve the behaviour of the output (considering also the time). The diagnostic includes the histogram of the MC, the running estimate of the mean, the traceplot and the ACF plot.
}
\usage{
\item ParallelProposal_BIMH_mixNorm(x_start, p, b)
\item diagn_ParallelProposal_BIMH_mixNorm(x_start, p, b)
}

\arguments{
 \item{x_start}{Initial value for the Markov Chain}
 \item{p}{Number of chains in each block}
 \item{b}{Number of blocks}
}

\value{
\item{ParallelProposal_BIMH_mixNorm} Returns: Markov-Chain of length T = (b * p ), estimate for mean.
\item{diagn_ParallelProposal_BIMH_mixNorm} Returns: the time it takes to run the algorithm, the estimate for mean, and the 4 diagnostic graph mentioned above.
}

\references{
"Using parallel computation to improve independent Metropolis-Hastings based estimation" P.Jacob, C.P Robert, M.H Smith 2011.
}

\author{
Hadj-Amar B., Jewson J., Wang A.
}

\examples{
\item ParallelProposal_BIMH_mixNorm(-2, 96, 1000)
\item diagn_ParallelProposal_BIMH_mixNorm(-2, 96, 1000)
}
