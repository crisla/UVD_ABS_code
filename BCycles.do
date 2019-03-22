********************************************************************************
*									       *
*				PART 1: 2002-2007			       *
*									       *
********************************************************************************

use "./baseline13.dta", clear


* Get rid of unfinished cases
drop if dtout>td(31dec2007)|dtout<td(31dec2001)
replace age = (dtin - dtbirth)/365

sort id jobcount

quietly do  "./cleaning_new_ne.do"

saveold "./MS0207.dta", replace

********************************************************************************
*									       *
*				PART 2: 2008-2013			       *
*									       *
********************************************************************************

use "./baseline13.dta", clear

* Get rid of unfinished cases
drop if dtout>td(31dec2013)|dtout<=td(31dec2007)
replace age = (dtin - dtbirth)/365

sort id jobcount

quietly do  "./cleaning_new.do"

saveold "./MS0813.dta", replace


********************************************************************************
// calculating Upper (Spell Number Correction + STU Expansion)
********************************************************************************
* 2002-2007
use "./MS0207.dta", clear

by id: replace nup = _n if upper==1
keep if nup<3

gen n_spell_u=nuc

do "./UPPER.do"

****** EXPORT *****************************
log using ./results/table_upper07.log,replace
sum sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log close

********************************************************************************
* 2008-2013
use "./MS0813.dta", clear
s
by id: replace nup = _n if upper==1
keep if nup<3

gen n_spell_u=nuc

do "./UPPER.do"


****** EXPORT *****************************
log using /results/table_upper13.log,replace
sum sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log close

********************************************************************************
// calculating Lower+ (STU Expansion)
********************************************************************************
* 2002-2007

use "./MS0207.dta", clear

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

do "./LOWER_PLUS.do"

sum lsig_y lsig_c lsig_e lsig_b plsig_c plsig_e plsig_b 

****** EXPORT *****************************
log using /results/table_lower_plus07.log,replace
sum sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log close

********************************************************************************
* 2008-2013
use "./MS0813.dta", clear

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

do "./LOWER_PLUS.do"

****** EXPORT *****************************
log using ./results/table_lower_plus13.log,replace
sum sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log close

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
