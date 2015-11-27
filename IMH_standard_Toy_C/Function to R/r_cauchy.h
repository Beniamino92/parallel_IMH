#include <stdio.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>


void r_cauchy(gsl_rng* r, double* proposed_values, const int size);
