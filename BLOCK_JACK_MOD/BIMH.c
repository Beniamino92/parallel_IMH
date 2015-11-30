#include <stdio.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>

#include "distributions.h"
#include "minimum.h"

void serial_block_IMH(double x_0, size_t T, size_t p, size_t b)
{
	//Creating memory for random number generation 
	const gsl_rng_type* T_;
	gsl_rng* r;
	T_ = gsl_rng_default;
	r = gsl_rng_alloc(T_);
	
	//All values used for the estimator.
	double x_mat[p][((T)+1)];
	double w_mat[p][((T)+1)];

	// The actual chain. 
	double x_chain[((T)+1)];
	double w_chain[((T)+1)];

	// Proposed values and weights.
	double y[T];
	double w[T];	

	// Placeholder for permutation.
	int perm[p];

	// For each block IMH.
	double x_prop[p];
	double w_prop[p];

	// Starting values 
	double x_start;
	double w_start;

	// Indexes.
	size_t i, j, m, l, k;
	double est = 0;

	// Initialisation.
	for(i=0; i < p; i++){
		x_mat[i][0] = x_0; 
		w_mat[i][0] = distr_target(x_0)/distr_proposal(x_0);
	}
	x_chain[0] = x_0;
  	w_chain[0] = w_mat[0][0];
	printf("x_0 = %f, w_chain=%f, w_mat=%f\n",x_chain[0], w_chain[0], w_mat[2][0]);

	// Sampling the proposals and calculating their weights-parralelised.
	for(i = 0; i < (T); i++){
	  y[i] = random_proposal(r);
		w[i] = distr_target(y[i])/distr_proposal(y[i]);
		printf("y[%zu] = %f, w[%zu] = %f\n", i, y[i], i, w[i]);	
	}

	// For each block.
	for(i = 0; i < b; i++) {
		for(l = 0; l < p; ++l) {
			x_prop[l] = y[(i*(p)+l)];
			w_prop[l] = w[(i*(p)+l)];
		printf("x_prop[%zu] = %f, w_prop[%zu] = %f\n", l, x_prop[l], l, w_prop[l]);
		}
		x_start = x_chain[(i*(p))]; 
   		w_start = w_chain[(i*(p))];
		for(k = 0; k < p; k++){

			// Accepting or rejecting the first step.
			for(l = 0; l < p; l++) {
				perm[l] = gsl_rng_uniform_int(r,(p));
			printf("perm[%zu] = %d\n", l, perm[l]);
			} 
			if(gsl_rng_uniform(r) <= minimum(1, (w_prop[perm[0]]/w_start))){
				x_mat[k][(i*(p))+1] = x_prop[perm[0]];
				w_mat[k][(i*(p))+1] = w_prop[perm[0]];
			}
			else{
				x_mat[k][(i*(p))+1] = x_start;
				w_mat[k][(i*(p))+1] = w_start;
			}

			//For each column in our block the MC.
			for(m = 0; m < ((p)-1); ++m) {
	      
				if(gsl_rng_uniform(r) <= minimum(1, (w_prop[perm[m+1]]/w_mat[k][((i*(p))+1+m)]))) {
					x_mat[k][((i*(p))+2+m)] = x_prop[perm[m+1]];
					w_mat[k][((i*(p))+2+m)] = w_prop[perm[m+1]];
				}
				else{
					x_mat[k][((i*(p))+2+m)] = x_mat[k][((i*(p))+1+m)];
					w_mat[k][((i*(p))+2+m)] = w_mat[k][((i*(p))+1+m)];
				}
			}
		}
		
		j = gsl_rng_uniform_int(r,(p));
		
		for(l = 0; l < p; ++l){
			x_chain[((i*(p))+1+l)] = x_mat[j][((i*(p))+1+l)];
			w_chain[((i*(p))+1+l)] = w_mat[j][((i*(p))+1+l)];
		}
	}

	for(l = 0; l < (T+1); ++l) {
		for(m = 0; m < p; ++m) {
			printf("X[%zu][%zu]: %f, W[%zu][%zu]: %f \n", m, l, x_mat[m][l], m, l, w_mat[m][l]);
			est += x_mat[m][l];
		}
	}

	printf("The estime is %f\n", est/((T+1)*p));
}
  

void serial_block_IMH(double x_0, size_t T, size_t p, size_t b);

int main() 
{
  printf("Ciao Jack\n");
  serial_block_IMH(1.0, 10, 2, 5);
  return 0;
}

  
