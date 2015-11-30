getwd()
setwd("/homes/jewson/MyDocuments/Module4/parallel_IMH/BLOCK_JACK_MOD")
#setwd("data/greyheron/oxwasp/oxwasp15/jewson/BLOCK_JACK_MOD")

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