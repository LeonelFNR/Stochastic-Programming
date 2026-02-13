# model of gas distribution planning problem
#(version without SETS)

param T > 0;
param c{1..T};
param cs{1..T};
param d{1..T} > 0;

var x{1..T} >= 0;
var y{0..T} >= 0;
var z{1..T} >= 0;

minimize cost: sum {t in 1..T} (c[t]*x[t]+cs[t]*y[t]);

subject to demand {t in 1..T}: x[t]+z[t] >= d[t];
subject to balance {t in 1..T}: y[t] = y[t-1]+x[t]-d[t];
subject to use_from_warehouse {t in 1..T}: z[t] <= y[t-1];
subject to begin_warehouse : y[0] = 0;







