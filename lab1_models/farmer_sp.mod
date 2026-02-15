#deterministic model of farmer problem

set CROP1;
set CROP2;
set CROP := CROP1 union CROP2;
set SCEN;

param yield {CROP, SCEN} >= 0; 		#productivity Tones/acre
param cplant {CROP} >= 0; 		#planting cost ($/acre)
param min_crop {CROP1} >= 0; 	#minimun crop required
param psell {CROP1} >= 0; 		#selling price ($/Tona)
param ppurchase {CROP1} >= 0; 	#purchasing price ($/Tona)
param pvbelow >= 0; 			#selling price corn below 6000T production
param pvabove >= 0;				#selling price corn above 6000T production
param land_total >= 0;
param prob_scen {SCEN};

#Decision Variables
var x {i in CROP} >= 0;			#Ha of land devoted to wheat, corn and sugarbeet
var w {i in CROP1, j in SCEN} >= 0;		#Tons of wheat and corn to be sold
var y {i in CROP1, j in SCEN} >= 0;		#Tons of wheat and corn to be purchased
var wbelow {i in CROP2, j in SCEN} >= 0;	#Tons of sugar beet sold at the favorable price
var wabove {i in CROP2, j in SCEN} >= 0;	#Tons of sugar beet sold at the lowest price

#Objective function
minimize Cost_total: 
		sum {i in CROP} cplant[i] * x[i]
		+ 1/3 * (sum {i in CROP1, j in SCEN} (ppurchase[i] * y[i,j]- psell[i] * w[i,j]))
	    - 1/3 * (sum {i in CROP2, j in SCEN} (pvbelow * wbelow[i,j] + pvabove * wabove[i,j]));

#Constraints
subject to Land_total:
	sum {i in CROP} x[i] <= land_total;

subject to Min_crop {i in CROP1, j in SCEN}:
	yield[i,j]*x[i]+y[i,j]-w[i,j] >= min_crop[i];
	

subject to Prod_controlled1 {i in CROP2, j in SCEN}:
	wbelow[i,j]+wabove[i,j] <= yield[i,j]*x[i];

subject to Prod_controlled2 {i in CROP2, j in SCEN}:
	wbelow[i,j] <= 6000;





