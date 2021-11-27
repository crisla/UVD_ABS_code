

log using ./results/all_results_educ_noA.log, replace


********************************************************************************
// calculating Lower Lower (Raw data)
********************************************************************************

use "./MS_noA.dta", clear

keep if max_nuc==2
keep if nuc!=.

gen n_spell_u=nuc

preserve

drop if ed_d4==0

quietly do "./LOWER_LOWER.do"

log on
****** Raw, college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

restore

drop if ed_d4==1

quietly do "./LOWER_LOWER.do"

log on
****** Raw, no college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

********************************************************************************
// calculating Lower (LTU Expansion)
********************************************************************************
* 1.
use "./MS_noA.dta", clear

keep if max_nuc==2
keep if nuc!=.

gen n_spell_u=nuc

preserve

drop if ed_d4==0

quietly do "./LOWER.do"

log on
****** LTU, college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

restore

drop if ed_d4==1

quietly do "./LOWER.do"

log on
****** LTU, no college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off


********************************************************************************
// calculating Lower+ (STU Expansion)
********************************************************************************
use "./MS_noA.dta", clear

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

preserve

drop if ed_d4==0

quietly do "./LOWER_PLUS.do"

log on
****** STU, college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

restore

drop if ed_d4==1

quietly do "./LOWER_PLUS.do"

log on
****** STU, no college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off


********************************************************************************
// calculating uncensored (Spell Number correction + STU)
********************************************************************************
use "./MS_noA.dta", clear

by id: replace nup = _n if upper==1
keep if nup<3

gen n_spell_u=nup

preserve

drop if ed_d4==0

quietly do "./UPPER.do"

log on
****** STU+Spell Adj, college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

restore

drop if ed_d4==1

quietly do "./UPPER.do"

log on
****** STU+Spell Adj, no college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off


********************************************************************************
// Non-Employment
********************************************************************************

// use "./baseline13.dta", replace

// * Update days variable
// replace days = dtout-dtin
//
// * Update age variable
// replace age = year(dtin) - year(dtbirth)
//
// drop if dtin >= td(01jan2008)
//
// sort id jobcount dtin

// * Cleaning
// quietly do "./cleaning_new_ne.do"

// sort id jobcount dtin
// quietly do  "./u_expansions_ne.do"
// * Sample selection
// drop if dtin >= td(01jan2008)
//
// * Prep part 2: count spells
// quietly do  "./counting_spells.do"
//
// * Save
// saveold "./MS_noA_NE.dta", replace

// STU + Recalls + Spell correction
*******************************************

use "./MS_noA_recalls.dta", clear

by id: replace nup = _n if upper==1
keep if nup<3

gen n_spell_u=nup

preserve

drop if ed_d4==0

quietly do "./UPPER.do"

log on
****** STU + Recalls + Spell Adj, college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

restore

drop if ed_d4==1

quietly do "./UPPER.do"

log on
****** STU + Recalls + Spell Adj, no college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

// No Spell correction
*******************************************
use "./MS_noA_NE.dta", clear

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

preserve

drop if ed_d4==0

quietly do "./LOWER_PLUS.do"

log on
****** NE (NO Spell Adj), college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

restore

drop if ed_d4==1

quietly do "./LOWER_PLUS.do"

log on
****** NE (NO Spell Adj), no college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

// NE with Spell Adjustment
********************************************************************************
use "./MS_noA_NE.dta", clear

by id: replace nup = _n if upper==1
keep if nup<3

gen n_spell_u=nup

preserve

drop if ed_d4==0

quietly do "./UPPER.do"

log on
****** NE+Spell Adj, college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

restore

drop if ed_d4==1

quietly do "./UPPER.do"

log on
****** NE+Spell Adj, no college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
log close
