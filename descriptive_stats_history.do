log using ./results/means_and_variances.log, replace
log off

use "./MS96.dta", clear

by id: replace nup = _n if upper==1
keep if nup<3

gen n_spell_u=nup

quietly do "./UPPER.do"

sort id nup

//drop if state_past!="T"&state_past!="P"
by id: gen history = state_past[1]+state_past[2]
//drop if length(history)<2
replace history = "" if length(history)<2
gen TT =(history=="TT")

gen std_i = sig_i^(0.5)

gen college = (educ2==4)
replace college=0 if educ2==.

log on

* 1: Without history, in general * * * * * * * * * * 
* Sex (0=women)
tab sex_d, sum(mu_i)
tab sex_d, sum(std_i)
tab sex_d, sum(TT)

* Education
tab college, sum(mu_i)
tab college, sum(std_i)
tab college, sum(TT)

log close

log using ./results/descriptive_stats_96_history.log, replace

* 2: Conditional on history * * * * * * * * * * * * * *
tab history, sum(mu_i)
tab history, sum(std_i)

* Women
tab history if sex_d==0, sum(mu_i)
tab history if sex_d==0, sum(std_i)

* Men
tab history if sex_d==1, sum(mu_i)
tab history if sex_d==1, sum(std_i)

* No-college
tab history if ed_d4==0, sum(mu_i)
tab history if ed_d4==0, sum(std_i)

* College
tab history if ed_d4==1, sum(mu_i)
tab history if ed_d4==1, sum(std_i)

* 3: In logs * * * * * * * * * * * * * * * * * * * * *

* In general - in logs
tab history, sum(lmu_i)
tab history, sum(lsig_i)

* Women
tab history if sex_d==0, sum(lmu_i)
tab history if sex_d==0, sum(lsig_i)

* Men
tab history if sex_d==1, sum(lmu_i)
tab history if sex_d==1, sum(lsig_i)

* No-college
tab history if ed_d4==0, sum(lmu_i)
tab history if ed_d4==0, sum(lsig_i)

* College
tab history if ed_d4==1, sum(lmu_i)
tab history if ed_d4==1, sum(lsig_i)


*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
log close



