getwd()
setwd("/homes/jewson/MyDocuments/Module4/parallel_IMH/BLOCK_JACK_MOD")

dyn.load("BIMH_forR.so")

serial_BIMH = function(x_start, p, b) {
  ans = .C("serial_block_IMH", as.double(x_start), as.integer(p), 
           as.integer(b), as.double(matrix(0, nrow = p, ncol = b*p +1)),
           as.double(matrix(0, nrow = p, ncol = b*p +1)), 
           as.double(0), as.double(numeric(b * p + 1)), as.double(numeric(b*p +1)))
  return(list(x_mat = matrix(ans[[4]], nrow = p, ncol = (b*p + 1), byrow=TRUE),
              w_mat = matrix(ans[[5]], nrow = p, ncol = (b*p + 1), byrow=TRUE),
              est = ans[[6]],
              MC = ans[[7]]))
}


x_start = 0
p= 100
b = 100

grid = (-900:900)/100

test = serial_BIMH(x_start, p, b)
hist(test$MC, breaks=30, freq = F, col = "pink")
lines(grid, 0.3*dnorm(grid) + 0.7*dnorm(grid, 5), col = "blue", lwd = 3)
lines(grid, dcauchy(grid), col = "green", lwd = 3, lty = 2)
  
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
