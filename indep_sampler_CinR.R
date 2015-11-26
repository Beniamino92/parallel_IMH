# R CMD SHLIB -lgsl -lgslcblas importance_sampler4.c


getwd()
setwd("/homes/jewson/MyDocuments/Module4/IMH")
getwd()

dyn.load("importance_sampler4.so")

.C("Importance_Sampler",as.integer(10),as.double(numeric(10)),as.double(numeric(10)),as.double(1.0))


dyn.load("importance_sampler.so")

.C("Importance_Sampler",as.integer(1000),as.double(numeric(10)),as.double(numeric(10)),as.double(1.0))

#parallel version 

dyn.load("importance_sampler_parallel.so")
.C("Importance_Sampler",as.integer(10),as.double(numeric(10)),as.double(numeric(10)),as.double(1.0))

#check cacheing
T=100000000
dyn.load("importance_sampler.so")
system.time(.C("Importance_Sampler",as.integer(T),as.double(numeric(T)),as.double(numeric(T)),as.double(1.0)))
dyn.load("importance_sampler_parallel.so")
system.time(.C("Importance_Sampler",as.integer(T),as.double(numeric(T)),as.double(numeric(T)),as.double(1.0)))
dyn.load("importance_sampler_parallel_restrict.so")
system.time(.C("Importance_Sampler",as.integer(T),as.double(numeric(T)),as.double(numeric(T)),as.double(1.0)))
