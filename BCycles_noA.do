log using ./results/BC_all_noA.log,replace
********************************************************************************
*									       *
*				BC Decomposition			       *
*									       *
********************************************************************************
log off
********************************************************************************
* prep
********************************************************************************
// * 2002-2007 ******************************
// use "./baseline13.dta", clear
//
// * Fix education dummies
// replace ed_d4 = 0 if ed_d4==.
// replace ed_d3 = 0 if ed_d3==.
// replace ed_d2 = 0 if ed_d2==.
// * Prep part 1: apply unemployment expansions
// sort id jobcount dtin
// quietly do  "./u_expansions_noA.do"
// * Sample selection
// drop if dtout>td(31dec2007)|dtout<td(31dec2001)
// * Prep part 2: count spells
// quietly do  "./counting_spells.do"
// * Save
// saveold "./MSnoA0207.dta", replace
//
// * Recalls
// use "./baseline13.dta", clear
// * Fix education dummies
// replace ed_d4 = 0 if ed_d4==.
// replace ed_d3 = 0 if ed_d3==.
// replace ed_d2 = 0 if ed_d2==.
// * Prep part 1: apply unemployment expansions
// sort id jobcount dtin
// quietly do  "./u_expansions_noA_recalls.do"
// * Sample selection
// drop if dtout>td(31dec2007)|dtout<td(31dec2001)
// * Prep part 2: count spells
// quietly do  "./counting_spells.do"
// * Save
// saveold "./MSnoA0207_recalls.dta", replace
//
// * Non-employment
// use "./baseline13.dta", clear
// * Fix education dummies
// replace ed_d4 = 0 if ed_d4==.
// replace ed_d3 = 0 if ed_d3==.
// replace ed_d2 = 0 if ed_d2==.
// * Prep part 1: apply unemployment expansions
// sort id jobcount dtin
// quietly do  "./u_expansions_noA_ne.do"
// * Sample selection
// drop if dtout>td(31dec2007)|dtout<td(31dec2001)
// * Prep part 2: count spells
// quietly do  "./counting_spells.do"
// * Save
// saveold "./MSnoA0207_NE.dta", replace
//
// * 2008-2013 ******************************
// use "./baseline13.dta", clear
// * Fix education dummies
// replace ed_d4 = 0 if ed_d4==.
// replace ed_d3 = 0 if ed_d3==.
// replace ed_d2 = 0 if ed_d2==.
// * Prep part 1: apply unemployment expansions
// sort id jobcount dtin
// quietly do  "./u_expansions_noA.do"
// * Sample selection
// drop if dtout>td(31dec2013)|dtout<=td(31dec2007)
// * Prep part 2: count spells
// quietly do  "./counting_spells.do"
// * Save
// saveold "./MSnoA0813.dta", replace
//
// * Recalls
// use "./baseline13.dta", clear
// "./MSnoA0813.dta"
// * Fix education dummies
// replace ed_d4 = 0 if ed_d4==.
// replace ed_d3 = 0 if ed_d3==.
// replace ed_d2 = 0 if ed_d2==.
// * Prep part 1: apply unemployment expansions
// sort id jobcount dtin
// quietly do  "./u_expansions_noA_recalls.do"
// * Sample selection
// drop if dtout>td(31dec2013)|dtout<=td(31dec2007)
// * Prep part 2: count spells
// quietly do  "./counting_spells.do"
// * Save
// saveold "./MSnoA0813_recalls.dta", replace
//
// * Non-employment
// use "./baseline13.dta", clear
// * Fix education dummies
// replace ed_d4 = 0 if ed_d4==.
// replace ed_d3 = 0 if ed_d3==.
// replace ed_d2 = 0 if ed_d2==.
// * Prep part 1: apply unemployment expansions
// sort id jobcount dtin
// quietly do  "./u_expansions_noA_ne.do"
// * Sample selection
// drop if dtout>td(31dec2013)|dtout<=td(31dec2007)
// * Prep part 2: count spells
// quietly do  "./counting_spells.do"
// * Save
// saveold "./MSnoA0813_NE.dta", replace
//
********************************************************************************
* PART 1: 2002-2007
********************************************************************************

****** RAW, 2002-2007 *****************************
use "./MSnoA0207.dta", clear

keep if max_nuc==2
keep if nuc!=.

gen n_spell_u=nuc

quietly do "./LOWER_LOWER.do"

log on
****** RAW, 2002-2007 *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

****** LTU, 2002-2007 *****************************
use "./MSnoA0207.dta", clear

keep if max_nuc==2
keep if nuc!=.

gen n_spell_u=nuc

quietly do "./LOWER.do"

log on
****** LTU, 2002-2007 *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

****** STU, 2002-2007 *****************************
use "./MSnoA0207.dta", clear

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

log on
****** STU, 2002-2007 *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off


****** STU + Spell Adj, 2002-2007 *****************************
use "./MSnoA0207.dta", clear

by id: replace nup = _n if upper==1
keep if nup<3

// Re-count
drop max_nup
by id: egen max_nup = count(nup)

//Won't be in upper - too few observations
drop if max_nup<2

gen n_spell_u=nup

quietly do "./UPPER.do"

log on
****** STU + Spell Adj, 2002-2007 *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

****** NE No Spell Adj, 2002-2007 *****************************
use "./MSnoA0207_NE.dta", clear

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

log on
****** NE No Spell Adj ,2002-2007 *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

// STU + Recalls + Spell Adj
*******************************************

use "./MSnoA0207_recalls.dta", clear

by id: replace nup = _n if upper==1
keep if nup<3

gen n_spell_u=nup

quietly do "./UPPER.do"

log on
****** STU + Recalls + Spell Adj, 2002-2007 *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off


****** NE + Spell Adj, 2002-2007 *****************************
use "./MSnoA0207_NE.dta", clear

by id: replace nup = _n if upper==1
keep if nup<3

// Re-count
drop max_nup
by id: egen max_nup = count(nup)

//Won't be in upper - too few observations
drop if max_nup<2

gen n_spell_u=nup

quietly do "./UPPER.do"

log on
****** NE + Spell Adj, 2002-2007 *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

********************************************************************************
* PART 2: 2008-2013
********************************************************************************

****** RAW, 2008-2013 *****************************
use "./MSnoA0813.dta", clear

keep if max_nuc==2
keep if nuc!=.

gen n_spell_u=nuc

quietly do "./LOWER_LOWER.do"

log on
****** RAW, 2008-2013 *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

****** LTU, 2008-2013 *****************************
use "./MSnoA0813.dta", clear

keep if max_nuc==2
keep if nuc!=.

gen n_spell_u=nuc

quietly do "./LOWER.do"

log on
****** LTU, 2008-2013 *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

****** STU, 2008-2013 *****************************
use "./MSnoA0813.dta", clear

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

log on
****** STU, 2008-2013 *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

****** STU + Spell Adj, 2008-2013 *****************************
use "./MSnoA0813.dta", clear

by id: replace nup = _n if upper==1
keep if nup<3

// Re-count
drop max_nup
by id: egen max_nup = count(nup)

//Won't be in upper - too few observations
drop if max_nup<2

gen n_spell_u=nup

quietly do "./UPPER.do"

log on
****** STU + Spell Adj, 2008-2013 *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

// ****** NE No Spell Adj, 2008-2013 *****************************
use "./MSnoA0813_NE.dta", clear

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

log on
****** NE No Spell Adj, 2008-2013 *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

// STU + Recalls + Spell Adj
*******************************************

use "./MSnoA0813_recalls.dta", clear

by id: replace nup = _n if upper==1
keep if nup<3

gen n_spell_u=nup

quietly do "./UPPER.do"

log on
****** STU + Recalls + Spell Adj, 2008-2013 *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off


****** NE + Spell Adj, 2008-2013 *****************************
use "./MSnoA0813_NE.dta", clear

by id: replace nup = _n if upper==1
keep if nup<3

// Re-count
drop max_nup
by id: egen max_nup = count(nup)

//Won't be in upper - too few observations
drop if max_nup<2

gen n_spell_u=nup

quietly do "./UPPER.do"

log on
****** NE + Spell Adj, 2008-2013 *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

log close
