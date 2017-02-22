## preprost deterministicen EOQ
## Nastavi isto, samo allowshort T, primerjaj TC
n = 30 #st obdobij
K = 50  #setup cost (per order)
h = 0.05 #holding cost (per inventory-unit per unit-time)
L = 2   #lead time (in unit-time)
D = 150     # Pricakovana vrednost povprasevanja na enoto casa
sd1 = 0 #Standardni odklon povprasevanja na enoto casa
p = 0.10 #shortage cost (ce smo pod y=0)
c1 = 0.1 #Normalna cena
c2 = 0.06 #cena èe je naroèilo nad q
q = 1500 #q meja kjer dobimo popust na naroèilo (se uveljavlja c2)
B = 0 #buffer, tj. varnostni dodatek k RP. Za zeljeno verjetnost, da pademo pod y=0, uporabi formulo B=VaR - Le *D (VaR value at risk za dano porazdelitev)
RP.force = NA #sami izberemo reorder point (sicer nastavi na NA)
yopt.force = NA #sami izberemo kolicino, ki jo narocimo (sicer nastavi na NA)
r = NA #ce zelis vstaviti svoj vektor povprasevanj, sicer pusti na NA (po default vzame rep(D,n) )
korak = 0.005 # inkrement v zanki za testiranje stroskov, ce je korak npr 0.005, potem nastavimo zeljeno spremenljivko na 100%, 99.5%, 100.5%, 99%, 101% itd.
stkor = 250 #zgornjih tock je stkor mnogo
seme = runif(1,0,1000)
#seme = 18

diskontiranje = F #ali vkljucimo popust ob nakupu vecje kolicine dobrine
allowshort = F  #dopuscamo nacrtovano pomanjkanje dobrin
prepreci.propad1 = F #ce mine ves cikel, brez da preckamo RP, naroci na koncu cikla
prepreci.propad2 = F #ce smo po skoku se vedno pod RP, naroci taksno narocilo, da bo ob upostevanju vseh prihodnih skokov vrednost zalog na S
prednarocila = T #ce L>Le, prvih nekaj obdobij naroci ob fiksnih cas. intervalih (kot da je Y deterministicen)
LE.namesto.L = F #uporabi efektivni lead time - lepsi rezultati ob nestabilnih Y, ni pa realisticno
t0.namesto.RP = F #naroci periodicno z t0 namesto po preckanju RP
TCtest = F #total cost test, nastavi na F ce noces testirat, sicer izberi parameter ki ga hoces perturbirat (npr "RP") . V if-u spodaj spremeni korak in st. korakov
DP = F #Simulacija rezultata dobljenega z dinamicnim programiranjem, PAZI: izklopi propad2 ter allowshort!
pikice = T

#Razlika v TC brez/z diskontiranjem
n = 30 #st obdobij
K = 50  #setup cost (per order)
h = 0.05 #holding cost (per inventory-unit per unit-time)
L = 2   #lead time (in unit-time)
D = 150     # Pricakovana vrednost povprasevanja na enoto casa
sd1 = 0 #Standardni odklon povprasevanja na enoto casa
p = 0.10 #shortage cost (ce smo pod y=0)
c1 = 0.1 #Normalna cena
c2 = 0.06 #cena ce je narocilo nad q
q = 800 #q meja kjer dobimo popust na narocilo (se uveljavlja c2)
B = 0 #buffer, tj. varnostni dodatek k RP. Za zeljeno verjetnost, da pademo pod y=0, uporabi formulo B=VaR - Le *D (VaR value at risk za dano porazdelitev)
RP.force = NA #sami izberemo reorder point (sicer nastavi na NA)
yopt.force = NA #sami izberemo kolicino, ki jo narocimo (sicer nastavi na NA)
r = NA #ce zelis vstaviti svoj vektor povprasevanj, sicer pusti na NA (po default vzame rep(D,n) )
korak = 0.005 # inkrement v zanki za testiranje stroskov, ce je korak npr 0.005, potem nastavimo zeljeno spremenljivko na 100%, 99.5%, 100.5%, 99%, 101% itd.
stkor = 80 #zgornjih tock je stkor mnogo
seme = runif(1,0,1000)
#seme = 18

diskontiranje = F #ali vkljucimo popust ob nakupu vecje kolicine dobrine
allowshort = F  #dopuscamo nacrtovano pomanjkanje dobrin
prepreci.propad1 = F #ce mine ves cikel, brez da preckamo RP, naroci na koncu cikla
prepreci.propad2 = F #ce smo po skoku se vedno pod RP, naroci taksno narocilo, da bo ob upostevanju vseh prihodnih skokov vrednost zalog na S
prednarocila = T #ce L>Le, prvih nekaj obdobij naroci ob fiksnih cas. intervalih (kot da je Y deterministicen)
LE.namesto.L = F #uporabi efektivni lead time - lepsi rezultati ob nestabilnih Y, ni pa realisticno
t0.namesto.RP = F #naroci periodicno z t0 namesto po preckanju RP
TCtest = F #total cost test, nastavi na F ce noces testirat, sicer izberi parameter ki ga hoces perturbirat (npr "RP") . V if-u spodaj spremeni korak in st. korakov
DP = F #Simulacija rezultata dobljenega z dinamicnim programiranjem, PAZI: izklopi propad2 ter allowshort!
pikice = T



#http://imgur.com/a/m4uy5
#demonstracija DP, primer iz literature
#odkomentiraj tisti nakljucen r
n = 4 #st obdobij
K = 2  #setup cost (per order)
h = 0.2 #holding cost (per inventory-unit per unit-time)
L = 2   #lead time (in unit-time)
D = 150     # Pricakovana vrednost povprasevanja na enoto casa
sd1 = 0 #Standardni odklon povprasevanja na enoto casa
p = 0.10 #shortage cost (ce smo pod y=0)
c1 = 0.1 #Normalna cena
c2 = 0.06 #cena èe je naroèilo nad q
q = 1500 #q meja kjer dobimo popust na naroèilo (se uveljavlja c2)
B = 0 #buffer, tj. varnostni dodatek k RP. Za zeljeno verjetnost, da pademo pod y=0, uporabi formulo B=VaR - Le *D (VaR value at risk za dano porazdelitev)
RP.force = NA #sami izberemo reorder point (sicer nastavi na NA)
yopt.force = NA #sami izberemo kolicino, ki jo narocimo (sicer nastavi na NA)
r = c(3,2,3,2) #ce zelis vstaviti svoj vektor povprasevanj, sicer pusti na NA (po default vzame rep(D,n) )
#r = sample(1:10,n,replace = T)
korak = 0.005 # inkrement v zanki za testiranje stroskov, ce je korak npr 0.005, potem nastavimo zeljeno spremenljivko na 100%, 99.5%, 100.5%, 99%, 101% itd.
stkor = 250 #zgornjih tock je stkor mnogo
seme = runif(1,0,1000)
#seme = 55

diskontiranje = F
allowshort = F  #dopuscamo nacrtovano pomanjkanje dobrin
prepreci.propad1 = F #ce mine ves cikel, brez da preckamo RP, naroci na koncu cikla
prepreci.propad2 = F #ce smo po skoku se vedno pod RP, naroci taksno narocilo, da bo ob upostevanju vseh prihodnih skokov vrednost zalog na S
prednarocila = F #ce L>Le, prvih nekaj obdobij naroci ob fiksnih cas. intervalih (kot da je Y deterministicen)
LE.namesto.L = F #uporabi efektivni lead time - lepsi rezultati ob nestabilnih Y, ni pa realisticno
t0.namesto.RP = F #naroci periodicno z t0 namesto po preckanju RP
TCtest = F #total cost test, nastavi na F ce noces testirat, sicer izberi parameter ki ga hoces perturbirat (npr "RP") . V if-u spodaj spremeni korak in st. korakov
DP = T #Simulacija rezultata dobljenega z dinamicnim programiranjem, PAZI: izklopi propad2, allowshort, prednarocila!
pikice = F




### lognormalno, fiksno seme
n = 30 #st obdobij
K = 50  #setup cost (per order)
h = 0.05 #holding cost (per inventory-unit per unit-time)
L = 2   #lead time (in unit-time)
D = 150     # Pricakovana vrednost povprasevanja na enoto casa
sd1 = 50 #Standardni odklon povprasevanja na enoto casa
p = 0.10 #shortage cost (ce smo pod y=0)
c1 = 0.1 #Normalna cena
c2 = 0.06 #cena èe je naroèilo nad q
q = 1500 #q meja kjer dobimo popust na naroèilo (se uveljavlja c2)
B = 0 #buffer, tj. varnostni dodatek k RP. Za zeljeno verjetnost, da pademo pod y=0, uporabi formulo B=VaR - Le *D (VaR value at risk za dano porazdelitev)
RP.force = NA #sami izberemo reorder point (sicer nastavi na NA)
yopt.force = NA #sami izberemo kolicino, ki jo narocimo (sicer nastavi na NA)
r = NA #ce zelis vstaviti svoj vektor povprasevanj, sicer pusti na NA (po default vzame rep(D,n) )
korak = 0.005 # inkrement v zanki za testiranje stroskov, ce je korak npr 0.005, potem nastavimo zeljeno spremenljivko na 100%, 99.5%, 100.5%, 99%, 101% itd.
stkor = 250 #zgornjih tock je stkor mnogo
#seme = runif(1,0,1000)
seme = 55

diskontiranje = F
allowshort = T  #dopuscamo nacrtovano pomanjkanje dobrin
prepreci.propad1 = F #ce mine ves cikel, brez da preckamo RP, naroci na koncu cikla
prepreci.propad2 = F #ce smo po skoku se vedno pod RP, naroci taksno narocilo, da bo ob upostevanju vseh prihodnih skokov vrednost zalog na S
prednarocila = T #ce L>Le, prvih nekaj obdobij naroci ob fiksnih cas. intervalih (kot da je Y deterministicen)
LE.namesto.L = F #uporabi efektivni lead time - lepsi rezultati ob nestabilnih Y, ni pa realisticno
t0.namesto.RP = F #naroci periodicno z t0 namesto po preckanju RP
TCtest = F #total cost test, nastavi na F ce noces testirat, sicer izberi parameter ki ga hoces perturbirat (npr "RP") . V if-u spodaj spremeni korak in st. korakov
DP = F #Simulacija rezultata dobljenega z dinamicnim programiranjem, PAZI: izklopi propad2 ter allowshort!
pikice = T


#mozni problemi:
# Ce precej povecamo L, tako da imamo vec kot en cikel pred dostavo: takoj propademo, demonstriraj prednarocila
n = 30 #st obdobij
K = 50  #setup cost (per order)
h = 0.05 #holding cost (per inventory-unit per unit-time)
L = 13   #lead time (in unit-time)
D = 150     # Pricakovana vrednost povprasevanja na enoto casa
sd1 = 50 #Standardni odklon povprasevanja na enoto casa
p = 0.10 #shortage cost (ce smo pod y=0)
c1 = 0.1 #Normalna cena
c2 = 0.06 #cena èe je naroèilo nad q
q = 1500 #q meja kjer dobimo popust na naroèilo (se uveljavlja c2)
B = 0 #buffer, tj. varnostni dodatek k RP. Za zeljeno verjetnost, da pademo pod y=0, uporabi formulo B=VaR - Le *D (VaR value at risk za dano porazdelitev)
RP.force = NA #sami izberemo reorder point (sicer nastavi na NA)
yopt.force = NA #sami izberemo kolicino, ki jo narocimo (sicer nastavi na NA)
r = NA #ce zelis vstaviti svoj vektor povprasevanj, sicer pusti na NA (po default vzame rep(D,n) )
korak = 0.005 # inkrement v zanki za testiranje stroskov, ce je korak npr 0.005, potem nastavimo zeljeno spremenljivko na 100%, 99.5%, 100.5%, 99%, 101% itd.
stkor = 250 #zgornjih tock je stkor mnogo
#seme = runif(1,0,1000)
seme = 56

diskontiranje = F
allowshort = T  #dopuscamo nacrtovano pomanjkanje dobrin
prepreci.propad1 = F #ce mine ves cikel, brez da preckamo RP, naroci na koncu cikla
prepreci.propad2 = F #ce smo po skoku se vedno pod RP, naroci taksno narocilo, da bo ob upostevanju vseh prihodnih skokov vrednost zalog na S
prednarocila = F #ce L>Le, prvih nekaj obdobij naroci ob fiksnih cas. intervalih (kot da je Y deterministicen)
LE.namesto.L = F #uporabi efektivni lead time - lepsi rezultati ob nestabilnih Y, ni pa realisticno
t0.namesto.RP = F #naroci periodicno z t0 namesto po preckanju RP
TCtest = F #total cost test, nastavi na F ce noces testirat, sicer izberi parameter ki ga hoces perturbirat (npr "RP") . V if-u spodaj spremeni korak in st. korakov
DP = F #Simulacija rezultata dobljenega z dinamicnim programiranjem, PAZI: izklopi propad2 ter allowshort!
pikice = F


#problem 2: ce Le =/= L se lahko zgodi, da znotraj cikla prej nasletimo na skok kot preckamo RP.
#V tem primeru bomo kasneje morda meli tezave ker bomo izpustili narocilo 
#demonstracija prepreci.propad1
#nastavi na T
n = 50 #st obdobij
K = 100  #setup cost (per order)
h = 0.05 #holding cost (per inventory-unit per unit-time)
L = 13   #lead time (in unit-time)
D = 150     # Pricakovana vrednost povprasevanja na enoto casa
sd1 = 70 #Standardni odklon povprasevanja na enoto casa
p = 0.10 #shortage cost (ce smo pod y=0)
c1 = 0.1 #Normalna cena
c2 = 0.06 #cena èe je naroèilo nad q
q = 1500 #q meja kjer dobimo popust na naroèilo (se uveljavlja c2)
B = 0 #buffer, tj. varnostni dodatek k RP. Za zeljeno verjetnost, da pademo pod y=0, uporabi formulo B=VaR - Le *D (VaR value at risk za dano porazdelitev)
RP.force = NA #sami izberemo reorder point (sicer nastavi na NA)
yopt.force = NA #sami izberemo kolicino, ki jo narocimo (sicer nastavi na NA)
r = NA #ce zelis vstaviti svoj vektor povprasevanj, sicer pusti na NA (po default vzame rep(D,n) )
korak = 0.005 # inkrement v zanki za testiranje stroskov, ce je korak npr 0.005, potem nastavimo zeljeno spremenljivko na 100%, 99.5%, 100.5%, 99%, 101% itd.
stkor = 250 #zgornjih tock je stkor mnogo
#seme = runif(1,0,1000)
seme = 16

diskontiranje = F
allowshort = T  #dopuscamo nacrtovano pomanjkanje dobrin
prepreci.propad1 = F #ce mine ves cikel, brez da preckamo RP, naroci na koncu cikla
prepreci.propad2 = F #ce smo po skoku se vedno pod RP, naroci taksno narocilo, da bo ob upostevanju vseh prihodnih skokov vrednost zalog na S
prednarocila = T #ce L>Le, prvih nekaj obdobij naroci ob fiksnih cas. intervalih (kot da je Y deterministicen)
LE.namesto.L = F #uporabi efektivni lead time - lepsi rezultati ob nestabilnih Y, ni pa realisticno
t0.namesto.RP = F #naroci periodicno z t0 namesto po preckanju RP
TCtest = F #total cost test, nastavi na F ce noces testirat, sicer izberi parameter ki ga hoces perturbirat (npr "RP") . V if-u spodaj spremeni korak in st. korakov
DP = F #Simulacija rezultata dobljenega z dinamicnim programiranjem, PAZI: izklopi propad2 ter allowshort!
pikice = F

#druga demonstracija istega, daljse obdobje
n = 150 #st obdobij
K = 100  #setup cost (per order)
h = 0.05 #holding cost (per inventory-unit per unit-time)
L = 13   #lead time (in unit-time)
D = 150     # Pricakovana vrednost povprasevanja na enoto casa
sd1 = 70 #Standardni odklon povprasevanja na enoto casa
p = 0.10 #shortage cost (ce smo pod y=0)
c1 = 0.1 #Normalna cena
c2 = 0.06 #cena èe je naroèilo nad q
q = 1500 #q meja kjer dobimo popust na naroèilo (se uveljavlja c2)
B = 0 #buffer, tj. varnostni dodatek k RP. Za zeljeno verjetnost, da pademo pod y=0, uporabi formulo B=VaR - Le *D (VaR value at risk za dano porazdelitev)
RP.force = NA #sami izberemo reorder point (sicer nastavi na NA)
yopt.force = NA #sami izberemo kolicino, ki jo narocimo (sicer nastavi na NA)
r = NA #ce zelis vstaviti svoj vektor povprasevanj, sicer pusti na NA (po default vzame rep(D,n) )
korak = 0.005 # inkrement v zanki za testiranje stroskov, ce je korak npr 0.005, potem nastavimo zeljeno spremenljivko na 100%, 99.5%, 100.5%, 99%, 101% itd.
stkor = 250 #zgornjih tock je stkor mnogo
#seme = runif(1,0,1000)
seme = 16

diskontiranje = F
allowshort = T  #dopuscamo nacrtovano pomanjkanje dobrin
prepreci.propad1 = T #ce mine ves cikel, brez da preckamo RP, naroci na koncu cikla
prepreci.propad2 = F #ce smo po skoku se vedno pod RP, naroci taksno narocilo, da bo ob upostevanju vseh prihodnih skokov vrednost zalog na S
prednarocila = T #ce L>Le, prvih nekaj obdobij naroci ob fiksnih cas. intervalih (kot da je Y deterministicen)
LE.namesto.L = F #uporabi efektivni lead time - lepsi rezultati ob nestabilnih Y, ni pa realisticno
t0.namesto.RP = F #naroci periodicno z t0 namesto po preckanju RP
TCtest = F #total cost test, nastavi na F ce noces testirat, sicer izberi parameter ki ga hoces perturbirat (npr "RP") . V if-u spodaj spremeni korak in st. korakov
DP = F #Simulacija rezultata dobljenega z dinamicnim programiranjem, PAZI: izklopi propad2 ter allowshort!
pikice = F


#Problem 3: ce imamo zelo volatilno povprasevanje (ali tezkorepo porazdelitev), se lahko zgodi, da smo po skoku se vedno pod RP
#v tem primeru je mozno, da ne pridemo vec nad RP, torej ne bo novih narocil, propademo
#demonstriraj prepreci.propad2
#morda tudi plot(density(Y)) za prikaz tezkega repa lognormalne

n = 60 #st obdobij
K = 50  #setup cost (per order)
h = 0.05 #holding cost (per inventory-unit per unit-time)
L = 2   #lead time (in unit-time)
D = 150     # Pricakovana vrednost povprasevanja na enoto casa
sd1 = 120 #Standardni odklon povprasevanja na enoto casa
p = 0.10 #shortage cost (ce smo pod y=0)
c1 = 0.1 #Normalna cena
c2 = 0.06 #cena èe je naroèilo nad q
q = 1500 #q meja kjer dobimo popust na naroèilo (se uveljavlja c2)
B = 0 #buffer, tj. varnostni dodatek k RP. Za zeljeno verjetnost, da pademo pod y=0, uporabi formulo B=VaR - Le *D (VaR value at risk za dano porazdelitev)
RP.force = NA #sami izberemo reorder point (sicer nastavi na NA)
yopt.force = NA #sami izberemo kolicino, ki jo narocimo (sicer nastavi na NA)
r = NA #ce zelis vstaviti svoj vektor povprasevanj, sicer pusti na NA (po default vzame rep(D,n) )
korak = 0.005 # inkrement v zanki za testiranje stroskov, ce je korak npr 0.005, potem nastavimo zeljeno spremenljivko na 100%, 99.5%, 100.5%, 99%, 101% itd.
stkor = 250 #zgornjih tock je stkor mnogo
#seme = runif(1,0,1000)
seme = 39

diskontiranje = F
allowshort = T  #dopuscamo nacrtovano pomanjkanje dobrin
prepreci.propad1 = F #ce mine ves cikel, brez da preckamo RP, naroci na koncu cikla
prepreci.propad2 = F #ce smo po skoku se vedno pod RP, naroci taksno narocilo, da bo ob upostevanju vseh prihodnih skokov vrednost zalog na S
prednarocila = T #ce L>Le, prvih nekaj obdobij naroci ob fiksnih cas. intervalih (kot da je Y deterministicen)
LE.namesto.L = F #uporabi efektivni lead time - lepsi rezultati ob nestabilnih Y, ni pa realisticno
t0.namesto.RP = F #naroci periodicno z t0 namesto po preckanju RP
TCtest = F #total cost test, nastavi na F ce noces testirat, sicer izberi parameter ki ga hoces perturbirat (npr "RP") . V if-u spodaj spremeni korak in st. korakov
DP = F #Simulacija rezultata dobljenega z dinamicnim programiranjem, PAZI: izklopi propad2 ter allowshort!
pikice = T #narisi tocke kjer se spremeni povprasevanje OZ prejmemo posiljko












#Obcutljivost na motnje parametrov
## lep test motnje "yopt" ob majhnih n
n = 40 #st obdobij
K = 50  #setup cost (per order)
h = 0.05 #holding cost (per inventory-unit per unit-time)
L = 2   #lead time (in unit-time)
D = 150     # Pricakovana vrednost povprasevanja na enoto casa
sd1 = 0 #Standardni odklon povprasevanja na enoto casa
p = 0.10 #shortage cost (ce smo pod y=0)
c1 = 0.1 #Normalna cena
c2 = 0.06 #cena èe je naroèilo nad q
q = 1500 #q meja kjer dobimo popust na naroèilo (se uveljavlja c2)
B = 0 #buffer, tj. varnostni dodatek k RP. Za zeljeno verjetnost, da pademo pod y=0, uporabi formulo B=VaR - Le *D (VaR value at risk za dano porazdelitev)
RP.force = NA #sami izberemo reorder point (sicer nastavi na NA)
yopt.force = NA #sami izberemo kolicino, ki jo narocimo (sicer nastavi na NA)
r = NA #ce zelis vstaviti svoj vektor povprasevanj, sicer pusti na NA (po default vzame rep(D,n) )
korak = 0.005 # inkrement v zanki za testiranje stroskov, ce je korak npr 0.005, potem nastavimo zeljeno spremenljivko na 100%, 99.5%, 100.5%, 99%, 101% itd.
stkor = 250 #zgornjih tock je stkor mnogo
seme = runif(1,0,1000)
#seme = 18

diskontiranje = F
allowshort = F  #dopuscamo nacrtovano pomanjkanje dobrin
prepreci.propad1 = F #ce mine ves cikel, brez da preckamo RP, naroci na koncu cikla
prepreci.propad2 = F #ce smo po skoku se vedno pod RP, naroci taksno narocilo, da bo ob upostevanju vseh prihodnih skokov vrednost zalog na S
prednarocila = T #ce L>Le, prvih nekaj obdobij naroci ob fiksnih cas. intervalih (kot da je Y deterministicen)
LE.namesto.L = F #uporabi efektivni lead time - lepsi rezultati ob nestabilnih Y, ni pa realisticno
t0.namesto.RP = F #naroci periodicno z t0 namesto po preckanju RP
TCtest = "yopt" #total cost test, nastavi na F ce noces testirat, sicer izberi parameter ki ga hoces perturbirat (npr "RP") . V if-u spodaj spremeni korak in st. korakov
DP = F #Simulacija rezultata dobljenega z dinamicnim programiranjem, PAZI: izklopi propad2 ter allowshort!
pikice = F #narisi tocke kjer se spremeni povprasevanje OZ prejmemo posiljko



#zmotimo "RP"
n = 40 #st obdobij
K = 50  #setup cost (per order)
h = 0.05 #holding cost (per inventory-unit per unit-time)
L = 2   #lead time (in unit-time)
D = 150     # Pricakovana vrednost povprasevanja na enoto casa
sd1 = 0 #Standardni odklon povprasevanja na enoto casa
p = 0.10 #shortage cost (ce smo pod y=0)
c1 = 0.1 #Normalna cena
c2 = 0.06 #cena èe je naroèilo nad q
q = 1500 #q meja kjer dobimo popust na naroèilo (se uveljavlja c2)
B = 0 #buffer, tj. varnostni dodatek k RP. Za zeljeno verjetnost, da pademo pod y=0, uporabi formulo B=VaR - Le *D (VaR value at risk za dano porazdelitev)
RP.force = NA #sami izberemo reorder point (sicer nastavi na NA)
yopt.force = NA #sami izberemo kolicino, ki jo narocimo (sicer nastavi na NA)
r = NA #ce zelis vstaviti svoj vektor povprasevanj, sicer pusti na NA (po default vzame rep(D,n) )
korak = 0.005 # inkrement v zanki za testiranje stroskov, ce je korak npr 0.005, potem nastavimo zeljeno spremenljivko na 100%, 99.5%, 100.5%, 99%, 101% itd.
stkor = 190 #zgornjih tock je stkor mnogo
#seme = runif(1,0,1000)
seme = 20

diskontiranje = F
allowshort = T  #dopuscamo nacrtovano pomanjkanje dobrin
prepreci.propad1 = F #ce mine ves cikel, brez da preckamo RP, naroci na koncu cikla
prepreci.propad2 = T #ce smo po skoku se vedno pod RP, naroci taksno narocilo, da bo ob upostevanju vseh prihodnih skokov vrednost zalog na S
prednarocila = T #ce L>Le, prvih nekaj obdobij naroci ob fiksnih cas. intervalih (kot da je Y deterministicen)
LE.namesto.L = F #uporabi efektivni lead time - lepsi rezultati ob nestabilnih Y, ni pa realisticno
t0.namesto.RP = F #naroci periodicno z t0 namesto po preckanju RP
TCtest = "RP" #total cost test, nastavi na F ce noces testirat, sicer izberi parameter ki ga hoces perturbirat (npr "RP"). V if-u spodaj spremeni korak in st. korakov
DP = F #Simulacija rezultata dobljenega z dinamicnim programiranjem, PAZI: izklopi propad2 ter allowshort!
pikice = F #narisi tocke kjer se spremeni povprasevanje OZ prejmemo posiljko




#zmotimo "h"
n = 40 #st obdobij
K = 50  #setup cost (per order)
h = 0.05 #holding cost (per inventory-unit per unit-time)
L = 2   #lead time (in unit-time)
D = 150     # Pricakovana vrednost povprasevanja na enoto casa
sd1 = 0 #Standardni odklon povprasevanja na enoto casa
p = 0.10 #shortage cost (ce smo pod y=0)
c1 = 0.1 #Normalna cena
c2 = 0.06 #cena èe je naroèilo nad q
q = 1500 #q meja kjer dobimo popust na naroèilo (se uveljavlja c2)
B = 0 #buffer, tj. varnostni dodatek k RP. Za zeljeno verjetnost, da pademo pod y=0, uporabi formulo B=VaR - Le *D (VaR value at risk za dano porazdelitev)
RP.force = NA #sami izberemo reorder point (sicer nastavi na NA)
yopt.force = NA #sami izberemo kolicino, ki jo narocimo (sicer nastavi na NA)
r = NA #ce zelis vstaviti svoj vektor povprasevanj, sicer pusti na NA (po default vzame rep(D,n) )
korak = 0.005 # inkrement v zanki za testiranje stroskov, ce je korak npr 0.005, potem nastavimo zeljeno spremenljivko na 100%, 99.5%, 100.5%, 99%, 101% itd.
stkor = 250 #zgornjih tock je stkor mnogo
#seme = runif(1,0,1000)
seme = 20

diskontiranje = F
allowshort = T  #dopuscamo nacrtovano pomanjkanje dobrin
prepreci.propad1 = F #ce mine ves cikel, brez da preckamo RP, naroci na koncu cikla
prepreci.propad2 = T #ce smo po skoku se vedno pod RP, naroci taksno narocilo, da bo ob upostevanju vseh prihodnih skokov vrednost zalog na S
prednarocila = T #ce L>Le, prvih nekaj obdobij naroci ob fiksnih cas. intervalih (kot da je Y deterministicen)
LE.namesto.L = F #uporabi efektivni lead time - lepsi rezultati ob nestabilnih Y, ni pa realisticno
t0.namesto.RP = F #naroci periodicno z t0 namesto po preckanju RP
TCtest = "h" #total cost test, nastavi na F ce noces testirat, sicer izberi parameter ki ga hoces perturbirat (npr "RP"). V if-u spodaj spremeni korak in st. korakov
DP = F #Simulacija rezultata dobljenega z dinamicnim programiranjem, PAZI: izklopi propad2 ter allowshort!
pikice = F #narisi tocke kjer se spremeni povprasevanje OZ prejmemo posiljko





#Pokazi casovno zahtevnost