#include <stdio.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>

#include "distributions.h"

double distr_target(double x) 
{
  return gsl_ran_gaussian_pdf(x, 1);
}

double distr_proposal(double x)
{
  return gsl_ran_cauchy_pdf(x, 1);
}

double random_proposal(gsl_rng* r)
{
  return gsl_ran_cauchy(r, 1);
}

