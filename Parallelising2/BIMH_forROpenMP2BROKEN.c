
#include <stdio.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>
#include <omp.h>

#include "distributions.h"
#include "minimum.h"
#include "timing.h"

//create .so file by

// create shared file using R CMD SHLIB -lgsl -lgslcblas BIMH_forR....c distributions.c minimum.c  // 

void serial_block_IMH(double* restrict px_0, int* restrict pp, int* restrict pb,
		      double (* restrict x_mat)[((*pp)*(*pb))+1], double (*  restrict w_mat)[((*pp)*(*pb))+1],
		      double* restrict pest, double* restrict x_chain, double* restrict w_chain)
{
  // initalising pointers
  double x_0;
  size_t p, b;
  x_0 = *px_0;
  p = (size_t)*pp;
  b = (size_t)*pb;
  
  //Creating memory for random number generation 
  const gsl_rng_type* T_;
  gsl_rng* r;
  T_ = gsl_rng_default;
  r = gsl_rng_alloc(T_);
  
  //Lenght of the chain
  size_t T = p * b;
  
  // Placeholder for permutation.
  int perm[p][p];
  
  // For each block IMH.
  double x_prop[p];
  double w_prop[p];
  
  // Starting values 
  double x_start;
  double w_start;
  
  // Indexes.
  size_t i, j, m, l, k, n, q[p];
  double est = 0.0;
  
  // Initialisation.
  for(i = 0; i < p; i++) {
    x_mat[i][0] = x_0; 
    w_mat[i][0] = distr_target(x_0)/distr_proposal(x_0);
  }
  x_chain[0] = x_0;
  w_chain[0] = w_mat[0][0];

  // double t;
  // reset_and_start_timer();
 
  // t = get_elapsed_mcycles();
  // printf("\t\t[%.3f] million cycles\n", t);

  
  // For each block.
  for(i = 0; i < b; i++) {
    // #pragma omp parallel for
    for(l = 0; l < p; ++l) {
      // Sampling the proposals and calculating their weights-parralelised for that block - should improve cacheing.
      x_prop[l] =  random_proposal(r);
      w_prop[l] =  distr_target(x_prop[l])/distr_proposal(x_prop[l]);
    }
    x_start = x_chain[(i*(p))]; 
    w_start = w_chain[(i*(p))];
    // for each row of each block
    //#pragma omp parallel for 
    for(k = 0; k < p; k++) {
      
      //Generate random permutation using Knuth shuffle 

      for (n = 0; n < p; n++) {
	q[k] = gsl_rng_uniform_int(r, (n+1)); //returns random int between 0 and n inclusive	      
	perm[k][n] = perm[k][q[k]];		      
	perm[k][q[k]] = n;
      }
      // Accepting or rejecting the first step.
      if(gsl_rng_uniform(r) <= minimum(1, (w_prop[perm[k][0]]/w_start))){
	x_mat[k][(i*(p))+1] = x_prop[perm[k][0]];
	w_mat[k][(i*(p))+1] = w_prop[perm[k][0]];
      }
      else{
	x_mat[k][(i*(p))+1] = x_start;
	w_mat[k][(i*(p))+1] = w_start;
      }
      
      //For each column in our block the MC.
      for(m = 0; m < ((p)-1); ++m) {
	
	if(gsl_rng_uniform(r) <= minimum(1, (w_prop[perm[k][m+1]]/w_mat[k][((i*(p))+1+m)]))) {
	  x_mat[k][((i*(p))+2+m)] = x_prop[perm[k][m+1]];
	  w_mat[k][((i*(p))+2+m)] = w_prop[perm[k][m+1]];
	}
	else {
	  x_mat[k][((i*(p))+2+m)] = x_mat[k][((i*(p))+1+m)];
	  w_mat[k][((i*(p))+2+m)] = w_mat[k][((i*(p))+1+m)];
	}
      }
    }
    
    //Choosing chain
    j = gsl_rng_uniform_int(r,(p));
    
    for(l = 0; l < p; ++l) {
      x_chain[((i*(p))+1+l)] = x_mat[j][((i*(p))+1+l)];
      w_chain[((i*(p))+1+l)] = w_mat[j][((i*(p))+1+l)];
    }
  }
  
  for(l = 0; l < (T+1); ++l) {
    for(m = 0; m < p; ++m) {
      est += x_mat[m][l];
    }
  }
  est /= (T+1)*p;
  *pest = est;
}

  
    


  
