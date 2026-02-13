# model of gas distribution planning problem
#(version with SETS)

set MONTHS2 ordered;
set MONTHS ordered := MONTHS2 diff {'BEGIN'};

param c{MONTHS};
param cs{MONTHS};
param d{MONTHS} > 0;

var x{MONTHS} >= 0;
var y{MONTHS2} >= 0;
var z{MONTHS} >= 0;

minimize cost: sum {t in MONTHS} (c[t]*x[t]+cs[t]*y[t]);

subject to demand {t in MONTHS}: x[t]+z[t] >= d[t];
subject to balance {t in MONTHS}: y[t] = y[prev(t,MONTHS2)]+x[t]-d[t];
subject to use_from_warehouse  {t in MONTHS}: z[t] <= y[prev(t,MONTHS2)];
subject to begin_warehouse : y['BEGIN'] = 0;


