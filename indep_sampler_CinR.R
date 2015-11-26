# R CMD SHLIB -lgsl -lgslcblas importance_sampler4.c


getwd()
setwd("/homes/jewson/MyDocuments/Module4/IMH")
getwd()

dyn.load("importance_sampler4.so")

.C("Importance_Sampler",as.integer(10),as.double(numeric(10)),as.double(numeric(10)),as.double(1.0))


dyn.load("importance_sampler.so")

.C("Importance_Sampler",as.integer(10),as.double(numeric(10)),as.double(numeric(10)),as.double(1.0))
