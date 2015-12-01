getwd()
setwd("/homes/jewson/MyDocuments/Module4/parallel_IMH/BLOCK_JACK_MOD")


serial_BIMH2 = function(x_start, p, b) {
  ans = .C("serial_block_IMH", as.double(x_start), as.integer(p), 
           as.integer(b), as.double(matrix(0, nrow = p, ncol = b*p +1)),
           as.double(matrix(0, nrow = p, ncol = b*p +1)), 
           as.double(0), as.double(numeric(b * p + 1)), as.double(numeric(b*p +1)))
  return(list(est = ans[[6]],
              MC = ans[[7]]))
}

dyn.load("BIMH_forR.so")

system.time(serial_BIMH2(0, 100, 1000))

dyn.load("BIMH_forRrestrict.so")

system.time(serial_BIMH2(0, 100, 1000))  

dyn.load("BIMH_forROPENMP.so")

system.time(serial_BIMH2(0, 100, 1000)) 

setwd("/homes/jewson/MyDocuments/Module4/parallel_IMH/Parallelising2")

dyn.load("BIMH_forROpenMP2.so")

system.time(serial_BIMH2(0, 100, 1000)) 

test<-serial_BIMH2(0, 10, 10)
test2<-serial_BIMH2(0, 100, 1000)

hist(test2$MC,breaks=30)

setwd("/homes/jewson/MyDocuments/Module4/parallel_IMH/Parallelising2")
serial_BIMH3 = function(x_start, p, b) {
  ans = .C("serial_block_IMH", as.double(x_start), as.integer(p), 
           as.integer(b), as.double(matrix(10, nrow = p, ncol = p +1)),
           as.double(matrix(10, nrow = p, ncol = p +1)), 
           as.double(0), as.double(numeric(b * p + 1)), as.double(numeric(b*p +1)))
  return(list(est = ans[[6]],
              MC = ans[[7]]))
}

dyn.load("BIMH_forROpenMP4.so")

test2<-serial_BIMH3(0, 100, 100000)

test2$est

size = 1e5
plot(1:(1e5+1), cumsum(test2$MC)/(1:(1e5+1)))
hist(test2$MC,breaks=30)
length(test2$MC)
test$MC

grid = (-900:900)/100
test<-serial_BIMH3(0, 100, 1000)
hist(test2$MC, breaks=100, freq = F, col = "pink")
lines(grid, 0.3*dnorm(grid) + 0.7*dnorm(grid, 5), col = "blue", lwd = 3)
lines(grid, dcauchy(grid), col = "green", lwd = 3, lty = 2)
factor(test$MC)


