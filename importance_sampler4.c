#include<stdio.h>
#include<gsl/gsl_rng.h>
#include<gsl/gsl_randist.h>

// need main to run in gcc
//create shared file using R CMD SHLIB -lgsl -lgslcblas importance_sampler4.c
// run using gcc -I/usr/local/include -L/usr/local/lib importance_sampler.c -o IS -lgsl -lgslcblas -lm 

void Importance_Sampler(int* N, double* X, double* W, double* pest)
{
// creating memory for the random number generation - this is louis code and doesn't create cpmstant random numbers
  static gsl_rng *restrict r = NULL;
  
  if(r == NULL) { // First call to this function, setup RNG
    gsl_rng_env_setup();
    r = gsl_rng_alloc(gsl_rng_mt19937);
  }
//
int i,M;
M = *N;
double est=0;

//proposals //weight
for(i=0;i<M;++i){
X[i] = gsl_ran_cauchy(r,1);
W[i] = gsl_ran_gaussian_pdf(X[i],1)/gsl_ran_cauchy_pdf(X[i],1);}

for(i=0;i<M;++i){
est += X[i]*W[i];}

est /= M;
*pest=est;

}


//int main() {
//printf("ciao benni \n");}
