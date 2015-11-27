#include<stdio.h>
#include<gsl/gsl_rng.h>
#include<gsl/gsl_randist.h>
// gcc -I/usr/local/include -L/usr/local/lib serial_Block_IMH.c -o BlockIMH -lgsl -lgslcblas -lm 
// doesn't run mix up with pointers 

// for R verion will need to input double* X an double* est
// double* 

double serial_block_IMH(double x0,int T,int p,int b)
{
	//creating memory for random number generation 
	const gsl_rng_type* N;
	gsl_rng* r;

	N = gsl_rng_default;
	r = gsl_rng_alloc(N);
	
	
	double minimum(double a, double b);

	//all values used for the estimator
	double x[p][((T)+1)];
	double wmat[p][((T)+1)];
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
	double est=0;
	// initialisation
	for(i=0; i<p;++i){
		x[i][0]=x0; 
		wmat[i][0]=gsl_ran_gaussian_pdf(x0,1)/gsl_ran_cauchy_pdf(x0,1);
	}
	xchain[0] = x0;
  	wchain[0] = wmat[0][0];
	printf("x0=%f , wchain=%f,wmat=%f\n",xchain[0],wchain[0],wmat[2][0]);
	//sampling the proposals and calculating their weights-	parralelised
	for(i=0; i<(T);++i){
		y[i]=gsl_ran_cauchy(r,1);
		w[i]=gsl_ran_gaussian_pdf(y[i],1)/gsl_ran_cauchy_pdf(y[i],1);
	printf("y[%i]=%f , w[%i]=%f\n",i,y[i],i,w[i]);	
	}
	//for each block 
	for(i=0;i<b;++i){
		for(l=0;l<p;++l){
			xprop[l] = y[(i*(p)+l)];
			wprop[l] = w[(i*(p)+l)];
		printf("xprop[%i]=%f, wprop[%i]=%f\n",l,xprop[l],l,wprop[l]);
		}
		xstart = xchain[(i*(p))]; 
   		wstart = wchain[(i*(p))];
		for(k=0;k<p;++k){
			//accepting or rejecting the first step
			for(l=0;l<p;++l){
				perm[l] = gsl_rng_uniform_int(r,(p));
			printf("perm[%i}=%i\n",l,perm[l]);
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
			printf("X[%i][%i] is %f, W[%i][%i] is %f \n",m,l,x[m][l],m,l,wmat[m][l]);
			est += x[m][l];
		}
	}
	printf("The estime is %f\n", est/((T+1)*p));
	return 0;

}

int main(void)
{
double serial_block_IMH(double x0,int T,int p,int b);
double minimum(double a, double b);
int uniform_distribution(int rangeLow, int rangeHigh);
serial_block_IMH(1.0,1000,20,50);
}



		

double minimum(double a, double b) {
  double res = (a < b) ? a : b;
  return res;
}


