********************************************************************************
* MAIN DECOMPOSITION FILE
********************************************************************************
* PART 1: Formatting
*************************************************************************
use "./baseline13.dta", clear

* Update days variable
replace days = dtout-dtin

* Update age variable
replace age = year(dtin) - year(dtbirth)

sort id jobcount dtin

// *************************************************************************
* Prep part 1: apply unemployment expansions
sort id jobcount dtin
quietly do  "./u_expansions.do"

* Sample selection -1996
drop if (dtin < td(01jan1996)&state==state2)| (dtout < td(01jan1996)&state!=state2)

* Sample selection: No spells of less than 5 weeks and variable transform
replace real_days_1 = real_days_1 - 35
replace LLdays = LLdays -35
replace Ldays = Ldays -35
replace days = days -35

drop if real_days_1<=0
drop if LLdays<=0
drop if Ldays <= 0
drop if days<=0

* Prep part 2: count spells
quietly do  "./counting_spells.do"

* Save
saveold "./MS96_30.dta", replace

// *************************************************************************
use "./baseline13.dta", clear

* Update days variable
replace days = dtout-dtin

* Update age variable
replace age = year(dtin) - year(dtbirth)

sort id jobcount dtin

// *************************************************************************
* Prep part 1: apply unemployment expansions
sort id jobcount dtin
quietly do  "./u_expansions_original.do"

* Sample selection -1996
drop if (dtin < td(01jan1996)&state==state2)| (dtout < td(01jan1996)&state!=state2)

* Sample selection: No spells of less than 5 weeks and variable transform
replace real_days_1 = real_days_1 - 35
replace LLdays = LLdays -35
replace Ldays = Ldays -35
replace days = days -35

drop if real_days_1<=0
drop if LLdays<=0
drop if Ldays <= 0
drop if days<=0

* Prep part 2: count spells
quietly do  "./counting_spells.do"

* Save
saveold "./MS96_30_old.dta", replace

* Non-Employment
*************************************************************************
use "./baseline13.dta", replace

* Update days variable
replace days = dtout-dtin

* Update age variable
replace age = year(dtin) - year(dtbirth)

// drop if dtin >= td(01jan2008)
// * Cleaning
// quietly do "./cleaning_new_ne.do"

sort id jobcount dtin
quietly do  "./u_expansions_ne.do"

* Sample selection -1996
drop if (dtin < td(01jan1996)&state==state2)| (dtout < td(01jan1996)&state!=state2)

* Sample selection: No spells of less than 31 days and varaible transform
replace real_days_1 = real_days_1 - 35
drop if real_days_1<=0

* Prep part 2: count spells
quietly do  "./counting_spells.do"

* Save
saveold "./MS96_30_NE.dta", replace

********************************************************************************
// PART 2: Decomposition
********************************************************************************

log using ./results/all_results96_30.log, replace
log off

// calculating Lower Lower (RU)
********************************************************************************

use "./MS96_30_old.dta", clear

keep if max_nuc==2
keep if nuc!=.

gen n_spell_u=nuc

quietly do "./LOWER_LOWER.do"

// sum lsig_y lsig_c lsig_e lsig_b plsig_c plsig_e plsig_b 

// log using ./results/table_lowest.log,replace
log on
****** Raw *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

* Export spells to a csv for plots
gen yin = year(dtin)
export delimited LLdays n_spell_u yin using "./results/LLower96_30.csv", replace


********************************************************************************
// calculating Lower (LTU Expansion)
********************************************************************************
* 1.
use "./MS96_30.dta", clear

keep if max_nuc==2
keep if nuc!=.

gen n_spell_u=nuc

quietly do "./LOWER.do"

// sum lsig_y lsig_c lsig_e lsig_b plsig_c plsig_e plsig_b

// log using ./results/table_lower.log,replace
log on
****** LTU *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

* Export spells to a csv for plots
gen yin = year(dtin)
export delimited Ldays n_spell_u yin using "./results/Lower96_30.csv", replace

********************************************************************************
// calculating Lower+ (STU Expansion)
********************************************************************************
// use "./MS96_30.dta", clear
//
// gen nuc2 = nuc
// by id: replace nuc2 = nup if nuc==.&max_nuc<2
// drop if nuc==.&max_nuc==2
// by id: replace nuc2 = _n if nuc2!=.
//
// by id: egen max_nuc2 = max(nuc2)
//
// by id: drop if max_nuc2==3&nuc==.&nup>1
//
// by id: replace nuc2 = _n if nuc2!=.
// drop max_nuc2
// by id: egen max_nuc2 = max(nuc2)
//
// gen Bdays = Ldays
// replace Bdays= real_days_1 if nuc==.
//
// quietly do "./LOWER_PLUS.do"
//
// // log using ./results/table_lower_plus.log,replace
// log on
// ****** STU *****************************
// sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
// log off
//
// * Export spells to a csv for plots
// gen yin = year(dtin)
// gen n_spell_u=nuc2
// export delimited Bdays n_spell_u yin using "./results/STU96.csv", replace



********************************************************************************
// calculating uncensored (STU)
********************************************************************************
use "./MS96_30.dta", clear

by id: replace nup = _n if upper==1
keep if nup<3

gen n_spell_u=nup

quietly do "./UPPER.do"

// log using ./results/table_upper.log,replace
log on
****** STU+Spell Adj *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

gen blank_type = "quit" if U_ghost==1&quit==1
replace blank_type = "SE" if U_ghost==1&self_emp==1
replace blank_type = "short" if U_ghost==1&short_emp==1
tab blank_type


* Export spells to a csv for plots
gen yin = year(dtin)
replace U_ghost=0 if U_ghost==.
export delimited real_days_1 n_spell_u yin blank_type U_ghost using "./results/Upper96_30.csv", replace

********************************************************************************
// Non-Employment
********************************************************************************

use "./MS96_30_NE.dta", clear

by id: replace nup = _n if upper==1
keep if nup<3

gen n_spell_u=nup

quietly do "./UPPER.do"

// log using ./results/table_upper.log,replace
log on
****** NE + Spell Adj *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

* Export spells to a csv for plots
gen yin = year(dtin)
replace U_ghost = 0 if U_ghost==.
export delimited real_days_1 n_spell_u recall U_ghost yin using "./results/NE96_30.csv", replace


// STU + Recalls + Spell correction
// *******************************************
//
// use "./MS96_30_recalls.dta", clear
//
// by id: replace nup = _n if upper==1
// keep if nup<3
//
// gen n_spell_u=nup
//
// quietly do "./UPPER.do"

// log on
****** STU + Recalls + Spell Adj *****************************
// sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
// log off

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
log close