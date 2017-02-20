#definiramo funkcijo, ki vrne tocke za optimalno strategijo:
dynamic <- function(n,K,h,r){
  #matrika C bo predstavljala matriko stroskov po obdobjih 
  #glede na to kdaj in koliko narocimo v prihodnjih obdobjih
  C = matrix(Inf, nrow=n, ncol=n) 
  c.min = rep(0,n+1) #vektor minimumov po obdobjih
  
  #definiramo pomozno funkcijo, ki jo bomo uporabili v formuli za racunanje stroskov: 
  vsota <- function(i,j){ 
    if (i==j){
      S = 0
    }
    else{
      S = 0
      for (k in (i+1):j){
        S = S + (k-i)*r[k]
      }
    }  
    S
  }
  
  # stolpci v matriki C predstavljajo obdobja,
  # vrstice v matriki C pa izbire kdaj bomo izvedli naslednje narocilo 
  for (i in n:1){
    for (j in i:n){
      # po rekurzivni zvezi racunamo stroske za vsako obdobje in vsako strategijo
      C[j,i] = c.min[j+1] + K + h*vsota(i,j) 
    }
    c.min[i] = min(C[,i])
  }
  
  #strategija, ki ima minimalne stroske:
  opt.stroski = c.min[1] 
  
  #zanima nas, kje so minimumi:
  c.opt = rep(F, n)
  c.opt[1] = T
  i = 1
  
  while (i < n){
  #iscemo indeks vrstice, kjer se nahaja minimum v stolpcu:
    i = which.min(C[,i]) + 1  
    c.opt[i] = T
  }
  c.opt
  #vektor koordinat optimalne poti
  #(zacnemo na koncu poti)
  P = c(n,0)
  
  for (i in n:1){
    if (i == n ) {
      r.i = r[i]
    }
    else{
      for (j in (i+1):(n+1)) {
        if (c.opt[j] == T) {
          break
        } 
      }
      r.i = sum(r[i:(j-1)])
    }
    
    P = append(c(i-1,r.i), P)
    
    if (c.opt[i] == T) {
      P = append(c(i-1,0), P)
    }
  }
  
  x = c()
  y = c()
  for (i in 1:(length(P))) {
    if (i%%2 == 1) {
      x = append(x, c(P[i]))
    }
    else {
      y = append(y, c(P[i]))
    }
  }
  
  
  p = data.frame(x,y)
  ## pomozen del za simulacijo
  d = c(F)
  for(i in 2:length(p[,1])){ 
    if(p[i,1]-p[i-1,1]==0){
      d[i] = T
    } else {d[i] = F}
  }
  ##
  
  return(list(p,p[d,]))
}

#1.primer:
# n = 4       #stevilo obdobij
# D = 10      #povprasevanje
# h = 0.2     #holding cost
# K = 2       #setup cost
# r = c(3,2,3,2)   # vektor povprasevanj

#2.primer:
n = 45 
K = 5  
h = 0.02 
D = 150     
sd = 10 
r = runif(n,0,D*2)
r=rep(D,n)
tocke = dynamic(n,K,h,r)
plot(tocke[[1]], type="l", xlab = "obdobja", ylab ="inventar",
     main = "Optimalna strategija")

casi = c()
N = seq(10, 100, 10)
# for (i in 1:length(N)) {
#   n = N[i]
#   print(n)
#   cas.zacetek = proc.time()
#   r = rnorm(n, mean = D, sd = sd)
#   tocke = dynamic(n,K,h,r)
#   cas.konec = proc.time() - cas.zacetek
#   #3. element vektorja proc.time je skupni čas izvajanja:
#   cas.konec = cas.konec[3] 
#   casi = append(casi, cas.konec)
#  plot(tocke, type="l")
#}  

#plot( x = N, y = casi, xlab = "število obdobij", ylab = "sekunde",
#      main = "Čas izvajanja glede na število obdobij")