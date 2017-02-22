#inv3


n = 80 #stobdobij

K = 100  #setup cost (per order)
h = 0.02 #holding cost (per inventory-unit per unit-time)
L = 16   #lead time (in unit-time)
D=100      # Pricakovana vrednost in std. odklon povpraševanja na enoto èasa
sd1=10  #
p=0.01

n = 80 #stobdobij

K = 12000  #setup cost (per order)
h = 0.30 #holding cost (per inventory-unit per unit-time)
L = 0.01   #lead time (in unit-time)
D=8000     # Pricakovana vrednost in std. odklon povpraševanja na enoto èasa
sd1=10  #
p=1.10



allowshort = TRUE


if(allowshort==TRUE){
  SHT = sqrt((p+h)/p) #faktor za shortage cost, ce ne dopuscamo, potem nastavi na 1
} else{SHT = 1}

yopt = sqrt((2*K*D)/h)*SHT #kolicina, ki jo narocimo
S = yopt/SHT^2 #pozitiven del naroèila
short=yopt-S #shortage v enotah

t0 = yopt/D            #dolzina cikla

Le = L%%t0 #effective lead time
EX = D*Le           # Upanje in std. odklon povpraševanja med Le
SD = sqrt(sd1^2*Le) #

RP = Le*D-short #reorder point







#Y = runif(n,0,200)
Y = rnorm(n,8000,0)
X = Y 


A= data.frame()
A[1:(n+1),1] = 0:n
A[1:(n+1),2] = c(0,Y)
A[1:(n+1),3] = 0
A[1:(n+1),4] = "demand"


A[1,3] = S #zacetna kolicina
A[1,4] = "orderU"  



eps1 = 0.001 #koliko casa porabimo da odpakramo paket? (razlika orderL orderU)


prepreci.propad = F
prednarocila =F
LE.namesto.L = F

#ce lead time predolg... prednarocila za prvih # obdobij z pricakovano vrednostjo?


if(prepreci.propad){ ##ce smo v ciklu prejeli novo posiljko PREDEN smo uspeli preckati RP, na silo postavimo narocilo da preprecimo spiralo
  force.order=FALSE
}

if(LE.namesto.L){L = Le}

st.obdobij = L%/%t0
if(prednarocila & st.obdobij>0){

  for(i in 1:st.obdobij){
    A <- rbind(A,data.frame(V1 = i*t0-eps1, V2 = 0,V3=0,V4 = "orderL"))
    A <- rbind(A,data.frame(V1 = i*t0, V2 = 0,V3=0,V4 = "orderU"))
    A <- A[order(A$V1),]
  }
}


#opomba: ce pades ful v minus lahk da vec ne preckas RP: TODO

i = 1
while(A[i,1]<n){
  ptm <- proc.time()
  if(A[i,4]=="orderL"){       #ali smo v orderLOW?
    
    if(prepreci.propad){ 
      if(force.order==TRUE & A[i,1]+L<n){   #ce smo v ciklu prejeli novo posiljko PREDEN smo uspeli preckati RP, na silo postavimo narocilo da preprecimo spiralo pri volatilnih porazd.
        time = A[i,1]+L
        print(A[i,1])
        A <- rbind(A,data.frame(V1 = time-eps1, V2 = 0,V3=0,V4 = "orderL"))
        A <- rbind(A,data.frame(V1 = time, V2 = 0,V3=0,V4 = "orderU"))
        A <- A[order(A$V1),]
      }
      else{force.order=TRUE}
    }
    
    A[i+1,3] = A[i,3] + yopt
    i = i +1
  } 


  
  dT = A[i+1,1]-A[i,1] # razlika v casih med tem in naslednjim
  

   
  
   temp = A[i,3]-dT*A[i+1,2]
   if(A[i,3] > RP & temp < RP){ #ali prekoracimo reorder point? TUKAJ A[i+1,3] je "to kar bi bila naslednja tocka brez reorderja"
     time = (RP-A[i,3])*(A[i+1,1]-A[i,1])/(temp-A[i,3]) + A[i,1]+ L #dolocimo cas, ko smo prekoracili reorder point in s tem cas, ko bomo prejeli dobrino (=: time)
     if(time <n){
       if(prepreci.propad){force.order=FALSE}
       
       A <- rbind(A,data.frame(V1 = time-eps1, V2 = 0,V3=0,V4 = "orderL")) #vstavimo tocki orderL in orderU ter ju umestimo v tabelo glede na cas
       A <- rbind(A,data.frame(V1 = time, V2 = 0,V3=0,V4 = "orderU"))
       A <- A[order(A$V1),] #pocasno, optimiraj sort? TODO
      
       
     }

     dT = A[i+1,1]-A[i,1]
     
   }
   
   if(A[i+1,4]=="orderL"){ #ce prejmemo posiljko naslednjic
     A[i+1,3] = A[i,3]-dT*A[i+3,2] #izracun y vrednosti orderU
   } else {A[i+1,3] = A[i,3]-dT*A[i+1,2]} #izracun y vrednosti naslednje tocke
   
   
  
  i = i+1
  #print(proc.time() - ptm)
}






S.poz = c() #vektor pozitivnih ploscin na cikel
S.neg = S.poz #vektor negativnih ploscin na cikel
x0 = S.poz #vektor nicel (brez nicle ob narocilu)
#stroški
j = 0
for(i in 1:(length(A[,1])-1)){
  if(A[i,4] =="orderU"){
    j=j+1
    S.poz[j] = 0
    S.neg[j] = 0
    x0[j] = 0
    } #ce smo v orderU zacnemo merit stroske novega cikla
  x1 = A[i,1]
  x2 = A[i+1,1]
  y1 = A[i,3]
  y2 = A[i+1,3]
  if(y2<0){
    if(y1>0){
      x0[j] = (-y1)*(x2-x1)/(y2-y1) + x1 #shrani nicle za risanje?
      S.poz[j] = S.poz[j] + abs(y1*(x1-x0[j])/2)
      S.neg[j] = S.neg[j] + abs(y2*(x2-x0[j])/2)
      
    } else{
      S.neg[j] = S.neg[j] + abs(    (y2-y1)*(x2-x1)/2+(x1-x2)*y1         )
    }
  } 
  if(y2>0 & y1 >0){
    S.poz[j] = S.poz[j] + abs(  (x2-x1)*(y1-y2)/2+y2*(x2-x1)   )
  }
}   

TC = sum(S.poz)*h+sum(S.neg)*p+j*K
percycle = S.poz*h+S.neg*p + K


plot(x=A[8:10,1],y=A[8:10,3],type = "b")
plot(x=A[,1],y=A[,3],type = "l")
abline(h = RP, col = "blue")
abline(h = 0, col = "red")

TC
mean(percycle)