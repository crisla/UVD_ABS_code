********************************************************************************
* DESCRIPTIVE STATS FILE II
********************************************************************************
* Composition II
****************************************************

* STU + Spell Adj, expansion
*****************************
use "./MS0207.dta", clear

by id: replace nup = _n if upper==1
keep if nup<3

*Adjust year_in for gap spells
replace year_in = year(dtout) if U_ghost==1 & U_ghost!=.

gen college = 1 if ed_d4==1
replace college = 0 if college==.

gen past_T = 1 if state_past_likely == "T"
replace past_T = 0 if past_T==.

gen past_P = 1 if state_past_likely == "P"
replace past_P = 0 if past_P==.

gen past_A = 1 if state_past_likely == "A"
replace past_A = 0 if past_A==.

* Adjust dummy
replace sex_d = sex_d - 1
replace sex_d = 1 if sex_d == -1

drop _merge
merge m:1 province using "/share/home/clafuent/MCVL/UVD_ABS_code/data/ccaa_codes.dta"

log using "./descriptive_stats_07.log",replace
univar real_days_1 nup days_past age sex_d college year_in past_T past_P past_A quit madrid barcelona sur norte
log close

log using "./descriptive_stats_stu_ind_07.log",replace
tab ind_short
log close

log using "./descriptive_stats_stu_occ_07.log",replace
tab grcot
log close



* STU + Spell Adj, recession
*****************************
use "./MS0813.dta", clear

by id: replace nup = _n if upper==1
keep if nup<3

*Adjust year_in for gap spells
replace year_in = year(dtout) if U_ghost==1 & U_ghost!=.

gen college = 1 if ed_d4==1
replace college = 0 if college==.

gen past_T = 1 if state_past_likely == "T"
replace past_T = 0 if past_T==.

gen past_P = 1 if state_past_likely == "P"
replace past_P = 0 if past_P==.

gen past_A = 1 if state_past_likely == "A"
replace past_A = 0 if past_A==.

* Adjust dummy
replace sex_d = sex_d - 1
replace sex_d = 1 if sex_d == -1

drop _merge
merge m:1 province using "/share/home/clafuent/MCVL/UVD_ABS_code/data/ccaa_codes.dta"

log using "./descriptive_stats_13.log",replace
univar real_days_1 nup days_past age sex_d college year_in past_T past_P past_A quit madrid barcelona sur norte
log close

log using "./descriptive_stats_stu_ind_13.log",replace
tab ind_short
log close

log using "./descriptive_stats_stu_occ_13.log",replace
tab grcot
log close


