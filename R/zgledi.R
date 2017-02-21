## preprost deterministicen EOQ
n = 30 #st obdobij
K = 50  #setup cost (per order)
h = 0.05 #holding cost (per inventory-unit per unit-time)
L = 2   #lead time (in unit-time)
D = 150     # Pricakovana vrednost povprasevanja na enoto casa
sd1 = 0 #Standardni odklon povprasevanja na enoto casa
p = 0.10 #shortage cost (ce smo pod y=0)
B = 0 #buffer, tj. varnostni dodatek k RP. Za zeljeno verjetnost, da pademo pod y=0, uporabi formulo B=VaR - Le *D (VaR value at risk za dano porazdelitev)
RP.force = NA #sami izberemo reorder point (sicer nastavi na NA)
yopt.force = NA #sami izberemo kolicino, ki jo narocimo (sicer nastavi na NA)
r = NA #ce zelis vstaviti svoj vektor povprasevanj, sicer pusti na NA (po default vzame rep(D,n) )
korak = 0.005 # inkrement v zanki za testiranje stroskov, ce je korak npr 0.005, potem nastavimo zeljeno spremenljivko na 100%, 99.5%, 100.5%, 99%, 101% itd.
stkor = 250 #zgornjih tock je stkor mnogo
seme = runif(1,0,1000)
#seme = 18

allowshort = F  #dopuscamo nacrtovano pomanjkanje dobrin
prepreci.propad1 = F #ce mine ves cikel, brez da preckamo RP, naroci na koncu cikla
prepreci.propad2 = F #ce smo po skoku se vedno pod RP, naroci taksno narocilo, da bo ob upostevanju vseh prihodnih skokov vrednost zalog na S
prednarocila = T #ce L>Le, prvih nekaj obdobij naroci ob fiksnih cas. intervalih (kot da je Y deterministicen)
LE.namesto.L = F #uporabi efektivni lead time - lepsi rezultati ob nestabilnih Y, ni pa realisticno
t0.namesto.RP = F #naroci periodicno z t0 namesto po preckanju RP
TCtest = F #total cost test, nastavi na F ce noces testirat, sicer izberi parameter ki ga hoces perturbirat (npr "RP") . V if-u spodaj spremeni korak in st. korakov
DP = F #Simulacija rezultata dobljenega z dinamicnim programiranjem, PAZI: izklopi propad2 ter allowshort!

## isto, samo allowshort T, primerjaj TC

### lognormalno, fiksno seme
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








## lep test yopt ob majhnih n
n = 40 #st obdobij
K = 50  #setup cost (per order)
h = 0.05 #holding cost (per inventory-unit per unit-time)
L = 2   #lead time (in unit-time)
D = 150     # Pricakovana vrednost povprasevanja na enoto casa
sd1 = 0 #Standardni odklon povprasevanja na enoto casa
p = 0.10 #shortage cost (ce smo pod y=0)
B = 0 #buffer, tj. varnostni dodatek k RP. Za zeljeno verjetnost, da pademo pod y=0, uporabi formulo B=VaR - Le *D (VaR value at risk za dano porazdelitev)
RP.force = NA #sami izberemo reorder point (sicer nastavi na NA)
yopt.force = NA #sami izberemo kolicino, ki jo narocimo (sicer nastavi na NA)
r = NA #ce zelis vstaviti svoj vektor povprasevanj, sicer pusti na NA (po default vzame rep(D,n) )
korak = 0.005 # inkrement v zanki za testiranje stroskov, ce je korak npr 0.005, potem nastavimo zeljeno spremenljivko na 100%, 99.5%, 100.5%, 99%, 101% itd.
stkor = 250 #zgornjih tock je stkor mnogo
seme = runif(1,0,1000)
#seme = 18

allowshort = F  #dopuscamo nacrtovano pomanjkanje dobrin
prepreci.propad1 = F #ce mine ves cikel, brez da preckamo RP, naroci na koncu cikla
prepreci.propad2 = F #ce smo po skoku se vedno pod RP, naroci taksno narocilo, da bo ob upostevanju vseh prihodnih skokov vrednost zalog na S
prednarocila = T #ce L>Le, prvih nekaj obdobij naroci ob fiksnih cas. intervalih (kot da je Y deterministicen)
LE.namesto.L = F #uporabi efektivni lead time - lepsi rezultati ob nestabilnih Y, ni pa realisticno
t0.namesto.RP = F #naroci periodicno z t0 namesto po preckanju RP
TCtest = "yopt" #total cost test, nastavi na F ce noces testirat, sicer izberi parameter ki ga hoces perturbirat. V if-u spodaj spremeni korak in st. korakov
DP = F #Simulacija rezultata dobljenega z dinamicnim programiranjem, PAZI: izklopi propad2 ter allowshort!
