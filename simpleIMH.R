serial_IMH<-function(x0,N,pi,mu,samp){
  #preparing where to store inputs and outputs
  x<-rep(0,N+1)
  xstar<-rep(0,N+1)
  wstar<-rep(0,N+1)
  w<-rep(0,N+1)
  alpha<-rep(2,N+1)
  #Initalisation
  alpha[1]<-1
  x[1]<-x0
  w[1]<-pi(x0)/mu(x0)
  xstar[-1]<-samp(N)
  wstar[-1]<-pi(xstar[-1])/mu(xstar[-1])
  for(i in 1:N){
  alpha[i+1]<-min(1,wstar[i+1]/w[i])
  if(runif(1,0,1)<=alpha[i+1]){
    x[(i+1)]<-xstar[i+1]
    w[(i+1)]<-wstar[i+1]
  }
  else{
    x[(i+1)]<-x[i]
    w[(i+1)]<-w[i]
  }
  }
  return(list("X"=x,"alpha"=alpha))
}

test1<-IMH(1,1000,function(x) {dnorm(x,0,1)},function(y) {dnorm(y,0,2)},function(n) {rnorm(n,0,2)})
plot(seq(1,1001),test1$X,type="l")
hist(test1$X)
test1$alpha
