getwd()
setwd("/homes/jewson/MyDocuments/Module4/parallel_IMH/BLOCK_JACK_MOD")

dyn.load("BIMH_forR.so")




.C("serial_block_IMH", as.double(0), as.integer(5), 
   as.integer(2), as.double(matrix(0, nrow = 5, ncol = 11)),
   as.double(matrix(0, nrow = 5, ncol = 11)), 
   as.double(0), as.double(numeric(11)), as.double(numeric(11)))



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
p = 5
b = 2


test = serial_BIMH(x_start, p, b)$MC; test
