#inventory


## Normalna porazdelitev (po 11.3-1 skozi 14.1-1)
K = 100  #setup cost (per order)
h = 0.02 #holding cost (per inventory-unit per unit-time)
L = 12   #lead time (in unit-time)
D=100      # Pricakovana vrednost in std. odklon povpraševanja na enoto èasa
sd1=10  #




#unif(0,100) 14.1-2 "Probabilitized"
K = 100
h = 2
p = 10 #shortage cost
D = 1000
EX = 50
SD = sqrt(100^2/12)




SHT = sqrt((p+h)/p) #faktor za shortage cost, ce ne dopuscamo, potem nastavi na 1



yopt = sqrt((2*K*D)/h)*SHT #kolicina, ki jo narocimo
S = yopt/SHT^2
yopt-S #shortage v enotah

t0 = yopt/D            #dolzina cikla



Le = L%%t0 #effective lead time
RP = Le*D #reorder point

EX = D*Le           # Upanje in std. odklon povpraševanja med Le
SD = sqrt(sd1^2*Le) #




alp = 0.05 #izbrana verjetnost primanjkljaja zalog
n = 1000    #dimenzija slucajnega vektorja

# Zelimo: P(X>B+EX) < alp
VaR = qnorm(1-alp,EX,SD) #VaR za N(EX,SD)
B=VaR-EX #Buffer size 
EX + B #reorder point



X = rnorm(n,EX,SD)
plot(density(X))
abline(v = VaR, col = "blue")


1-length(X[X<EX+B])/n #delez obdobij, ko smo imeli primanjkljaj zalog (empiricno -> primerjaj z alp)




p = 10 #shortage cost per inventory unit
EX = 50

##Hadley-Whitin
yA = sqrt( (2*D*(K+p*EX)) / h   )
yB = p*D/h

yB>=yA #if TRUE, opt za y in R obstajata

#primer: X ~ unif(0,100)
S <- function(R){R^2/200 -R+50} # Expected shortage quantity per cycle, := integral_{R}^{neskoncno} (x-R)f(x)dx .... v tem primeru integral_{R}^{neskoncno} (x-R)(1/100)dx = R^2/200 -R+50

R <- function(y){100-y/50}#iz enacbe integral_{Ri}^{neskoncno}f(x)dx = (h*yi)/(p*D) izrazi funkcijo Ri kot funkcijo spremenljivke yi


#y1, R1:
y1 = 35124 #nakljucno
R1 = 1241  #nakljucno
eps = .Machine$double.eps #toleranca  #.Machine$double.eps
maxiter = 400 #najvecje dovoljeno st korakov

y2 = sqrt((2*K*D)/h)
R2 = R(y2)

i = 0
while(abs(R1-R2+y1-y2) > 2*eps & i < maxiter){
  y1 = y2
  R1 = R2

  i = i + 1
  y2 = sqrt((2*D*(K+p*S(R1)))/h)
  R2 = R(y2)
}


