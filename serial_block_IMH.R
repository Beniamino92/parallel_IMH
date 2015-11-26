serial_block_IMH<-function(x0,N,pi,mu,samp,p,b){
  #preparing where to store inputs and outputs
  x<-matrix(10,nrow=p,ncol=N+1)
  w<-matrix(100,nrow=p,ncol=N+1)
  xchain<-rep(0,N+1)
  wchain<-rep(0,N+1)
  xstar<-rep(0,N+1)
  wstar<-rep(0,N+1)
  perm<-rep(0,p)
  xprop<-rep(0,p)
  wprop<-rep(0,p)
  #Initalisation
  x[,1]<-x0
  w[,1]<-pi(x0)/mu(x0)
  xchain[1]<-x0
  wchain[1]<-x0
  #sampling and calculating their weights
  xstar<-samp(N)
  wstar<-pi(xstar)/mu(xstar)
  #for each block
  for(j in 1:b){
    xprop<-xstar[((j-1)*p+1):((j)*p)]
    wprop<-wstar[((j-1)*p+1):((j)*p)]
    xstart<-xchain[((j-1)*p+1)]
    wstart<-wchain[((j-1)*p+1)]
    #for each row in our block
    for(k in 1:p){
    #accepting or rejecting the first step, constant for every row  
      perm<-sample(1:p,size=p,replace=FALSE)
      if(runif(1,0,1)<=min(1,wprop[perm[1]]/wstart)){
        x[k,((j-1)*p+2)]<-xprop[perm[1]]
        w[k,((j-1)*p+2)]<-wprop[perm[1]]
      }
      else{
        x[k,((j-1)*p+2)]<-xstart
        w[k,((j-1)*p+2)]<-wstart
      }  
    #for each collum in our block i.e our actual markov chain 
      for(i in 1:(p-1)){
        if(runif(1,0,1)<=min(1,wprop[perm[i+1]]/w[k,(((j-1)*p+2)+i-1)])){
          x[k,(((j-1)*p+2)+i)]<-xprop[perm[i+1]]
          w[k,(((j-1)*p+2)+i)]<-wprop[perm[i+1]]
        }
        else{
          x[k,(((j-1)*p+2)+i)]<-x[k,(((j-1)*p+2)+i-1)]
          w[k,(((j-1)*p+2)+i)]<-w[k,(((j-1)*p+2)+i-1)]
        }
      }
    }
    l<-sample(1:p,size=1)
    xchain[((j-1)*p+2):((j)*p+1)]<-x[l,(((j-1)*p+2):((j)*p+1))]
    wchain[((j-1)*p+2):((j)*p+1)]<-w[l,(((j-1)*p+2):((j)*p+1))]
  }
  return(list("X"=x,"Xchain"=xchain))
}

test2<-serial_block_IMH(1,N=1000,function(x) {dnorm(x,0,1)},function(y) {dnorm(y,0,2)},function(n) {rnorm(n,0,2)},p=100,b=10)
test2$X
plot(seq(1,1001),test2$Xchain,type="l")
sum(test2$X)
