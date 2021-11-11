log using ./results/BC_educ_noA_x_noage.log,replace
********************************************************************************
*									       *
*				BC Decomposition			       *
*									       *
********************************************************************************
log off
********************************************************************************

********************************************************************************
* PART 1: 2002-2007
********************************************************************************

****** RAW, 2002-2007 *****************************
use "./MSnoA0207.dta", clear

keep if max_nuc==2
keep if nuc!=.

gen n_spell_u=nuc

preserve

drop if ed_d4==0

quietly do "./LOWER_LOWER_x_noage.do"

log on
****** RAW, 2002-2007, college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

restore

drop if ed_d4==1

quietly do "./LOWER_LOWER_x_noage.do"

log on
****** RAW, 2002-2007, no college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

****** LTU, 2002-2007 *****************************
use "./MSnoA0207.dta", clear

keep if max_nuc==2
keep if nuc!=.

gen n_spell_u=nuc

preserve

drop if ed_d4==0

quietly do "./LOWER_x_noage.do"

log on
****** LTU, 2002-2007, college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

restore

drop if ed_d4==1

quietly do "./LOWER_x_noage.do"

log on
****** LTU, 2002-2007, no college *****************************
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

preserve

drop if ed_d4==0

quietly do "./LOWER_PLUS_x_noage.do"

log on
****** STU, 2002-2007, college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

restore

drop if ed_d4==1

quietly do "./LOWER_PLUS_x_noage.do"

log on
****** STU, 2002-2007, no college *****************************
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

preserve

drop if ed_d4==0

quietly do "./UPPER_x_noage.do"

log on
****** STU + Spell Adj, 2002-2007, college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

restore

drop if ed_d4==1

quietly do "./UPPER_x_noage.do"

log on
****** STU + Spell Adj, 2002-2007, no college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off


// STU + Recalls + Spell Adj
*******************************************

use "./MSnoA0207_recalls.dta", clear

by id: replace nup = _n if upper==1
keep if nup<3

gen n_spell_u=nup

preserve

drop if ed_d4==0

quietly do "./UPPER_x_noage.do"

log on
****** STU + Recalls + Spell Adj, 2002-2007, college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

restore

drop if ed_d4==1

quietly do "./UPPER_x_noage.do"

log on
****** STU + Recalls + Spell Adj, 2002-2007, no college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

// NE - No Spell Adj
*******************************************
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

preserve

drop if ed_d4==0

quietly do "./LOWER_PLUS_x_noage.do"

log on
****** NE  No Spell Adj, 2002-2007, college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

restore

drop if ed_d4==1

quietly do "./LOWER_PLUS_x_noage.do"

log on
****** NE  No Spell Adj, 2002-2007, no college *****************************
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

preserve

drop if ed_d4==0

quietly do "./UPPER_x_noage.do"

log on
****** NE + Spell Adj, 2002-2007, college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

restore

drop if ed_d4==1

quietly do "./UPPER_x_noage.do"

log on
****** NE + Spell Adj, 2002-2007, no college *****************************
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

preserve

drop if ed_d4==0

quietly do "./LOWER_LOWER_x_noage.do"

log on
****** RAW, 2008-2013, college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

restore

drop if ed_d4==1

quietly do "./LOWER_LOWER_x_noage.do"

log on
****** RAW, 2008-2013, no college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

****** LTU, 2008-2013 *****************************
use "./MSnoA0813.dta", clear

keep if max_nuc==2
keep if nuc!=.

gen n_spell_u=nuc

preserve

drop if ed_d4==0

quietly do "./LOWER_x_noage.do"

log on
****** LTU, 2008-2013, college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

restore

drop if ed_d4==1

quietly do "./LOWER_x_noage.do"

log on
****** LTU, 2008-2013, no college *****************************
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

preserve

drop if ed_d4==0

quietly do "./LOWER_PLUS_x_noage.do"

log on
****** STU, 2008-2013, college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

restore

drop if ed_d4==1

quietly do "./LOWER_PLUS_x_noage.do"

log on
****** STU, 2008-2013, no college *****************************
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

preserve

drop if ed_d4==0

quietly do "./UPPER_x_noage.do"

log on
****** STU + Spell Adj, 2008-2013, college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

restore

drop if ed_d4==1

quietly do "./UPPER_x_noage.do"

log on
****** STU + Spell Adj, 2008-2013, no college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

// STU + Recalls + Spell adjustment
*******************************************

use "./MSnoA0813_recalls.dta", clear

by id: replace nup = _n if upper==1
keep if nup<3

gen n_spell_u=nup

preserve

drop if ed_d4==0

quietly do "./UPPER_x_noage.do"

log on
****** STU + Recalls + Spell Adj, 2008-2013, college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

restore

drop if ed_d4==1

quietly do "./UPPER_x_noage.do"

log on
****** STU + Recalls + Spell Adj, 2008-2013, no college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

// NE - No Spell Adj
*******************************************
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

preserve

drop if ed_d4==0

quietly do "./LOWER_PLUS_x_noage.do"

log on
****** NE  No Spell Adj, 2008-2013, college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

restore

drop if ed_d4==1

quietly do "./LOWER_PLUS_x_noage.do"

log on
****** NE  No Spell Adj, 2008-2013, no college *****************************
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

preserve

drop if ed_d4==0

quietly do "./UPPER_x_noage.do"

log on
****** NE + Spell Adj, 2008-2013, college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

restore

drop if ed_d4==1

quietly do "./UPPER_x_noage.do"

log on
****** NE + Spell Adj, 2008-2013, no college *****************************
sum mu_y sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log off

log close
