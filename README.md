#Skupina 5 - Deterministična teorija inventarja
**Avtorji:** Jan Perme, Tatijana Slijepčević, Marvin Herzog

V naši nalogi se bomo ukvarjali s teorijo inventarja, tj. z določanjem količine dobrin, ki jih mora podjetje imeti na zalogi, da vzdržuje nemoteno poslovanje. Osnova problema je predpostavka, da imamo ob presežnih zalogah neke dobrine dodatne oportunitetne stroške, stroške hranjenja, zavarovanja, itd. Hkrati pa utrpimo izgubo pri poslovanju, če je nivo te dobrine premajhen. Zaradi kompleksnosti problema ni mogoče vsega zajeti zgolj v en model, vedno pa nas bo zanimalo dvoje: *kdaj* naročiti dobrino in *koliko* naročiti.

V nadaljnjem delu bomo iz podane literature izbrali ter predstavili nekaj zanimivejših modelov in zgledov, nato pa jih bomo skušali sami simulirati - najverjetneje v okolju R zaradi ustrezne implementacije časovnih vrst in stohastičnih procesov, del pa v Microsoftovem Excelu. Zanimala nas bo razlika v rezultatih simulacij, kjer je povpraševanje prvič deterministično, drugič slučajno. Obravnavali bomo modele, kjer se inventar spreminja zvezno, spet drugič pa diskretno (v serijah). Nazadnje bomo pri vsakem izmed primerov zmotili vhodne podatke in skušali oceniti občutljivost problema.

Dodatne možne posplošitve:

  *	Backlogging - presežno povpraševanje po dobrini se prenese v kasnejša obdobja (možni dodatni stroški).
  *	Dobiček – v model ga lahko vključimo, ko ceno ter povpraševanje dobrine določa trg.
  *	Diskontna stopnja – upoštevamo vrednost denarja skozi čas.
  *	Preostala vrednost (Salvage Value) – vrednost dobrine, ki ni bila uporabljena ali prodana. Lahko nastopa kot strošek.
  *	Čas dostave/proizvodnje – dobrina postane dostopna šele nekaj časa po tem, ko jo naročimo.
  
Problem inventarja lahko razdelimo v več kategorij. Naročanje je lahko periodično (npr. na začetku vsakega tedna) ali pa na osnovi stanja inventarja (npr. naročimo ko zaloga izdelka pade pod 5).

Kompleksnost problema je odvisna od tega ali je povpraševanje za izdelek deterministično ali verjetnostno. Povpraševanje pa je lahko v vsakem od obeh zgornjih primerov konstantno ali pa se spreminja s časom. Tako dobimo štiri kategorije kompleksnosti problema inventarja:

  *	Deterministično konstantno povpraševanje glede na čas
  *	Deterministično variajoče povpraševanje glede na čas
  *	Verjetnostno konstantno povpraševanje glede na čas
  *	Verjetnostno variajoče povpraševanje glede na čas
  
Najmanj kompleksen je prvi primer najbolj pa zadnji.
Za reševanje problemov se uporabljajo štirje modeli:

*	Klasičen EOQ (Economic order quantity) model, ki predpodstavlja, da se obnova zaloge zgodi v časih L in ne dovoljuje primankljaja izdelka. Vrne nam optimalno število izdelkov **y*** in čas **t0***, ki nam poda optimalen interval obnavljanja zalog. Za model potrebujemo 3 parametre:
  *	**K** – cena priprave naročila,
  *	**h** – cena hranjenja izdelka na enoto časa ter 
  *	**D** – povpraševanje po izdelku na enoto časa.
  

*	EOQ model z diskontiranimi cenami. Model je isti kot klasičen EOQ model, le da dopušča nižjo ceno izdelka ob nakupu velikih količin.
*	EOQ za več izdelkov z omejenim prostorom shranjevanja. To je še nadaljnja nadgradnja modela EOQ
*	Dinamični EOQ model.  Model je različen od modela v zgornji točki v tem, da se zalogo pregleduje periodično. Povpraševanje po periodah je sicer deterministično, a različno za vsako periodo.


