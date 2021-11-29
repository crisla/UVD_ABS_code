********************************************************************************
* SAMPLE SELECTION FILE
********************************************************************************
use "./baseline13.dta", clear

* Update days variable
replace days = dtout-dtin

* Update age variable
replace age = year(dtin) - year(dtbirth)

sort id jobcount dtin

// *************************************************************************
* Prep part 1: apply unemployment expansions
quietly do  "./u_expansions.do"

* Sample selection -1996
drop if (dtin < td(01jan1996)&state==state2)| (dtout < td(01jan1996)&state!=state2)

* Identify STU cases
sort id upper jobcount
by id upper: gen nup = _n if upper == 1

* count spells
sort id jobcount
by id: egen max_nup = max(nup)
replace max_nup = 0 if max_nup  ==.
by id: replace max_nup = . if _n!=_N
by id: replace max_nup = 2 if max_nup>2&max_nup!=.

//Table with 1 spell cases
log using "./sample_selection/spell_count.log",replace
tab max_nup 
log close
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
