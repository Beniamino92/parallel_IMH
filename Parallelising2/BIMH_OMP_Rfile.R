setwd("/homes/jewson/MyDocuments/Module4/parallel_IMH/Parallelising2")

serial_BIMH = function(x_start, p, b) {
  ans = .C("serial_block_IMH", as.double(x_start), as.integer(p), 
           as.integer(b), as.double(matrix(10, nrow = p, ncol = p +1)),
           as.double(matrix(10, nrow = p, ncol = p +1)), 
           as.double(0), as.double(numeric(b * p + 1)), as.double(numeric(b*p +1)))
  return(list(est = ans[[6]],
              MC = ans[[7]]))
}

test<-function(x0, p, b){
  time<-system.time(out<-serial_BIMH(x0, p, b))
  grid = (-900:900)/100
  par(mfrow=c(2, 1))
  hist(out$MC, breaks=100, freq = F, col = "pink", main = "", xlab = "")
  lines(grid, 0.3*dnorm(grid) + 0.7*dnorm(grid, 5), col = "blue", lwd = 3)
  plot(1:length(out$MC), cumsum(out$MC)/(1:length(out$MC)),
       type = "l", lwd = 1)
  abline(h = 3.5, col = "grey", lwd = 1, lty = 3)
  est<-out$est
  return(list("estimate"=est,"system.time"=time))
}

dyn.load("BIMH_OMP_FULL_PARALLEL.so")

test(0,100, 100000)

dyn.load("BIMH_OMP_FULL_PARALLEL_1TH.so")

test(0,100, 100000)
