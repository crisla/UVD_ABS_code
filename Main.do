********************************************************************************
* MAIN DECOMPOSITION FILE
********************************************************************************
* PART 1: Formatting
// *************************************************************************
// use "./baseline13.dta", clear
//
// * Update days variable
// replace days = dtout-dtin
//
// * Update age variable
// replace age = year(dtin) - year(dtbirth)
//
// sort id jobcount dtin
//
// // *************************************************************************
// * Prep part 1: apply unemployment expansions
// sort id jobcount dtin
// quietly do  "./u_expansions.do"
// // * Sample selection
// // drop if dtin >= td(01jan2008)
//
// * Prep part 2: count spells
// quietly do  "./counting_spells.do"
//
// * Save
// saveold "./MS.dta", replace
//
// * Same but with recalls
// *************************************************************************
// use "./baseline13.dta", clear
//
// * Update days variable
// replace days = dtout-dtin
//
// * Update age variable
// replace age = year(dtin) - year(dtbirth)
//
// sort id jobcount dtin
//
// * Prep part 1: apply unemployment expansions
// sort id jobcount dtin
// quietly do  "./u_expansions_recalls.do"
// // * Sample selection
// // drop if dtin >= td(01jan2008)
// //
// * Prep part 2: count spells
// quietly do  "./counting_spells.do"
// //
// // * Save
// saveold "./MS_recalls.dta", replace

// * Robustness 15
// *************************************************************************
* The following code creates an alternative version without spells less than 15 days
// gen spell15=0
// replace spell15=1 if real_days_1<=15

// log using "./ind15.smcl",replace
// tab ind_short censored if spell15==1
// log close
// translate "./ind15.smcl" "./ind15.log",replace

// saveold "./MSalt.dta", replace

// * Non-Employment
// *************************************************************************
// use "./baseline13.dta", replace
//
// * Update days variable
// replace days = dtout-dtin
//
// * Update age variable
// replace age = year(dtin) - year(dtbirth)
//
// drop if dtin >= td(01jan2008)
// sort id jobcount dtin
//
// // * Cleaning
// // quietly do "./cleaning_new_ne.do"
//
// sort id jobcount dtin
// quietly do  "./u_expansions_ne.do"
// // * Sample selection
// // drop if dtin >= td(01jan2008)
//
// * Prep part 2: count spells
// quietly do  "./counting_spells.do"
//
// * Save
// saveold "./MS_NE.dta", replace

********************************************************************************
// PART 2: Decomposition
********************************************************************************

log using ./results/all_results.log, replace
log off

// calculating Lower Lower (Raw data)
********************************************************************************

use "./MS.dta", clear

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
use "./MS.dta", clear

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
use "./MS.dta", clear

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
use "./MS.dta", clear

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
use "./MS_NE.dta", clear

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

use "./MS_NE.dta", clear

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

use "./MS_recalls.dta", clear

by id: replace nup = _n if upper==1
keep if nup<3

gen n_spell_u=nup

quietly do "./UPPER.do"

log on
****** STU + Recalls + Spell Adj *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
log close
