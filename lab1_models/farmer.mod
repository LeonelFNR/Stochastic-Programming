#deterministic model of farmer problem

set CROP1;
set CROP2;
set CROP := CROP1 union CROP2;

param yield {CROP} >= 0; 		#productivity Tones/acre
param cplant {CROP} >= 0; 		#planting cost ($/acre)
param min_crop {CROP1} >= 0; 	#minimun crop required
param psell {CROP1} >= 0; 		#selling price ($/Tona)
param ppurchase {CROP1} >= 0; 	#purchasing price ($/Tona)
param pvbelow >= 0; 			#selling price corn below 6000T production
param pvabove >= 0;				#selling price corn above 6000T production
param land_total >= 0;

#Decision Variables
var x {i in CROP} >= 0;			#Ha of land devoted to wheat, corn and sugarbeet
var w {i in CROP1} >= 0;		#Tons of wheat and corn to be sold
var y {i in CROP1} >= 0;		#Tons of wheat and corn to be purchased
var wbelow {i in CROP2} >= 0;	#Tons of sugar beet sold at the favorable price
var wabove {i in CROP2} >= 0;	#Tons of sugar beet sold at the lowest price

#Objective function
minimize Cost_total: 
		sum {i in CROP} cplant[i] * x[i]
		+ sum {i in CROP1} (ppurchase[i] * y[i]- psell[i] * w[i])
	    - sum {i in CROP2} (pvbelow * wbelow[i] + pvabove *wabove[i]);

#Constraints
subject to Land_total:
	sum {i in CROP} x[i] <= land_total;

subject to Min_crop {i in CROP1}:
	yield[i]*x[i]+y[i]-w[i] >= min_crop[i];
	

subject to Prod_controlled1 {i in CROP2}:
	wbelow[i]+wabove[i] <= yield[i]*x[i];

subject to Prod_controlled2 {i in CROP2}:
	wbelow[i] <= 6000;





