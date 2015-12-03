# serial_BIMH_mixNorm_R
serial_BIMH_mixNorm_R = function(x_0, d_target, d_proposal,
                               r_proposal, p, b)
{

  T = p * b

  # All values used in estimator and corresponding weights
  x_mat = matrix(0, nrow = p, ncol = T + 1)
  w_mat = matrix(0, nrow = p, ncol = T + 1)
  # Final Chain
  x_chain = rep(0, T + 1)
  w_chain = rep(0, T + 1)
  # Proposed values and weights
  y = rep(0, T)
  w = rep(0, T)
  # Placeholder for permutation
  perm = rep(0, p)
  # For the single chain
  x_prop = rep(0, p)
  w_prop = rep(0, p)

  # 1st step BIMH
  x_mat[, 1] = x_0
  w_mat[, 1] = d_target(x_0)/d_proposal(x_0)
  x_chain[1] = x_0
  w_chain[1] = w_mat[1, 1]

  # Sampling and calculating weights
  y = r_proposal(T)
  w = d_target(y)/d_proposal(y)

  # For each block
  for(i in 1:b) {
    x_prop = y[((i-1)*p+1):(i*p)]
    w_prop = w[((i-1)*p+1):(i*p)]
    x_start = x_chain[((i-1)*p+1)]
    w_start = w_chain[((i-1)*p+1)]

    # For each row in our block
    for(k in 1:p) {

      # Accepting or rejecting the first step
      perm = sample(1:p, size = p, replace = FALSE)
      if(runif(1) <= min(1, w_prop[perm[1]]/w_start)) {
        x_mat[k, ((i-1)*p+2)] = x_prop[perm[1]]
        w_mat[k, ((i-1)*p+2)] = w_prop[perm[1]]
      }
      else{
        x_mat[k, ((i-1)*p+2)] = x_start
        w_mat[k, ((i-1)*p+2)] = w_start
      }
      # For each column in our block, i.e our actual markov chain

      for(m in 1:(p-1)) {
        if(runif(1) <= min(1,
                           w_prop[perm[m+1]]/w_mat[k, (((i-1)*p+2)+m-1)])) {
          x_mat[k, (((i-1)*p+2)+m)] = x_prop[perm[m+1]]
          w_mat[k, (((i-1)*p+2)+m)] = w_prop[perm[m+1]]
        }
        else{
          x_mat[k, (((i-1)*p+2)+m)] = x_mat[k, (((i-1)*p+2)+m-1)]
          w_mat[k, (((i-1)*p+2)+m)] = w_mat[k, (((i-1)*p+2)+m-1)]
        }
      }
    }
    # Selecting chain
    j = sample(1:p, size = 1)
    x_chain[((i-1)*p+2):((i)*p+1)] = x_mat[j,(((i-1)*p+2):((i)*p+1))]
    w_chain[((i-1)*p+2):((i)*p+1)] = w_mat[j,(((i-1)*p+2):((i)*p+1))]
  }

  est = sum(rowSums(x_mat))/((T+1) * p)

  return(list(est = est, MC = x_chain))
}



# diagn_serial_BIMH_mixNorm_R
diagn_serial_BIMH_mixNorm_R = function(x_start, p, b)
{
  time = system.time(out <- serial_BIMH_mixNorm_R(x_start,
                                                  function(x) { 0.3*dnorm(x, 0, 1) + 0.7*dnorm(x, 5, 1)},
                                                  function(y) { dcauchy(y) },
                                                  function(n) { rcauchy(n) },
                                                  p = p, b = b))

  par(mfrow=c(2, 2))
  grid = (-900:900)/10

  hist(out$MC, breaks = p/2 + 20, freq = F,
       col = "pink", main = "Histogram MC", xlab = "",
       ylim = c(0, 0.33), ylab = "")
  lines(grid, 0.3*dnorm(grid) + 0.7*dnorm(grid, 5), col = "blue", lwd = 3)

  plot(1:length(out$MC), cumsum(out$MC)/(1:length(out$MC)),
       type = "l", lwd = 1, main = "Running means", ylab = "", xlab = "t")
  abline(h = 3.5, col = "green", lwd = 1, lty = 3)
  est = out$est

  plot(1:length(out$MC), out$MC, type = "l", col = "red", xlab = "t",
       main = "Traceplot MC", ylab = "")

  plot(0:400, acf(out$MC, lag = 400, plot = F)$acf, type = "s",
       main = "ACF", xlab = "Lag", lwd = 2, col = "green", ylab = "")

  return(list("estimate"=est,"system.time"=time))
}




