// use "./sample_selection/MS32.dta", clear
use "./sample_selection/baseline13.dta", replace
replace days = dtout-dtin

* Update age variable
replace age = year(dtin) - year(dtbirth)

sort id jobcount dtin

********************************************************************************
* Cleaning
quietly do "./sample_selection/cleaning_1spell.do"

// 27.06% have only ONE completed non-employment spell

saveold "./sample_selection/MS_1spell.dta", replace

//To export a table with 1 spell cases
// log using "./sample_selection/spell_count.log",replace
// tab max_nup max_nuc if id!=id[_n-1]
// log close


********************************************************************************
// calculating Lower (LTU Expansion)
********************************************************************************

use "./sample_selection/MS_1spell.dta", clear

keep if max_nuc<=2
keep if nuc!=.

gen n_spell_u=nuc

gen yin = year(dtin)

export delimited Ldays n_spell_u yin using "./sample_selection/Lower1.csv", replace

********************************************************************************
// calculating Lower Lower (Raw data)
********************************************************************************

use "./sample_selection/MS_1spell.dta", clear

keep if max_nuc==2
keep if nuc!=.

gen n_spell_u=nuc

gen yin = year(dtin)

export delimited LLdays n_spell_u yin using "./sample_selection/LLower1.csv", replace


********************************************************************************
// calculating uncensored (STU + Spell adjustment)
********************************************************************************
use "./sample_selection/MS_1spell.dta", clear

by id: replace nup = _n if upper==1
keep if nup<3

gen n_spell_u=nup

gen yin = year(dtin)

export delimited real_days_1 n_spell_u yin using "./sample_selection/Upper1.csv", replace

********************************************************************************
// calculating Lower+ (STU)
********************************************************************************
use "./sample_selection/MS53.dta", clear

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

gen yin = year(dtin)

gen n_spell_u=nuc2

export delimited Bdays n_spell_u yin using "./sample_selection/STU1.csv", replace
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
