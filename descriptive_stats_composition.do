********************************************************************************
* DESCRIPTIVE STATS FILE I
********************************************************************************
* Composition I
****************************************************
log using ./results/descriptive_spells.log, replace
log off

use "./MS.dta", clear

log on
* Number affected by the spell adjustment
tab max_nup if id!=id[_n-1]

* Spells añadidos con STU
tab max_nuc if id!=id[_n-1]
log off

* Year in affected by spell adjustment and before 1984
* STU
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

gen before84 =1 if year_in<1985
replace before84 =0 if before84==.

log on
* STU (no adj)* * * * *
tab year_in
sum year_in, d
tab before84

tab self_emp
tab quit short_emp
log off

* STU + Spell correction
use "./MS.dta", clear

by id: replace nup = _n if upper==1
keep if nup<3

gen before84 =1 if year_in<1985
replace before84 =0 if before84==.

log on
* STU + spell adjustment * * * * *
tab year_in
sum year_in, d
tab before84

tab self_emp
tab quit short_emp
log off

// STU + Recalls + Spell correction
*******************************************

use "./baseline13.dta", clear

* Update days variable
replace days = dtout-dtin

* Update age variable
replace age = year(dtin) - year(dtbirth)

* Cleaning
quietly do "./cleaning_new_ne_recalls.do"

by id: replace nup = _n if upper==1
keep if nup<3

gen before84 =1 if year_in<1985
replace before84 =0 if before84==.

log on
* STU +spell adj. + recalls* * * * *
tab year_in
sum year_in, d
tab before84

tab recall
tab self_emp if recall==0
tab quit short_emp if recall==0
log off

* NE
*******************************************
use "./MS_NE.dta", clear

by id: replace nup = _n if upper==1
keep if nup<3

gen before84 =1 if year_in<1985
replace before84 =0 if before84==.

gen not_claimed =1 if U_ghost==1&short_emp==0&self_emp==0&quit==0
replace not_claimed =0 if not_claimed==.

log on
* NE * * * * *
tab year_in
sum year_in, d
tab before84

tab recall not_claimed
tab recall not_claimed, sum(real_days_1)
tab self_emp if recall==0&not_claimed==0
tab quit short_emp if recall==0&not_claimed==0
tab quit short_emp if recall==0&not_claimed==0, sum(real_days_1)

tab recall short_emp

log close
