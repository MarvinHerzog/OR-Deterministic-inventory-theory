


#####inv3

skal = 0

### test skalabilnosti kode, zgleda da raste linearno z n
### odkomentiraj ta del, ter del na koncu kode
# G = c(10,20,30,40,50,60,70,80,90,100,150,200,250,
#      300,350,400,500,600,700,800,900,1000,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000,2500,3000,3500,4000,4500,5000)
# V=c()
# for(skal in G){
###
###


#require(truncnorm) ##
#n = 40 #stobdobij

#V datoteki zgledi so poucni primeri za naslednje paramtere
n = 30 #st obdobij
K = 50  #setup cost (per order)
h = 0.05 #holding cost (per inventory-unit per unit-time)
L = 2   #lead time (in unit-time)
D = 150     # Pricakovana vrednost povprasevanja na enoto casa
sd1 = 50 #Standardni odklon povprasevanja na enoto casa
p = 0.10 #shortage cost (ce smo pod y=0)
B = 0 #buffer, tj. varnostni dodatek k RP. Za zeljeno verjetnost, da pademo pod y=0, uporabi formulo B=VaR - Le *D (VaR value at risk za dano porazdelitev)
RP.force = NA #sami izberemo reorder point (sicer nastavi na NA)
yopt.force = NA #sami izberemo kolicino, ki jo narocimo (sicer nastavi na NA)
r = NA #ce zelis vstaviti svoj vektor povprasevanj, sicer pusti na NA (po default vzame rep(D,n) )
korak = 0.005 # inkrement v zanki za testiranje stroskov, ce je korak npr 0.005, potem nastavimo zeljeno spremenljivko na 100%, 99.5%, 100.5%, 99%, 101% itd.
stkor = 250 #zgornjih tock je stkor mnogo
#seme = runif(1,0,1000)
seme = 55

allowshort = T  #dopuscamo nacrtovano pomanjkanje dobrin
prepreci.propad1 = F #ce mine ves cikel, brez da preckamo RP, naroci na koncu cikla
prepreci.propad2 = F #ce smo po skoku se vedno pod RP, naroci taksno narocilo, da bo ob upostevanju vseh prihodnih skokov vrednost zalog na S
prednarocila = T #ce L>Le, prvih nekaj obdobij naroci ob fiksnih cas. intervalih (kot da je Y deterministicen)
LE.namesto.L = F #uporabi efektivni lead time - lepsi rezultati ob nestabilnih Y, ni pa realisticno
t0.namesto.RP = F #naroci periodicno z t0 namesto po preckanju RP
TCtest = F #total cost test, nastavi na F ce noces testirat, sicer izberi parameter ki ga hoces perturbirat (npr "RP") . V if-u spodaj spremeni korak in st. korakov
DP = F #Simulacija rezultata dobljenega z dinamicnim programiranjem, PAZI: izklopi propad2 ter allowshort!
pikice = T #prikazujemo tocke spremembe povprasevanja ter skoke?

TCv = c() #Vektor celotnih stroskov (za TCtest=T)
zaporedje = 1
stskokov = c() #Stevilo skokov (skoki so tocke, kjer prejmemo dobrino)
if (TCtest != F) {
  sprem = get(TCtest)
  yopt = 1
  RP = 1
  zaporedje = c(seq(1 - floor(stkor / 2) * korak, 1 - korak, korak),seq(1,1 +
                                                                          (ceiling(stkor / 2) - 1) * korak,korak))
  #zaporedje = seq(1,1+(ceiling(stkor/2)-1)*korak,korak)
}


for (ind in zaporedje) {
  if (TCtest != F) {
    assign(TCtest,sprem * ind)
  }
  
  
  ##### Optimalna strategija, dobljena preko dinamicnega programiranja
  #####
  dynamic <- function(n,K,h,r) {
    #matrika C bo predstavljala matriko stroskov po obdobjih
    #glede na to kdaj in koliko narocimo v prihodnjih obdobjih
    C = matrix(Inf, nrow = n, ncol = n)
    c.min = rep(0,n + 1) #vektor minimumov po obdobjih
    
    #definiramo pomozno funkcijo, ki jo bomo uporabili v formuli za racunanje stroskov:
    vsota <- function(i,j) {
      if (i == j) {
        S = 0
      }
      else{
        S = 0
        for (k in (i + 1):j) {
          S = S + (k - i) * r[k]
        }
      }
      S
    }
    
    # stolpci v matriki C predstavljajo obdobja,
    # vrstice v matriki C pa izbire kdaj bomo izvedli naslednje narocilo
    for (i in n:1) {
      for (j in i:n) {
        # po rekurzivni zvezi racunamo stroske za vsako obdobje in vsako strategijo
        C[j,i] = c.min[j + 1] + K + h * vsota(i,j)
      }
      c.min[i] = min(C[,i])
    }
    
    #strategija, ki ima minimalne stroske:
    opt.stroski = c.min[1]
    
    #zanima nas, kje so minimumi:
    c.opt = rep(F, n)
    c.opt[1] = T
    i = 1
    
    while (i < n) {
      #iscemo indeks vrstice, kjer se nahaja minimum v stolpcu:
      i = which.min(C[,i]) + 1
      c.opt[i] = T
    }
    c.opt
    #vektor koordinat optimalne poti
    #(zacnemo na koncu poti)
    P = c(n,0)
    
    for (i in n:1) {
      if (i == n) {
        r.i = r[i]
      }
      else{
        for (j in (i + 1):(n + 1)) {
          if (c.opt[j] == T) {
            break
          }
        }
        r.i = sum(r[i:(j - 1)])
      }
      
      P = append(c(i - 1,r.i), P)
      
      if (c.opt[i] == T) {
        P = append(c(i - 1,0), P)
      }
    }
    
    x = c()
    y = c()
    for (i in 1:(length(P))) {
      if (i %% 2 == 1) {
        x = append(x, c(P[i]))
      }
      else {
        y = append(y, c(P[i]))
      }
    }
    
    
    p = data.frame(x,y)
    ## pomozen del za simulacijo
    d = c(F)
    for (i in 2:length(p[,1])) {
      if (p[i,1] - p[i - 1,1] == 0) {
        d[i] = T
      } else {
        d[i] = F
      }
    }
    ##
    
    return(list(p,p[d,]))
  }
  ### konec DP
  ###
  
  
  
  if (allowshort == TRUE) {
    SHT = sqrt((p + h) / p) #faktor za shortage cost, ce ne dopuscamo, potem nastavi na 1
  } else{
    SHT = 1
  }
  
  if (skal != 0) {
    n = skal
  } #ce testiramo skalabilnost kode
  
  
  if (!is.na(r[1])) {
    D = mean(r)
  }
  
  #### Tu izracunamo optimalna yopt/RP glede na ostale parametre
  ####
  yopt = sqrt((2 * K * D) / h) * SHT #kolicina, ki jo narocimo
  if (!is.na(yopt.force)) {
    #ce ignoriramo formulo zgoraj
    yopt = yopt.force
  }
  if (TCtest == "yopt") {
    yopt = ind * yopt
  }
  
  S = yopt / SHT ^ 2 #pozitiven del narocila
  short = yopt - S #shortage v enotah
  t0 = yopt / D            #dolzina cikla
  Le = L %% t0 #effective lead time

  RP = Le * D - short + B #reorder point
  
  if (!is.na(RP.force)) {
    RP = RP.force
  }
  if (TCtest == "RP") {
    RP = ind * RP
  }
  ####
  ####
  
  
  
  
  
  
  
  
  
  
  #### Generiramo nakljucni vektor povprasevanj ter pomozne
  #### data.frame za skoke (ko prejmemo narocila) -> I, ter tocke, kjer se menja povprasevanje -> A
  
  set.seed(seme)
  
  
  #Y = runif(n+1,0,2*D)
  #Y = rtruncnorm(n+1,a=0,b=Inf,mean=D,sd=sd1) #ne znam nastavit, E[Y] =/= D
  #Y = rgamma(n + 1,shape = D ^ 2 / sd1 ^ 2,rate = D / sd1 ^ 2)
  #Y = rpois(n + 1,D)
  Y = rlnorm(n + 1,sdlog = sqrt(log(sd1 ^ 2 / D ^ 2 + 1)), meanlog = log(D) -
               0.5 * log(sd1 ^ 2 / D ^ 2 + 1)) #tezek tep

  
  if (DP) {
    #Ce sledimo strategiji iz dinamicnega programiranja
    if (is.na(r[1])) {
      r = rep(D,n)
    }
    tocke = dynamic(n,K,h,r)
    Y = c(r,0)
    S = tocke[[2]][1,2]
  }
  
  
  A = data.frame() #data frame povprasevanja skozi obdobja
  A[1:(n + 1),1] = 0:n
  A[1:(n + 1),2] = Y
  A[1:(n + 1),3] = 0
  A[1:(n + 1),4] = "demand"
  A[1,3] = S #zacetno narocilo
  
  
  
  eps1 = 0.00000001 #koliko casa porabimo da odpakramo paket? (razlika orderL orderU)
  
  
  
  if (LE.namesto.L) {
    L = Le
  }
  
  
  #data frame I deluje kot prioritetna vrsta za vsa prihodnja narocila
  st.obdobij = L %/% t0
  
  rezerva = 2 #koeficient rezerve: za koliko vecji bo vektor I kot pricakovano
  leng = ceiling(n * D * rezerva / yopt) + st.obdobij #dolzina I (I je vektor zaenkrat neznane dolzine, kjer bodo shranjeni skoki)
  I = data.frame(rep(n + 1,leng),rep(0,leng),rep(yopt,leng)) #naredimo prealociran vektor dolzine > n, hitrejsa koda kot ce ga sproti povecujemo
  I[1,] = c(0,S,yopt) #zacetno narocilo
  
  if (t0.namesto.RP)
    #ce narocujemo periodicno z t0 namesto ob preckanju RP
  {
    RP = n * RP
    I[2:leng,1] = t0 * 1:(leng - 1)
  }
  
  if (prednarocila &
      st.obdobij > 0) {
    #vstavimo prednarocila (narocila postavljena v negativnih casih)
    
    
    for (i in 1:st.obdobij) {
      I[i + 1,1] = t0 * i
    }
  }
  
  
  
  if (DP) {
    RP = Inf
    I[1:length(tocke[[2]][,1]),1] = tocke[[2]][,1]
    I[1:length(tocke[[2]][,2]),3] = tocke[[2]][,2]
    
  }
  
  
  propadi = c()
  propadi2 = c()
  
  par = proc.time()
  S1 = 0
  S2 = 0
  S3 = 0
  x1 = -1
  ze.reseno = F
  cassupernarocilo = F
  
  ## glavna zanka
  ##
  ci = 1
  while (I[ci,1] <= n) {
    if (I[ci,2] > RP) {
      #### dolocimo "would be" presecisce z RP ce na poti ne bi bilo skokov
      a = floor(I[ci,1]) + 1 #indeks zadnje spremembe povprasevanja pred trenutnim skokom
      A[a + 1,3] = I[ci,2] - A[a,2] * (a - I[ci,1]) #kolicina dobrine v casu t = a
      if (I[ci,2] >= RP &
          A[a + 1,3] <= RP) {
        #ce je v intervalu sosednjih tock premica RP:
        x = (RP - I[ci,2]) * (A[a + 1,1] - I[ci,1]) / (A[a + 1,3] - I[ci,2]) + I[ci,1] # poiscemo presecisce x
        
      }
      
      else{
        #sicer se pomaknemo naprej in iscemo presecisce z RP
        i = 2
        par1 = proc.time()
        while (T) {
          #dokler ne najdemo presecisca (ali dosezemo konca simulacije)
          A13 = A[a + i - 1,3]  #da se izognemo ponavljanju v kodi
          A12 = A[a + i - 1,2]
          A11 = A[a + i - 1,1]
          A23 =  A13 - A12
          A[a + i,3] = A23
          
          if (a + i - 1 > n) {
            #ce ne najdemo presecisca, koncamo
            x = n + 2
            break
          }
          if (A23 <= RP &
              A13 >= RP) {
            #ce je na intervalu sosednjih tock RP:
            x = (RP - A13) * (A[a + i,1] - A11) / (A23 - A13) + A11 #poiscemo x koordinato presecisca
            break
          } else {
            i = i + 1
          } #sicer se premaknemo na naslednji par tock
        }
        S1 = S1 + proc.time() - par1
      }
      
      ##################
      par2 = proc.time()
      if (x <= I[ci + 1,1]) {
        #ce se presecisce pojavi pred naslednjim skokom (potem zares sekamo RP)
        j = 1
        x1 = x
        while (I[ci + j,1] <= n) {
          #cez koliko skokov pride na vrsto ta skok?
          j = j + 1
        }
        S2 = S2 + proc.time() - par2
        I[ci + j,1] = x + L #v urnik skokov dodamo se tega ob casu x+L (takrat prispe narocilo)
      }
    }
    
    #x = (-y1)*(x2-x1)/(y2-y1) + x1 -> formula za presecisce
    a = floor(I[ci,1]) + 1 #indeks zadnje spremembe povprasevanja pred skokom
    b = floor(I[ci + 1,1]) + 1 #indeks zadnje spremembe povprasevanja pred naslednjim skokom
    if (a == b) {
      #to pomeni, da se povprasevanje ne spremeni med skokoma
      yLOW = I[ci,2] - A[a,2] * (I[ci + 1,1] - I[ci,1]) #y kordinata naslednjega skoka (spodnji del skoka)
      
    }
    else{
      #to pomeni, da se vsaj enkrat spremeni povprasevanje med skokoma
      A[a + 1,3] = I[ci,2] - A[a,2] * (a - I[ci,1]) #y koordinata naslednje tocke spremembe povprasevanja
      i = 2
      par3 = proc.time()
      while (a + i - 1 < b &
             #dokler se imamo tocke med skokoma in nismo na koncu simulacije:
             a + i - 1 <= n) {
        A[a + i,3] = A[a + i - 1,3] - A[a + i - 1,2] #dolocimo y koordinate vmesnih tock
        i = i + 1
        
      }
      S3 = S3 + proc.time() - par3
      yLOW = A[b,3] - A[b,2] * (I[ci + 1,1] - b + 1) # dolocimo y koordinato naslednjega skoka s pomocjo prejsnje tocke (spodnji del skoka)
      
      
    }
    
    
    
    B1 = proc.time() - par
    
    
    
    if (ci + 1 == cassupernarocilo) {
      ze.reseno = F
      I[ci + 1,2] = yLOW + I[ci + 1,3]
    } else {
      I[ci + 1,2] = yLOW + I[ci + 1,3] #y koordinata zgornjega dela skoka
    }
    if ((prepreci.propad1 | prepreci.propad2) &
        !is.na(I[ci + 1,2])) {
      #Ce pr.prop=T in med zadnjima skokoma ni bilo presecisca RP (x1) ALI:
      j = 1
      if (prepreci.propad1 & x1 < I[ci,1]) {
        while (I[ci + j,1] <= n) {
          #vsilimo narocilo
          j = j + 1 #cez koliko skokov pride na vrsto ta skok?
        }
        t = I[ci + 1,1] + L
        propadi = append(propadi,t)
        I[ci + j,1] = t
      }
      j1 = 1
      if (prepreci.propad2 & I[ci + 1,2] < RP &
          ze.reseno == F) {
        #ce smo po skoku se vedno pod RP
        while (I[ci + j1,1] <= n) {
          #vsilimo super narocilo
          j1 = j1 + 1 #cez koliko skokov pride na vrsto ta skok?
        }
        t = I[ci + 1,1] + L
        # propadi = append(propadi,t)
        I[ci + j1,1] = t
        cassupernarocilo = ci + j1
        propadi2 = append(propadi2,t)
        I[ci + j1,3] = S + abs(I[ci + 1,2] - L * D + (j1 - 2) * yopt)
        ze.reseno = T #dokler cakamo na supernarocilo ne postavljamo novih
        x1 = t
      }
    }
    
    ci = ci  + 1 #pomaknemo se na naslednji skok
  }
  eps2 = 0.00000000001
  ### zdruzimo in uredimo data frame-a
  Itest = I
  I = I[I[,1] < n,] #daj <= ce zelis narocat tut cisto na koncu
  I = I[,c(1,3,2)]
  I[,4] = "orderU"
  I2 = I
  I2[,3] = I2[,3] - I[,2]
  I2[,1] = I2[,1] - eps1
  I2[,4] = "orderL"
  colnames(I) <- c("V1","V2","V3","V4")
  colnames(I2) <- c("V1","V2","V3","V4")
  I3 = merge(I,I2,all = T)
  I3 = I3[-1,]
  At = A
  A = A[is.na(A[,1]) == F,]
  A[,1] = A[,1] - eps2
  A = merge(I3,A,all = T)
  A[A[,4] == "demand",1] = A[A[,4] == "demand",1] + eps2
  A = A[is.na(A[,1]) == F,]
  colnames(A) <- c("x","sprememba","y","tip")
  ###
  
  B2 = proc.time() - par
  
  
  ##### Izracun stroskov
  #####
  ## V naslednjem delu izracunamo ploscino pod grafom nad abciso (S.poz) ter pod njo (S.neg) za vsak cikel,
  ## skupen strosek je (sestevek pozitivnih ploscin)*(holding cost)+(sestevek negativnih ploscin)*(shortage cost)+(setup cost)*(st. narocil)
  
  
  S.poz = c() #vektor pozitivnih ploscin na cikel
  S.neg = S.poz #vektor negativnih ploscin na cikel
  x0 = S.poz #vektor nicel (brez nicle ob narocilu)
  #stroski
  j = 0
  for (i in 1:(length(A[,1]) - 1)) {
    if (A[i,4] == "orderU") {
      j = j + 1
      S.poz[j] = 0
      S.neg[j] = 0
      x0[j] = 0
    } #ce smo v orderU zacnemo merit stroske novega cikla
    x1 = A[i,1]
    x2 = A[i + 1,1]
    y1 = A[i,3]
    y2 = A[i + 1,3]
    if (y2 < 0) {
      if (y1 > 0) {
        #loceno izracunamo pozitivne in negativne ploscine (razlicni stroski)
        x0[j] = (-y1) * (x2 - x1) / (y2 - y1) + x1 #shranimo nicle
        S.poz[j] = S.poz[j] + abs(y1 * (x1 - x0[j]) / 2)
        S.neg[j] = S.neg[j] + abs(y2 * (x2 - x0[j]) / 2)
        
      } else{
        S.neg[j] = S.neg[j] + abs(abs(y2 - y1) * abs(x2 - x1) / 2 + abs(x1 - x2) *
                                    abs(y1))
      }
    }
    if (y2 >= 0 & y1 > 0) {
      S.poz[j] = S.poz[j] + abs((x2 - x1) * (y1 - y2) / 2 + y2 * (x2 - x1))
    }
  }
  
  TC = sum(S.poz) * h + sum(S.neg) * p + (length(I[,1])) * K #skupni stroski
  percycle = S.poz * h + S.neg * p + K #vektor stroskov po ciklih
  
  
  
  #TC #skupni stroski
  #mean(percycle)
  #sd(percycle)
  ####
  ####
  
  
  stskokov = append(stskokov,length(I[,1])) #stevilo skokov v simulaciji
  B3 = proc.time() - par
  
  doba.prezivetja = max(A[A[,3] > 0,1]) #vsaj toliko obdobij smo preziveli brez propada
  TCv = append(TCv,TC)
  
  if (ind == 1) {
    TCdef = TC
  }
  #TCv = append(TCv,sum(S.poz) * h)
}

#### konec zanke skalabilnosti
# V=append(V,B3[3])
# }
# plot(x=G,y=V)
# abline(lm(V ~ G))
####




summary(percycle)


#plot(percycle)
#abline(h = mean(percycle))


plot(
  x = A[,1],y = A[,3],type = "l",main = c("st ciklov pred dostavo",st.obdobij),xlab =
    "Obdobja",ylab = "Inventar"
) #zakomentiraj za velike n

abline(h = RP, col = "blue") #modra crta je reorder point
abline(h = 0, col = "red")  #rdeca pa nicla
points(
  x = propadi,y = rep(RP,length(propadi)),col = "green",pch = "x"
) #krizna narocila
points(
  x = propadi2,y = rep(RP,length(propadi2)),col = "red",pch = "x"
  
) #krizna narocila

if (pikice) {
  points(
    x = A[,1],y = A[,3],col = "black",pch = 18
  )
}




if (TCtest != F) {
  skoki.normalizirano = (max(TCv / TCdef) - min(TCv / TCdef)) / (max(stskokov) -
                                                                   min(stskokov)) * (stskokov - max(stskokov)) + max(TCv / TCdef)
  plot(
    x = zaporedje,y = TCv / TCdef,xlab = "Sprememba variirane spremenljivke",ylab =
      "Sprememba celotnih stroskov"
  )
  lines(x = zaporedje,y = skoki.normalizirano,col = "Red",pch = ".")
  axis(4,at = c(min(TCv / TCdef),max(TCv / TCdef)),labels = c(min(stskokov),max(stskokov)))
  mtext("Stevilo skokov",side = 4)
}
