#include <stdio.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>

#include "minimum.h"

double minimum(double a, double b) {
  double res = (a < b) ? a : b;
  return res;
}
