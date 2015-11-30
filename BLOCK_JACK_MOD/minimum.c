#include <stdio.h>

#include "minimum.h"

double minimum(double a, double b) {
  double res = (a < b) ? a : b;
  return res;
}
