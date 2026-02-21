#stochastic version of the newsvendor problem

#sets
param N > 0;
param a >= 0;
param b >= 0;
param dem {i in 1..N} := 100 + (i-1)*(b-a) / (N-1);
param prob {i in 1..N} = 1/N;



# parameters
param q >= 0; # selling price
param r >= 0; # return price
param c >= 0; # price to buy for the newsvendor
param u >= 0; # max. amount of papers to buy


# decision variables
var x >=0; 	# number of papers to acquire
var w {1..N} >=0; 	# number of papers that will be returned
var y {1..N} >=0; 	# number of papers that will be sold by the newsvendor


# objective function
minimize Cost_total:
	c*x + sum {i in 1..N} prob[i]*(-q*y[i] - r*w[i]);

#contraints
subject to Total_papers:
	x <= u;

subject to Sold_less_than_demand {i in 1..N}:
	y[i] <= dem[i];

subject to Sold_and_return_less_than_acquired {i in 1..N}:
	y[i] + w[i] <= x;
	