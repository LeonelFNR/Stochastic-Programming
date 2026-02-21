param R >=0;
param L >=0;
param C1 >=0;
param C2 >=0;
param m >=0;
param M >=0;
param S > 0;
param prob {1..S} := 1/S;
param dem {i in 1..S} := m + (M-m)*(i-1)/(S-1);

var x >= m, <= L;
var y {1..S} >= 0;
var z {1..S} binary;

minimize fobj: 
	R*x+ sum{i in 1..S} prob[i] * (C1*z[i]+C2*y[i]);

subject to demand {i in 1..S}:
	x + y[i] >= dem[i];

subject to yz {i in 1..S}:
	y[i] <= M*z[i];
