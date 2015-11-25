# write void function in C, input should be a pointer (equivalent to a vector) the pointer allows us to access the output# Rtest.c
# complie C code to shared library in terminal # R CMD SHLIB Rtest.c # gives you .so file in the same file as the .c file
# check the working directory of R is in the write place # getwd() or setwd("/homes/jewson/Documents/Cprogramming")
# load C to R # dyn.load("Rtest.so")
# run .C("addup",as.integer(c(0,0,0,0))) # just have to initialise output # use function name rather than c file name

setwd("/homes/jewson/Documents/Cprogramming")
dyn.load("Rtest.so")


.C("addup",as.integer(c(0,0,0,0)))

.C("addup", as.integer(numeric(4)))
