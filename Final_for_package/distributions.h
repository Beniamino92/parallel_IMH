#ifndef distributions_H
#define distributions_H

double distr_target(double x);
double distr_proposal(double x);
double random_proposal(gsl_rng* r);

#endif
