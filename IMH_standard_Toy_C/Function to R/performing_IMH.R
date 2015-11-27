#Set your folder
setwd("/home/hadjamar/Desktop/IMH_algorithm/IMH_standard_Toy_C/Function to R")

#To create IMH.so: R CMD SHLIB -lgsl -lgslcblas IMH.c 
#                  minimum.c r_cauchy.c r_unif.c eval_weights.c

#Load IMH.so
dyn.load("IMH.so")

#Get the data
data = .C("IMH", data = as.double(numeric(1000)),
          as.integer(1000), as.double(-2))$data

#Exploring the sample.
grid = (-600:600)/100
hist(data, breaks = 40, freq = F, ylim = c(0, 0.37), col = "grey")
lines(grid, dnorm(grid, 0, 1), col = "red", lwd = 2)
