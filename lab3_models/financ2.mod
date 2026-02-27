#versio explicitant els escenaris del problema simple financer

set PROD_INVERTIR; #differents tipus de productes on invertir

param S; #nombre d'escenaris considerats
param T; #nombre de periodes on invertir
param B; #diners inicials per invertir
param G; #diners que caldria tenir al final del periode d'inversio
param Q; #benefici per tenir mes de G unitats al final del periode
param P; #penalitzacio per tenir menys de G unitats al final del periode

param r {PROD_INVERTIR,1..T,1..S}; #retorn segons producte financer per
								#a cada escenari i interval
param prob {1..S}; #probabilitat de cada escenari
param S_links{1..S,1..S,1..T};  #matriu de 0-1 que indica per a tot 
							    #t de 1..T quins escenaris tenen els
								#mateixos tipus de retorns r[] 

var y {1..S} >= 0; #variable d'exces de G al final del periode
var w {1..S} >= 0; #variable de folga fins G al final del periode
var x {PROD_INVERTIR,1..T,1..S} >= 0; # inversions realitzades


maximize Benefici_total: 
		sum {s in 1..S} prob[s]*(Q*y[s] - P*w[s]) ;

subject to inversio_inicial {s in 1..S}:
		sum{p in PROD_INVERTIR} x[p,1,s] = B;

subject to balanç {s in 1..S, t in 1..T-1}:
		sum{p in PROD_INVERTIR} r[p,t,s]*x[p,t,s] = sum{p in PROD_INVERTIR} x[p,t+1,s];

subject to estat_final {s in 1..S}:
		sum{p in PROD_INVERTIR} r[p,T,s]*x[p,T,s]-y[s]+w[s] = G;

subject to nonanticip {p in PROD_INVERTIR, t in 1..T, s in 1..S}:
		sum {i in 1..S} S_links[s,i,t]*prob[i]*x[p,t,i]= 
		(sum {i in 1..S} S_links[s,i,t]*prob[i]) * x[p,t,s];

#subject to avalua_solucio_determinista {t in 1..T, s in 1..S}:
#		x['b',t,s] = 0;




