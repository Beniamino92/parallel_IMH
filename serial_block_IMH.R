serial_block_IMH<-function(x0,pi,mu,samp,p,b){
 T<-p*b
  
   #preparing where to store inputs and outputs
  
  #all values used in estimator and corresponding weights
  x<-matrix(10,nrow=p,ncol=T+1)
  wmat<-matrix(100,nrow=p,ncol=T+1)
  #final chain
  xchain<-rep(0,T+1)
  wchain<-rep(0,T+1)
  #proposed values and weights
  y<-rep(0,T)  
  w<-rep(0,T)
  #placeholder for permutation
  perm<-rep(0,p)
  
  #for the individual IMH step
  xprop<-rep(0,p)
  wprop<-rep(0,p)
  
  
  #Initalisation
  x[,1]<-x0
  wmat[,1]<-pi(x0)/mu(x0)
  xchain[1]<-x0
  wchain[1]<-wmat[1,1]
  #sampling and calculating their weights
  y<-samp(T);
  w<-pi(y)/mu(y);
  #for each block
  for(i in 1:b){
    xprop<-y[((i-1)*p+1):(i*p)]
    wprop<-w[((i-1)*p+1):(i*p)]
    xstart<-xchain[((i-1)*p+1)] 
    wstart<-wchain[((i-1)*p+1)]
    #for each row in our block
    for(k in 1:p){
    #accepting or rejecting the first step, constant for every row  
      perm<-sample(1:p,size=p,replace=FALSE)
      if(runif(1,0,1)<=min(1,wprop[perm[1]]/wstart)){
        x[k,((i-1)*p+2)]<-xprop[perm[1]]
        wmat[k,((i-1)*p+2)]<-wprop[perm[1]]
      }
      else{
        x[k,((i-1)*p+2)]<-xstart
        wmat[k,((i-1)*p+2)]<-wstart
      }  
    #for each column in our block i.e our actual markov chain 
      for(m in 1:(p-1)){
        if(runif(1,0,1)<=min(1,wprop[perm[m+1]]/wmat[k,(((i-1)*p+2)+m-1)])){
          x[k,(((i-1)*p+2)+m)]<-xprop[perm[m+1]]
          wmat[k,(((i-1)*p+2)+m)]<-wprop[perm[m+1]]
        }
        else{
          x[k,(((i-1)*p+2)+m)]<-x[k,(((i-1)*p+2)+m-1)]
          wmat[k,(((i-1)*p+2)+m)]<-wmat[k,(((i-1)*p+2)+m-1)]
        }
      }
    }
    j<-sample(1:p,size=1)
    xchain[((i-1)*p+2):((i)*p+1)]<-x[j,(((i-1)*p+2):((i)*p+1))]
    wchain[((i-1)*p+2):((i)*p+1)]<-wmat[j,(((i-1)*p+2):((i)*p+1))]
  }
  return(list("X"=x,"Xchain"=xchain))
}

test2<-serial_block_IMH(0,function(x) {0.3*dnorm(x,0,1)+0.7*dnorm(x,5,1)},
                        function(y) {dcauchy(y)},function(n) {rcauchy(n)},p=100,b=100)
test2$X
plot(seq(1,1001),test2$Xchain,type="l")
mean(test2$X)
hist(test2$Xchain,breaks=30)

system.time(serial_block_IMH(0,function(x) {0.3*dnorm(x,0,1)+0.7*dnorm(x,5,1)},
                             function(y) {dcauchy(y)},function(n) {rcauchy(n)},p=100,b=1000))
