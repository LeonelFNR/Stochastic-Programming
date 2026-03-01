set R; # set of match possible events
set S; # set of possible exams diffs.

param N; # number of hours
param prob_match {r in R} := 1/card(R);
param prob_exam  {s in S} := 1/card(S);


param q1{S}; # exam difficulty
param q2{R}; # game duration

var y1 {R, S} >=0; # study shortage hours
var y2 {R, S} >=0; # match shortage hours

var x1 >= 0; # study hours
var x2 >= 0; # hours for the game


minimize Weighted_Shortage:
	sum{r in R, s in S} prob_match[r]*prob_exam[s]*(2*y1[r,s] + y2[r,s]);

	
subject to number_hours:
	x1 + x2 <= N;
	
subject to study_shortage_compensation {r in R, s in S}:
	x1+ y1[r,s] >= q1[s];
	
subject to match_shortage_compensation {r in R, s in S}:
	x2+ y2[r,s] >= q2[r];	