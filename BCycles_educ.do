log using ./results/BC_educ.log,replace
********************************************************************************
*									       *
*				BC Decomposition			       *
*									       *
********************************************************************************
log off
********************************************************************************
* prep
********************************************************************************
* 2002-2007 ******************************
// use "./baseline13.dta", clear
//
// * Prep part 1: apply unemployment expansions
// sort id jobcount dtin
// quietly do  "./u_expansions.do"
// * Sample selection
// drop if dtout>td(31dec2007)|dtout<td(31dec2001)
//
// * Prep part 2: count spells
// quietly do  "./counting_spells.do"
//
// * Save
// saveold "./MS0207.dta", replace
//
// * Non-employment
// use "./baseline13.dta", clear
// * Prep part 1: apply unemployment expansions
// sort id jobcount dtin
// quietly do  "./u_expansions_ne.do"
// * Sample selection
// drop if dtout>td(31dec2007)|dtout<td(31dec2001)
// * Prep part 2: count spells
// quietly do  "./counting_spells.do"
// * Save
// saveold "./MS0207_NE.dta", replace
//
// * 2008-2013 ******************************
// use "./baseline13.dta", clear
//
// * Prep part 1: apply unemployment expansions
// sort id jobcount dtin
// quietly do  "./u_expansions.do"
// * Sample selection
// drop if dtout>td(31dec2013)|dtout<=td(31dec2007)
//
// * Prep part 2: count spells
// quietly do  "./counting_spells.do"
//
// * Save
// saveold "./MS0813.dta", replace
//
// * Non-employment
// use "./baseline13.dta", clear
// * Prep part 1: apply unemployment expansions
// sort id jobcount dtin
// quietly do  "./u_expansions_ne.do"
// * Sample selection
// drop if dtout>td(31dec2013)|dtout<=td(31dec2007)
// * Prep part 2: count spells
// quietly do  "./counting_spells.do"
// * Save
// saveold "./MS0813_NE.dta", replace

********************************************************************************
* PART 1: 2002-2007
********************************************************************************


****** STU + Spell correction, 2002-2007 *****************************
use "./MS0207.dta", clear

by id: replace nup = _n if upper==1
keep if nup<3

// Re-count
drop max_nup
by id: egen max_nup = count(nup)

//Won't be in upper - too few observations
drop if max_nup<2

gen n_spell_u=nup

preserve

drop if ed_d4==0

quietly do "./UPPER.do"

log on
****** STU + Spell correction, 2002-2007, college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

restore

drop if ed_d4==1

quietly do "./UPPER.do"

log on
****** STU + Spell correction, 2002-2007, no college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off


********************************************************************************
* PART 2: 2008-2013
********************************************************************************


****** STU + Spell correction, 2008-2013 *****************************
use "./MS0813.dta", clear

by id: replace nup = _n if upper==1
keep if nup<3

// Re-count
drop max_nup
by id: egen max_nup = count(nup)

//Won't be in upper - too few observations
drop if max_nup<2

gen n_spell_u=nup

preserve

drop if ed_d4==0

quietly do "./UPPER.do"

log on
****** STU + Spell correction, 2008-2013, college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

restore

drop if ed_d4==1

quietly do "./UPPER.do"

log on
****** STU + Spell correction, 2008-2013, no college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off


log close
