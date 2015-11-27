#include<stdio.h>
#include<gsl/gsl_rng.h>
#include<gsl/gsl_randist.h>
// gcc -I/usr/local/include -L/usr/local/lib serial_Block_IMH.c -o BlockIMH -lgsl -lgslcblas -lm 
// create shared file using R CMD SHLIB -lgsl -lgslcblas ... .c // need Makevar file

// alloc


void serial_block_IMH(double* px0,int* pT,int* pp,int* pb,double** x, double** wmat, double* pest)
{
	int x0,T,p,b;
	x0=*px0;
	T=*pT;
	p=*pp;
	b=*pb;

	//creating memory for random number generation 
	const gsl_rng_type* N;
	gsl_rng* r;

	N = gsl_rng_default;
	r = gsl_rng_alloc(N);
	
	
	double minimum(double a, double b);

	// the actual chain 
	double xchain[((T)+1)];
	double wchain[((T)+1)];
	//proposed values and weights
	double y[T];
	double w[T];	
	//placeholder for permutation
	int perm[p];
	//for each block IMH
	double xprop[p];
	double wprop[p];
	// starting values 
	double xstart;
	double wstart;
	// indexes
	int i,j,m,l,k;
	double est=0.0;
	


	// initialisation
	for(i=0; i<p;++i){
		x[i][0]=x0; 
		wmat[i][0]=gsl_ran_gaussian_pdf(x0,1)/gsl_ran_cauchy_pdf(x0,1);
	}
	xchain[0] = x0;
  	wchain[0] = wmat[0][0];
	//sampling the proposals and calculating their weights-	parralelised
	for(i=0; i<(T);++i){
		y[i]=gsl_ran_cauchy(r,1);
		w[i]=gsl_ran_gaussian_pdf(y[i],1)/gsl_ran_cauchy_pdf(y[i],1);
	}
	//for each block 
	for(i=0;i<b;++i){
		for(l=0;l<p;++l){
			xprop[l] = y[(i*(p)+l)];
			wprop[l] = w[(i*(p)+l)];
		}
		xstart = xchain[(i*(p))]; 
   		wstart = wchain[(i*(p))];
		for(k=0;k<p;++k){
			//accepting or rejecting the first step
			for(l=0;l<p;++l){
				perm[l] = gsl_rng_uniform_int(r,(p));
			} 
			if(gsl_rng_uniform(r)<=minimum(1,(wprop[perm[0]]/wstart))){
				x[k][(i*(p))+1] = xprop[perm[0]];
				wmat[k][(i*(p))+1] = wprop[perm[0]];
			}
			else{
				x[k][(i*(p))+1] = xstart;
				wmat[k][(i*(p))+1] = wstart;
			}
			//for each column in our block the MC
			for(m=0;m<((p)-1);m++){
				if(gsl_rng_uniform(r)<=minimum(1,(wprop[perm[m+1]]/wmat[k][((i*(p))+1+m)]))){
					x[k][((i*(p))+2+m)] = xprop[perm[m+1]];
					wmat[k][((i*(p))+2+m)] = wprop[perm[m+1]];
				}
				else{
					x[k][((i*(p))+2+m)] = x[k][((i*(p))+1+m)];
					wmat[k][((i*(p))+2+m)] = wmat[k][((i*(p))+1+m)];
				}
			}
		}
		j = gsl_rng_uniform_int(r,(p));
		for(l=0;l<p;l++){
			xchain[((i*(p))+1+l)] = x[j][((i*(p))+1+l)];
			wchain[((i*(p))+1+l)] = wmat[j][((i*(p))+1+l)];
		}
	}
	for(l=0;l<(T+1);l++){
		for(m=0;m<p;m++){
			est += x[m][l];
		}
	}
est /= (T+1)*p;
*pest = est;
}

		

double minimum(double a, double b) {
  double res = (a < b) ? a : b;
  return res;
}


