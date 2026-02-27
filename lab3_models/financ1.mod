#versio sense explicitar els escenaris del problema simple financer

set PROD_INVERTIR; #differents tipus de productes on invertir
set T_RETORN; #different tipus de benefici -retorn- 

param T; #nombre de periodes on invertir
param B; #diners inicials per invertir
param G; #diners que caldria tenir al final del periode d'inversio
param Q; #benefici per tenir mes de G unitats al final del periode
param P; #penalitzacio per tenir menys de G unitats al final del periode
param r {PROD_INVERTIR,T_RETORN}; #retorn segons producte financer
								  #i tipus de retorn
param prob {T_RETORN,T_RETORN,T_RETORN}; #probabilitat de cada escenari

var y {T_RETORN,T_RETORN,T_RETORN} >= 0; #variable d'exces de G al final del periode
var w {T_RETORN,T_RETORN,T_RETORN} >= 0; #variable de folga fins G al final del periode
var x {PROD_INVERTIR,1..T,T_RETORN,T_RETORN} >= 0; # hi ha definides
	#mes variables de les necessaries, per simplificar la definicio de variables


maximize Benefici_total: 
		sum {i1 in T_RETORN : i1<>0} # for excluding the dummy value
		sum {i2 in T_RETORN : i2<>0} 
		sum {i3 in T_RETORN : i3<>0} prob[i1,i2,i3]*(Q*y[i1,i2,i3] - P*w[i1,i2,i3]) ;

subject to node_t0:
		sum{p in PROD_INVERTIR} x[p,1,0,0] = B;

subject to nodes_t1 {i1 in T_RETORN: i1<>0}: # money you have now must be equal to the invested times the returns of each investement
		x['a',2,i1,0]+x['b',2,i1,0]= r['a',i1]*x['a',1,0,0]+r['b',i1]*x['b',1,0,0];

subject to nodes_t2 {i1 in T_RETORN , i2 in T_RETORN : i1<>0 and i2<>0}:
		x['a',3,i1,i2]+x['b',3,i1,i2]= r['a',i2]*x['a',2,i1,0]+r['b',i2]*x['b',2,i1,0];

subject to nodes_t3 {i1 in T_RETORN, i2 in T_RETORN , i3 in T_RETORN: i1<>0 and i2<>0 and i3<>0}:
		r['a',i3]*x['a',3,i1,i2]+r['b',i3]*x['b',3,i1,i2] - y[i1,i2,i3] + w[i1,i2,i3]= G;

#subject to avalua_solucio_determinista {t in 1..T, i1 in T_RETORN, i2 in T_RETORN}:
#		x['b',t,i1,i2] = 0;


