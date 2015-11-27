#include <stdio.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>


#include "minimum.h"
#include "r_unif.h"
#include "r_cauchy.h"
#include "eval_weights.h"


int main() {

  const int size = 20;
  const double start = -0.5;
 
  const gsl_rng_type* T;
  gsl_rng* r;
  T = gsl_rng_default;
  r = gsl_rng_alloc(T);

  double sample[size];
  double uniforms[size];
  double weights[size];
  double proposed_values[size];
  double alpha;

  int t;
  
  //Generenting Uniforms [0, 1]
  r_unif(r, uniforms, size);
  //Generating Proposal values from Cauchy;
  r_cauchy(r, proposed_values, size);
  //Evaluating Weights Target(y_t)/Proposal(y_t)
  eval_weights(weights, proposed_values, size);
  
  //Setting initial value
  sample[0] = start;
  //Running Markov Chain
  for(t = 1; t < size; ++t) 
    {
      alpha =  minimum(1.0, weights[t]/weights[t-1]);
      sample[t] =  (uniforms[t] <= alpha) ? proposed_values[t] : sample[t-1];
      printf("sample[%d]: %f\n", t, sample[t]);
    }

  gsl_rng_free(r);

}

  
  
  
/*
gcc -I/usr/local/include -L/usr/local/lib main.c -o main -lgsl -lgslcblas -lm
*/

/*
gcc -I/usr/local/include -L/usr/local/lib main.c my_rnorm.c my_rnorm.h -o main -lgsl -lgslcblas -lm
*/

/*
gcc -I/usr/local/include -L/usr/local/lib main.c minimum.c r_unif.c r_cauchy.c eval_weights.c minimum.h r_unif.h r_cauchy.h eval_weights.h -o main -lgsl -lgslcblas -lm
*/
