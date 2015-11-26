#include<stdio.h>
#include<gsl/gsl_rng.h>
#include<gsl/gsl_randist.h>
#include<omp.h>

// need main to run in gcc
// create shared file using R CMD SHLIB -lgsl -lgslcblas  importance_sampler.c
// In order to add the flag -fopenmp to run openMP. create Makevars (textfile) in PKG_CFLAGS+=-fopenmp // can also add other flags to Makevars
// run using gcc -I/usr/local/include -L/usr/local/lib importance_sampler.c -o IS -lgsl -lgslcblas -lm 
void Importance_Sampler(int* restrict  N,  double* restrict X,  double* restrict W, double* restrict pest)
{
// creating memory for the random number generation // Benni's code, creates constant random numbers

	const gsl_rng_type* T;
	gsl_rng* r;

	T = gsl_rng_default;
	r = gsl_rng_alloc(T);

	int i,M;
	M = *N;
	double est=0;

	//proposals //weight
	#pragma omp for
	for(i=0;i<M;++i){
		X[i] = gsl_ran_cauchy(r,1);
		W[i] = gsl_ran_gaussian_pdf(X[i],1)/gsl_ran_cauchy_pdf(X[i],1);
	}
	

	#pragma omp parallel for reduction(+:est)
	for(i=0;i<M;++i){
		est += X[i]*W[i];
	}
	

	est /= M;
	*pest=est;

}


//int main() {
//printf("ciao benni \n");}
