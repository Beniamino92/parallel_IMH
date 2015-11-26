#include <stdio.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>

#include "r_cauchy.h"

void r_cauchy(gsl_rng* r, double* proposed_values, const int size) 
{
  int t;
  for(t = 0; t < size; t++) 
    {
      proposed_values[t] =  (double) gsl_ran_cauchy(r, 1);
    }
}
