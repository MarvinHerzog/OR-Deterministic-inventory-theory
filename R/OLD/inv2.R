library(distr)
#inv2
#14.3.2


h=1 #holding cost
p=10 #penalty
alp = 0.9
r = 10 #revenue
c = 8 #cost



#random vektor - metropolis-hastings?






P = (p+(1-alp)*(r-c)) / (p+h+(1-alp)*r)

f <- function(D) (D >= 0 & D <=5) * 0.08*D
a = 0
b= 5
Fx <- function(y) integrate( f, 0, y )$value-P
Nsol=uniroot( Fx, c(a, b) ) # Look for a solution in [-1,1]
yopt = Nsol$root
#Vectorize(Fx) - sprejema vektor kot argument





p    <- function(x) (2/pi) * (1/(exp(x)+exp(-x)))  # probability density function
dist <-AbscontDistribution(d=f)  # signature for a dist with pdf ~ p
rdist <- r(dist)   

Y=rdist(1000) #random vektor




x0 = 0

x = x0
if x< yopt{
  
}

