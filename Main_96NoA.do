********************************************************************************
* MAIN DECOMPOSITION FILE - SPELLS FROM 1996, EXCLUDING SELF-EMPLOYED
********************************************************************************
* PART 1: Formatting
// *************************************************************************
use "./baseline13.dta", clear

* Fix education dummies
replace ed_d4 = 0 if ed_d4==.
replace ed_d3 = 0 if ed_d3==.
replace ed_d2 = 0 if ed_d2==.

* Update days variable
replace days = dtout-dtin

* Update age variable
replace age = year(dtin) - year(dtbirth)

sort id jobcount dtin

*************************************************************************
* Prep part 1: apply unemployment expansions
sort id jobcount dtin
quietly do  "./u_expansions_noA.do"

* Sample selection -1996
drop if (dtin < td(01jan1996)&state==state2)| (dtout < td(01jan1996)&state!=state2)

* Prep part 2: count spells
quietly do  "./counting_spells.do"

* Save
saveold "./MS96_noA.dta", replace

// * Same but with recalls
// *************************************************************************
use "./baseline13.dta", clear

* Fix education dummies
replace ed_d4 = 0 if ed_d4==.
replace ed_d3 = 0 if ed_d3==.
replace ed_d2 = 0 if ed_d2==.

* Update days variable
replace days = dtout-dtin

* Update age variable
replace age = year(dtin) - year(dtbirth)

sort id jobcount dtin

* Prep part 1: apply unemployment expansions
sort id jobcount dtin
quietly do  "./u_expansions_noA_recalls.do"

* Sample selection -1996
drop if (dtin < td(01jan1996)&state==state2)| (dtout < td(01jan1996)&state!=state2)

* Prep part 2: count spells
quietly do  "./counting_spells.do"

* Save
saveold "./MS96_noA_recalls.dta", replace

* Same but without recalls
*************************************************************************
use "./baseline13.dta", clear

* Fix education dummies
replace ed_d4 = 0 if ed_d4==.
replace ed_d3 = 0 if ed_d3==.
replace ed_d2 = 0 if ed_d2==.

* Update days variable
replace days = dtout-dtin

* Update age variable
replace age = year(dtin) - year(dtbirth)

sort id jobcount dtin

* Prep part 1: apply unemployment expansions
sort id jobcount dtin
quietly do  "./u_expansions_noA_blanks.do"

* Sample selection -1996
drop if (dtin < td(01jan1996)&state==state2)| (dtout < td(01jan1996)&state!=state2)

* Prep part 2: count spells
quietly do  "./counting_spells.do"
//
// * Save
saveold "./MS96_noA_blanks.dta", replace

// * Robustness 15
// *************************************************************************
* The following code creates an alternative version without spells less than 15 days
// gen spell15=0
// replace spell15=1 if real_days_1<=15

// log using "./ind15.smcl",replace
// tab ind_short censored if spell15==1
// log close
// translate "./ind15.smcl" "./ind15.log",replace

// saveold "./MS96_noAalt.dta", replace

* Non-Employment
*************************************************************************
use "./baseline13.dta", replace

* Fix education dummies
replace ed_d4 = 0 if ed_d4==.
replace ed_d3 = 0 if ed_d3==.
replace ed_d2 = 0 if ed_d2==.

* Update days variable
replace days = dtout-dtin

* Update age variable
replace age = year(dtin) - year(dtbirth)

// drop if dtin >= td(01jan2008)
// * Cleaning
// quietly do "./cleaning_new_ne.do"

sort id jobcount dtin
quietly do  "./u_expansions_noA_ne.do"

// * Sample selection -1984
// drop if (dtin < td(01jan1984)&state==state2)| (dtout < td(01jan1984)&state!=state2)
* Sample selection -1996
drop if (dtin < td(01jan1996)&state==state2)| (dtout < td(01jan1996)&state!=state2)

* Prep part 2: count spells
quietly do  "./counting_spells.do"

* Save
saveold "./MS96_noA_NE.dta", replace

********************************************************************************
// PART 2: Decomposition
********************************************************************************

// log using ./results/all_results84noA.log, replace
log using ./results/all_results96noA.log, replace
log off

// calculating Lower Lower (Raw data)
********************************************************************************

use "./MS96_noA.dta", clear

keep if max_nuc==2
keep if nuc!=.

gen n_spell_u=nuc

quietly do "./LOWER_LOWER.do"

sum lsig_y lsig_c lsig_e lsig_b plsig_c plsig_e plsig_b 

// log using ./results/table_lowest.log,replace
log on
****** Raw *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off
// gen yin = year(dtin)
//
// * Export spells to a csv for plots
// export delimited LLdays n_spell_u yin using "./results/LLower.csv", replace


********************************************************************************
// calculating Lower (LTU Expansion)
********************************************************************************
* 1.
use "./MS96_noA.dta", clear

keep if max_nuc==2
keep if nuc!=.

gen n_spell_u=nuc

quietly do "./LOWER.do"

sum lsig_y lsig_c lsig_e lsig_b plsig_c plsig_e plsig_b

// log using ./results/table_lower.log,replace
log on
****** LTU *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

// gen yin = year(dtin)
//
// * Export spells to a csv for plots
// export delimited Ldays n_spell_u yin using "./results/Lower.csv", replace

********************************************************************************
// calculating Lower+ (STU Expansion)
********************************************************************************
use "./MS96_noA.dta", clear

gen nuc2 = nuc
by id: replace nuc2 = nup if nuc==.&max_nuc<2
drop if nuc==.&max_nuc==2
by id: replace nuc2 = _n if nuc2!=.

by id: egen max_nuc2 = max(nuc2)

by id: drop if max_nuc2==3&nuc==.&nup>1

by id: replace nuc2 = _n if nuc2!=.
drop max_nuc2
by id: egen max_nuc2 = max(nuc2)

gen Bdays = Ldays
replace Bdays= real_days_1 if nuc==.

quietly do "./LOWER_PLUS.do"

// log using ./results/table_lower_plus.log,replace
log on
****** STU *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

// gen yin = year(dtin)
//
// gen n_spell_u=nuc2
//
// * Export spells to a csv for plots
// export delimited Bdays n_spell_u yin using "./results/STU.csv", replace


********************************************************************************
// calculating uncensored (Spell Number correction + STU)
********************************************************************************
use "./MS96_noA.dta", clear

by id: replace nup = _n if upper==1
keep if nup<3

gen n_spell_u=nup

quietly do "./UPPER.do"

// log using ./results/table_upper.log,replace
log on
****** STU+Spell Adj *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

// gen yin = year(dtin)
//
// * Export spells to a csv for plots
// export delimited real_days_1 n_spell_u yin using "./results/Upper.csv", replace
//
//

********************************************************************************
// Non-Employment
********************************************************************************

// No Spell correction
*******************************************
use "./MS96_noA_NE.dta", clear

gen nuc2 = nuc
by id: replace nuc2 = nup if nuc==.&max_nuc<2
drop if nuc==.&max_nuc==2
by id: replace nuc2 = _n if nuc2!=.

by id: egen max_nuc2 = max(nuc2)

by id: drop if max_nuc2==3&nuc==.&nup>1

by id: replace nuc2 = _n if nuc2!=.
drop max_nuc2
by id: egen max_nuc2 = max(nuc2)

gen Bdays = Ldays
replace Bdays= real_days_1 if nuc==.

quietly do "./LOWER_PLUS.do"

// log using ./results/table_ne.log, replace
log on
****** NE (NO Spell Adj) *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

// gen yin = year(dtin)
//
// gen n_spell_u=nuc2

* Export spells to a csv for plots
// export delimited real_days_1 n_spell_u yin using "./results/NE_STU.csv", replace

// NE + Spell correction
*******************************************

use "./MS96_noA_NE.dta", clear

by id: replace nup = _n if upper==1
keep if nup<3

gen n_spell_u=nup

quietly do "./UPPER.do"

// log using ./results/table_upper.log,replace
log on
****** NE + Spell Adj *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off


// STU + Recalls + Spell correction
*******************************************

use "./MS96_noA_recalls.dta", clear

by id: replace nup = _n if upper==1
keep if nup<3

gen n_spell_u=nup

quietly do "./UPPER.do"

log on
****** STU + Recalls + Spell Adj *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

// STU + Blanks + Spell Adjustment
*******************************************

use "./MS96_noA_blanks.dta", clear

by id: replace nup = _n if upper==1
keep if nup<3

gen n_spell_u=nup

quietly do "./UPPER.do"

log on
****** STU + Blanks + Spell Adj *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
log close


log using ./results/all_results96noA_history.log, replace
log off

use "./MS96_noA.dta", clear

by id: replace nup = _n if upper==1
keep if nup<3

gen n_spell_u=nup

quietly do "./UPPER.do"

sort id nup

drop if state_past!="T"&state_past!="P"
by id: gen history = state_past[1]+state_past[2]
drop if length(history)<2

gen std_i = sig_i^(0.5)

log on
tab history, sum(mu_i)
tab history, sum(std_i)

* Women
tab history if sex_d==0, sum(std_i)

* Men
tab history if sex_d==1, sum(std_i)

* No-college
tab history if ed_d4==0, sum(std_i)

* College
tab history if ed_d4==1, sum(std_i)

*** In logs ***

* In general - in logs
tab history, sum(lmu_i)
tab history, sum(lsig_i)

* Women - in logs
tab history if sex_d==0, sum(lsig_i)

* Men - in logs
tab history if sex_d==1, sum(lsig_i)

* No-college - in logs
tab history if ed_d4==0, sum(lsig_i)

* College - in logs
tab history if ed_d4==1, sum(lsig_i)


*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
log close



