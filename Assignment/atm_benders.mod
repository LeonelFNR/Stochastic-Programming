# ================================================================
# ATM stochastic optimization problem
# Extensive form + Benders decomposition master/subproblem
# Units: l, u and xi are in thousands of euros, as in the statement.
# ================================================================

set SCENARIOS;

param c >= 0;                    # holding cost per unit in the ATM
param q >= 0;                    # refill/shortage cost per unit
param l >= 0;                    # technical minimum
param u >= l;                    # ATM capacity
param p {SCENARIOS} >= 0;        # scenario probabilities
param xi {SCENARIOS} >= 0;       # weekend demand in each scenario

# ----------------------------
# Extensive form
# ----------------------------
var x >= l, <= u;                # cash deposited on Friday
var y {SCENARIOS} >= 0;          # shortage/refill amount per scenario

minimize Extensive_Obj:
    c * x + sum {i in SCENARIOS} p[i] * q * y[i];

subject to Demand {i in SCENARIOS}:
    x + y[i] >= xi[i];

problem Extensive:
    x, y,
    Extensive_Obj,
    Demand;

# ----------------------------
# Benders decomposition
# ----------------------------
param MAXCUTS integer >= 1 default 100;
param nCUT integer >= 0 default 0;
set ALLCUTS := 1..MAXCUTS;
set CUTS := 1..nCUT;

param cut_rhs {ALLCUTS} default 0;
param cut_slope {ALLCUTS} default 0;

# Current first-stage value passed to the subproblem
param xbar >= l, <= u default l;

# Master variables
var xb >= l, <= u;               # master copy of x
var theta >= 0;                  # approximation of expected recourse cost

minimize Master_Obj:
    c * xb + theta;

subject to Benders_Cut {k in CUTS}:
    theta >= cut_rhs[k] + cut_slope[k] * xb;

problem Master:
    xb, theta,
    Master_Obj,
    Benders_Cut;

# Dual subproblem for fixed xbar.
# Primal recourse per scenario:
#   min sum_i p_i q y_i
#   s.t. y_i >= xi_i - xbar, y_i >= 0
# Dual:
#   max sum_i alpha_i (xi_i - xbar)
#   s.t. 0 <= alpha_i <= p_i q
var alpha {i in SCENARIOS} >= 0, <= p[i] * q;

maximize Subproblem_Obj:
    sum {i in SCENARIOS} alpha[i] * (xi[i] - xbar);

problem Subproblem:
    alpha,
    Subproblem_Obj;
