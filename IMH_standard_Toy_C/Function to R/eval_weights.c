#include <stdio.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>

#include "eval_weights.h"

void eval_weights(double* weights, double* proposed_values, const int size)
{
  int t;
  for(t = 0; t < size; t++) {
     weights[t] = gsl_ran_gaussian_pdf(proposed_values[t], 1)/gsl_ran_cauchy_pdf(proposed_values[t], 1);
  }
}
