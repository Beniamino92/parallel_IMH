#include <stdio.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>

#include "r_unif.h"

void r_unif(gsl_rng* r, double* uniforms, const int size) 
{
  int t;
  for(t = 0; t < size; t++) 
    {
      uniforms[t] =  (double) gsl_rng_uniform(r);
    }
} 
