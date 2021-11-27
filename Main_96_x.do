********************************************************************************
* MAIN DECOMPOSITION FILE - SPELLS FROM 1996
********************************************************************************
* Controlling for observables appendix (_x)
// *************************************************************************

log using ./results/all_results96_x.log, replace
log off
//
// // calculating Lower Lower (Raw data)
// ********************************************************************************
//
// use "./MS96.dta", clear
//
// keep if max_nuc==2
// keep if nuc!=.
//
// gen n_spell_u=nuc
//
// do "./LOWER_LOWER_x.do"
//
// sum lsig_y lsig_c lsig_e lsig_b plsig_c plsig_e plsig_b 
//
// // log using ./results/table_lowest.log,replace
// log on
// ****** Raw *****************************
// sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
// log off
// // gen yin = year(dtin)
// //
// // * Export spells to a csv for plots
// // export delimited LLdays n_spell_u yin using "./results/LLower.csv", replace
//
//
// ********************************************************************************
// // calculating Lower (LTU Expansion)
// ********************************************************************************
// * 1.
// use "./MS96_noA.dta", clear
//
// keep if max_nuc==2
// keep if nuc!=.
//
// gen n_spell_u=nuc
//
// do "./LOWER_x.do"
//
// sum lsig_y lsig_c lsig_e lsig_b plsig_c plsig_e plsig_b
//
// // log using ./results/table_lower.log,replace
// log on
// ****** LTU *****************************
// sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
// log off
//
// // gen yin = year(dtin)
// //
// // * Export spells to a csv for plots
// // export delimited Ldays n_spell_u yin using "./results/Lower.csv", replace
//
// ********************************************************************************
// // calculating Lower+ (STU Expansion)
// ********************************************************************************
// use "./MS96_noA.dta", clear
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
// do "./LOWER_PLUS_x.do"
//
// // log using ./results/table_lower_plus.log,replace
// log on
// ****** STU *****************************
// sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
// log off
//
// // gen yin = year(dtin)
// //
// // gen n_spell_u=nuc2
// //
// // * Export spells to a csv for plots
// // export delimited Bdays n_spell_u yin using "./results/STU.csv", replace


********************************************************************************
// calculating uncensored (Spell Number correction + STU)
********************************************************************************
use "./MS96_noA.dta", clear

by id: replace nup = _n if upper==1
keep if nup<3

gen n_spell_u=nup

do "./UPPER_x_noage.do"

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
// NE + Spell correction
*******************************************

// use "./MS96_noA_NE.dta", clear
//
// by id: replace nup = _n if upper==1
// keep if nup<3
//
// gen n_spell_u=nup
//
// do "./UPPER_x.do"
//
// // log using ./results/table_upper.log,replace
// log on
// ****** NE + Spell Adj *****************************
// sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
// log off


// // STU + Recalls + Spell correction
// *******************************************
//
// use "./MS96_noA_recalls.dta", clear
//
// by id: replace nup = _n if upper==1
// keep if nup<3
//
// gen n_spell_u=nup
//
// do "./UPPER_x.do"
//
// log on
// ****** STU + Recalls + Spell Adj *****************************
// sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
// log off

// // STU + Blanks + Spell Adjustment
// *******************************************
//
// use "./MS96_noA_blanks.dta", clear
//
// by id: replace nup = _n if upper==1
// keep if nup<3
//
// gen n_spell_u=nup
//
// do "./UPPER_x.do"
//
// log on
// ****** STU + Blanks + Spell Adj *****************************
// sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
// log off

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
log close



