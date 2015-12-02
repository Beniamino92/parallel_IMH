// export PATH=~/Downloads/ispc-v1.8.2-linux:$PATH
// ispc -O3 --arch=x86-64 --target=avx acc_rej_acc.ispc -o acc_rej_acc.o -h acc_rej_acc.h
// i in 1:8 or 1:4 depending on vectors the system allows 
export void acc_rej_ispc_start(uniform size_t p, uniform double x_mat[], uniform
			       double w_mat[],
			 uniform double x_prop[],  uniform double w_prop[],
			 uniform double x_start,  uniform double w_start,
			 uniform int perm[], uniform size_t k_)
{
  struct RNGState r;
  seed_rng(&r,10);
  
    foreach(i = 0 ... k_)
    {
      if (frandom(&r) <= min((float) 1, (w_prop[perm[0+p*i]]/w_start))) {
          x_mat[1+p*i] = x_prop[perm[0+p*i]];
	  w_mat[1+p*i] = w_prop[perm[0+p*i]];
      }
      else {
	  x_mat[1+p*i] = x_start;
	  w_mat[1+p*i] = w_start;
      }
    }
}

   
  
  
    
