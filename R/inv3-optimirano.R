##
#G = c(10,20,30,40,50,60,70,80,90,100,150,200,250,
#      300,350,400,500,600,700,800,900,1000,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000,2500,3000)
#V=c()
#for(i in G){ #test skalabilnosti kode, zgleda da raste linearno z n
##

#####inv3

#library(profvis)
#profvis({

#TODO: posplositev povprasevanja, ne samo en dan.. npr. sprememba vsaka 2 dni


require(truncnorm) ##
n = 40 #stobdobij

K = 100  #setup cost (per order)
h = 0.02 #holding cost (per inventory-unit per unit-time)
L = 0   #lead time (in unit-time)
D=1000      # Pricakovana vrednost in std. odklon povpraševanja na enoto èasa
sd1=10  #
p=0.01


n = 80 #st obdobij

K = 300  #setup cost (per order)
h = 0.05 #holding cost (per inventory-unit per unit-time)
L = 3   #lead time (in unit-time)
D=120     # Pricakovana vrednost in std. odklon povpraševanja na enoto èasa
sd1=150  #
p=0.10 #shortage cost
B = 0 #buffer

seme = runif(1,0,1000)

allowshort = F  #dopuscamo nacrtovano pomanjkanje dobrin
prepreci.propad = F #ce mine ves cikel, brez da preckamo RP, naroci na koncu cikla
prepreci.propad2= F #TODO: ce ne zadene RP, doloci kdaj bi jo, naroci vseeno
prednarocila =T #ce L>Le, prvih nekaj obdobij naroci ob fiksnih cas. intervalih (kot da je Y deterministicen)
LE.namesto.L = F #uporabi efektivni lead time - lepsi rezultati ob nestabilnih Y
t0.namesto.RP = F


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

RP = Le*D-short +B#reorder point





set.seed(seme)


#Y = runif(n+1,0,2*D)

#Y = rtruncnorm(n+1,a=0,b=Inf,mean=D,sd=sd1) #ne znam nastavit, E[Y] =/= D
Y = rgamma(n+1,shape=D^2/sd1^2,rate=D/sd1^2)
Y = rpois(n+1,D)
Y = rlnorm(n+1,sdlog=sqrt(log(sd1^2/D^2+1)), meanlog = log(D)-0.5*log(sd1^2/D^2+1)) #tezek tep

X = Y 


A= data.frame()
A[1:(n+1),1] = 0:n
A[1:(n+1),2] = Y
A[1:(n+1),3] = 0
A[1:(n+1),4] = "demand"
A[1,3] = S


#A[1,3] = S #zacetna kolicina
#A[1,4] = "orderU"  



eps1 = 0.00000001 #koliko casa porabimo da odpakramo paket? (razlika orderL orderU)


#ce lead time predolg... prednarocila za prvih # obdobij z pricakovano vrednostjo?


if(prepreci.propad){ ##ce smo v ciklu prejeli novo posiljko PREDEN smo uspeli preckati RP, na silo postavimo narocilo da preprecimo spiralo
  force.order=FALSE
}

if(LE.namesto.L){L = Le}



#opomba: ce pades ful v minus lahk da vec ne preckas RP: TODO

# i = 1
# i = 1
# while(A[i,1]<n){
#   ptm <- proc.time()
#   if(A[i,4]=="orderL"){       #ali smo v orderLOW?
#     
#     if(prepreci.propad){ 
#       if(force.order==TRUE & A[i,1]+L<n){   #ce smo v ciklu prejeli novo posiljko PREDEN smo uspeli preckati RP, na silo postavimo narocilo da preprecimo spiralo pri volatilnih porazd.
#         time = A[i,1]+L
#         print(A[i,1])
#         A <- rbind(A,data.frame(V1 = time-eps1, V2 = 0,V3=0,V4 = "orderL"))
#         A <- rbind(A,data.frame(V1 = time, V2 = 0,V3=0,V4 = "orderU"))
#         A <- A[order(A$V1),]
#       }
#       else{force.order=TRUE}
#     }
#     
#     A[i+1,3] = A[i,3] + yopt
#     i = i +1
#   } 
#   
#   
#   
#   dT = A[i+1,1]-A[i,1] # razlika v casih med tem in naslednjim
#   
#   
#   
#   
#   temp = A[i,3]-dT*A[i+1,2]
#   if(A[i,3] > RP & temp < RP){ #ali prekoracimo reorder point? TUKAJ A[i+1,3] je "to kar bi bila naslednja tocka brez reorderja"
#     time = (RP-A[i,3])*(A[i+1,1]-A[i,1])/(temp-A[i,3]) + A[i,1]+ L #dolocimo cas, ko smo prekoracili reorder point in s tem cas, ko bomo prejeli dobrino (=: time)
#     if(time <n){
#       if(prepreci.propad){force.order=FALSE}
#       
#       A <- rbind(A,data.frame(V1 = time-eps1, V2 = 0,V3=0,V4 = "orderL")) #vstavimo tocki orderL in orderU ter ju umestimo v tabelo glede na cas
#       A <- rbind(A,data.frame(V1 = time, V2 = 0,V3=0,V4 = "orderU"))
#       A <- A[order(A$V1),] #pocasno, optimiraj sort? TODO
#       
#       
#     }
#     
#     dT = A[i+1,1]-A[i,1]
#     
#   }
#   
#   if(A[i+1,4]=="orderL"){ #ce prejmemo posiljko naslednjic
#     A[i+1,3] = A[i,3]-dT*A[i+3,2] #izracun y vrednosti orderU
#   } else {A[i+1,3] = A[i,3]-dT*A[i+1,2]} #izracun y vrednosti naslednje tocke
#   
#   
#   
#   i = i+1
#   #print(proc.time() - ptm)
# }
st.obdobij = L%/%t0

rezerva = 2 #koeficient rezerve: za koliko vecji bo vektor I kot pricakovano
leng = ceiling(n*D*rezerva/yopt)+st.obdobij #dolzina I (I je vektor zaenkrat neznane dolzine, kjer bodo shranjeni skoki)
I = data.frame(rep(n+1,leng),rep(0,leng)) #naredimo prealociran vektor dolzine > n, hitrejsa koda
I[1,] = c(0,S) #
if(t0.namesto.RP)
{
  RP = n*RP
  I[2:leng,1] = t0*1:(leng-1)
}

if(prednarocila & st.obdobij>0){ #vstavimo prednarocila
  
  for(i in 1:st.obdobij){
    I[i+1,1] = t0*i
  }
}

propadi = c()

par=proc.time()
S1=0
S2=0
S3=0
x1 = n+1
ci = 1
while(I[ci,1]<=n){ 
  
  if(I[ci,2]>RP){
    #### dolocimo "would be" presecisce z RP ce na poti ne bi bilo skokov
    a = floor(I[ci,1]) +1 #indeks zadnje spremembe povprasevanja pred trenutnim skokom
    #b = floor(I[ci+1,1]) +1 #indeks zadnje spremembe povprasevanja pred naslednjim skokom
    #if a=b?
    A[a+1,3] = I[ci,2]-A[a,2]*(a-I[ci,1]) #kolicina dobrine v casu t = a
    if(I[ci,2]>=RP & A[a+1,3]<=RP){ #ce je v intervalu sosednjih tock premica RP:
      x = (RP-I[ci,2])*(A[a+1,1]-I[ci,1])/(A[a+1,3]-I[ci,2]) + I[ci,1] # poiscemo presecisce x
      
    }
    
    else{ #sicer se pomaknemo naprej in iscemo presecisce z RP
      i = 2
      par1=proc.time()
      while(T){ #dokler ne najdemo presecisca (ali dosezemo konca simulacije)
        A13= A[a+i-1,3]  #da se izognemo ponavljanju v kodi
        A12= A[a+i-1,2]
        A11 = A[a+i-1,1]
        A23 =  A13-A12
        A[a+i,3] = A23  
        
        if(a+i-1>n){ #ce ne najdemo presecisca, koncamo
          x = n+2
          break
        }
        if(A23<=RP & A13>=RP){ #ce je na intervalu sosednjih tock RP:
          x = (RP-A13)*(A[a+i,1]-A11)/(A23-A13) + A11 #poiscemo x koordinato presecisca
          break
        } else {i=i+1} #sicer se premaknemo na naslednji par tock
      }
      S1 = S1+ proc.time()-par1
    }
    
    ##################
    par2=proc.time()
    if(x<=I[ci+1,1]){   #ce se presecisce pojavi pred naslednjim skokom (potem zares sekamo RP) 
      j=1
      x1 = x
      while(I[ci+j,1]<=n){ #cez koliko skokov pride na vrsto ta skok?
        j = j+1
      }
      S2 = S2+ proc.time()-par2
      I[ci+j,1] = x+L #v urnik skokov dodamo se tega ob casu x+L (takrat prispe narocilo)
    }
  }
  
  #x = (-y1)*(x2-x1)/(y2-y1) + x1
  a = floor(I[ci,1]) +1 #indeks zadnje spremembe povprasevanja pred skokom
  b = floor(I[ci+1,1]) +1 #indeks zadnje spremembe povprasevanja pred naslednjim skokom
  if(a==b){ #to pomeni, da se povprasevanje ne spremeni med skokoma
    yLOW = I[ci,2]-A[a,2]*(I[ci+1,1]-I[ci,1]) #y kordinata naslednjega skoka
    
  }
  else{ #to pomeni, da se vsaj enkrat spremeni povprasevanje med skokoma
    A[a+1,3] = I[ci,2]-A[a,2]*(a-I[ci,1]) #y koordinata naslednje tocke spremembe povprasevanja
    i = 2
    par3=proc.time()
    while(a+i-1<b & a+i-1<=n){ #dokler se imamo tocke med skokoma in nismo na koncu simulacije:
      A[a+i,3] = A[a+i-1,3] - A[a+i-1,2] #dolocimo y koordinate vmesnih tock
      i = i +1
      
    }
    S3 = S3 + proc.time()-par3
    yLOW = A[b,3]-A[b,2]*(I[ci+1,1]-b+1) # dolocimo y koordinato naslednjega skoka s pomocjo prejsnje tocke
    
    
  }
  
  
  
  B=proc.time()-par  
  
  
  I[ci+1,2] = yLOW+yopt #y koordinata zgornjega dela skoka
  if(prepreci.propad & x1<I[ci,1]) {#Ce pr.prop=T in med zadnjima skokoma ni bilo presecisca (x1):
    while(I[ci+j,1]<=n){ #vsilimo narocilo
      j = j+1 #cez koliko skokov pride na vrsto ta skok?
    }
    t = I[ci+1,1]+L
    propadi=append(propadi,t)
    I[ci+j,1] = t 
  }
  
  ci = ci  + 1 #pomaknemo se na naslednji skok
}
eps2 = 0.0001
### zdruzimo in uredimo data frame-a
Itest = I
I = I[I[,1]<n,] #daj <= ce zelis narocat tut cisto na koncu

I[,3] = "orderU"
I[,4] = 0
I=I[,c(1,4,2,3)]
I2 = I
I2[,3] = I2[,3]-yopt
I2[,1] = I2[,1]-eps1
I2[,4] = "orderL"
colnames(I)<-c("V1","V2","V3","V4")
colnames(I2)<-c("V1","V2","V3","V4")
I3=merge(I,I2,all = T)
I3 = I3[-1,]
At = A
A=A[is.na(A[,1])==F,]
A[,1] = A[,1]-eps2
A=merge(I3,A,all = T)
A[A[,4]=="demand",1] = A[A[,4]=="demand",1] + eps2
###

B2 = proc.time()-par



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
    if(y1>0){ #loceno izracunamo pozitivne in negativne ploscine (razlicni stroski)
      x0[j] = (-y1)*(x2-x1)/(y2-y1) + x1 #shranimo nicle
      S.poz[j] = S.poz[j] + abs(y1*(x1-x0[j])/2)
      S.neg[j] = S.neg[j] + abs(y2*(x2-x0[j])/2)
      
    } else{
      S.neg[j] = S.neg[j] + abs(    abs(y2-y1)*abs(x2-x1)/2+abs(x1-x2)*abs(y1)         )
    }
  } 
  if(y2>=0 & y1 >0){
    S.poz[j] = S.poz[j] + abs(  (x2-x1)*(y1-y2)/2+y2*(x2-x1)   )
  }
}   

TC = sum(S.poz)*h+sum(S.neg)*p+(length(I[,1]))*K #skupni stroski
percycle = S.poz*h+S.neg*p + K #vektor stroskov po ciklih



TC #skupni stroski
mean(percycle)
sd(percycle)


B3 = proc.time()-par

doba.prezivetja = max(A[A[,3]>0,1])

summary(percycle)
plot(percycle)
abline(h = mean(percycle))

#plot(x=A[800:1100,1],y=A[800:1100,3],type = "l")
#plot(x=A[8:10,1],y=A[8:10,3],type = "b")
plot(x=A[,1],y=A[,3],type = "l",main=c("st ciklov pred dostavo",st.obdobij)) #zakomentiraj za velike n
abline(h = RP, col = "blue") #modra crta je reorder point
abline(h = 0, col = "red")  #rdeca pa nicla
points(x=propadi,y = rep(RP,length(propadi)),col="red",pch="x") #krizna narocila
#})

##
#V=append(V,B3[3])
#}
#plot(x=G,y=V)
##