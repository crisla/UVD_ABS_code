use "./baseline13.dta", replace

* Update days variable
replace days = dtout-dtin

* Update age variable
replace age = year(dtin) - year(dtbirth)

sort id jobcount dtin

********************************************************************************
* Cleaning
quietly do "./cleaning_new.do"

saveold "./MS.dta", replace


* The following code creates an alternative version without spells less than 15 days
// gen spell15=0
// replace spell15=1 if real_days_1<=15

// log using "./ind15.smcl",replace
// tab ind_short censored if spell15==1
// log close
// translate "./ind15.smcl" "./ind15.log",replace

// saveold "./MSalt.dta", replace

********************************************************************************
// calculating Lower (LTU Expansion)
********************************************************************************
* 1.
use "./MS.dta", clear

keep if max_nuc<=2
keep if nuc!=.

gen n_spell_u=nuc

quietly do "./LOWER.do"

sum lsig_y lsig_c lsig_e lsig_b plsig_c plsig_e plsig_b

****** EXPORT *****************************

log using ./results/table_lower.log,replace
sum sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log close

gen yin = year(dtin)

* Export spells to a csv for plots
export delimited Ldays n_spell_u yin using "./results/Lower.csv", replace

********************************************************************************
// calculating Lower Lower (Raw data)
********************************************************************************

use "./MS.dta", clear

keep if max_nuc==2
keep if nuc!=.

gen n_spell_u=nuc

quietly do "./LOWER_LOWER.do"

sum lsig_y lsig_c lsig_e lsig_b plsig_c plsig_e plsig_b 

****** EXPORT *****************************

log using ./results/table_lowest.log,replace
sum sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log close

gen yin = year(dtin)

* Export spells to a csv for plots
export delimited LLdays n_spell_u yin using "./results/LLower.csv", replace

********************************************************************************
// calculating uncensored (Spell Number correction + STU)
********************************************************************************
use "./MS.dta", clear

by id: replace nup = _n if upper==1
keep if nup<3

gen n_spell_u=nup

quietly do "./UPPER.do"

sum lsig_y lsig_c lsig_e lsig_b plsig_c plsig_e plsig_b 

****** EXPORT *****************************

log using ./results/table_upper.log,replace
sum sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log close

gen yin = year(dtin)

* Export spells to a csv for plots
export delimited real_days_1 n_spell_u yin using "./results/Upper.csv", replace

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

sum lsig_y lsig_c lsig_e lsig_b plsig_c plsig_e plsig_b 

****** EXPORT *****************************
log using ./results/table_lower_plus.log,replace
sum sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log close

gen yin = year(dtin)

gen n_spell_u=nuc2

* Export spells to a csv for plots
export delimited Bdays n_spell_u yin using "./results/STU.csv", replace


********************************************************************************
// Non-Employment
********************************************************************************

use "./baseline13.dta", replace

* Update days variable
replace days = dtout-dtin

* Update age variable
replace age = year(dtin) - year(dtbirth)

sort id jobcount dtin

* Cleaning
quietly do "./cleaning_new_ne.do"

saveold "./MS_NE.dta", replace

// STU Expansion (no Spell correction)
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

sum lsig_y lsig_c lsig_e lsig_b plsig_c plsig_e plsig_b 

****** EXPORT *****************************

log using ./results/table_ne.log, replace
sum sig_y sig_c sig_e sig_b lsig_y lsig_c lsig_e lsig_b psig_c psig_e psig_b plsig_c plsig_e plsig_b lsig_y2 sig_x lsig_c lsig_e2 lsig_b2 lpsig_x lpsig_e lpsig_b
log close

gen yin = year(dtin)

gen n_spell_u=nuc2

* Export spells to a csv for plots
export delimited real_days_1 n_spell_u yin using "./results/NE.csv", replace

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
