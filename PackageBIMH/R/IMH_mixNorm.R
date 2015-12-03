# IMH_mixNorm
IMH_mixNorm = function(x_start, p, b)
{

  ans = .C("IMH_mixNorm", as.integer(p * b), as.double(numeric(p * b)),
           as.double(numeric(p * b)), as.double(0.0), as.double(x_start))

  return(list(est = ans[[4]],
              MC = ans[[2]]))
}


# diagn_IMH_mixNorm
diagn_IMH_mixNorm = function(x_start, p, b)
{
  time = system.time(out <- IMH_mixNorm(x_start, p, b))

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
