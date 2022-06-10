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

preserve
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
* Sample selection -1996
drop if (dtin < td(01jan1996)&state==state2)| (dtout < td(01jan1996)&state!=state2)

* Identify STU cases
sort id upper jobcount
by id upper: gen nup = _n if upper == 1
// drop if nup>2

* count spells
sort id jobcount
by id: egen max_nup = max(nup)
replace max_nup = 0 if max_nup  ==.

log using "./sample_selection/spell_count_pp.log",replace
sum max_nup if id!=id[_n+1]&max_nup>1, d
log close

by id: replace max_nup = 2 if max_nup>2

keep if nup==2|nup==1&max_nup==1|max_nup==0
by id: keep if (_n==1&max_nup==0)|max_nup>0

//Table with 1 spell cases
log using "./sample_selection/spell_count.log",replace
tab max_nup 
log close

// gen college = (educ2==4)
replace ed_d4=0 if ed_d4==.

log using "./sample_selection/spell_count_college.log",replace
tab max_nup ed_d4
log close

* Export observations

drop if upper==0
drop if nup>2

// Re-count
drop max_nup
by id: egen max_nup = count(nup)

gen blank_type = "quit" if U_ghost==1&quit==1&recall==0
replace blank_type = "SE" if U_ghost==1&self_emp==1&recall==0
replace blank_type = "short" if U_ghost==1&short_emp==1&recall==0
replace blank_type = "recall" if U_ghost==1&recall==1
replace blank_type ="other" if U_ghost==1&recall==0&quit==0&self_emp==0&short_emp==0

* Export spells to a csv for plots
gen n_spell_u=nup
gen yin = year(dtin)
replace U_ghost=0 if U_ghost==.
export delimited real_days_1 n_spell_u yin blank_type U_ghost max_nup using "./sample_selection/Upper1.csv", replace

restore
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
* Sample selection: 2002-2007
preserve
drop if dtout>td(31dec2007)|dtout<td(31dec2001)

* Identify STU cases
sort id upper jobcount
by id upper: gen nup = _n if upper == 1
// drop if nup>2

* count spells
sort id jobcount
by id: egen max_nup = max(nup)
replace max_nup = 0 if max_nup  ==.
by id: replace max_nup = 2 if max_nup>2

keep if nup==2|nup==1&max_nup==1|max_nup==0
by id: keep if (_n==1&max_nup==0)|max_nup>0

//Table with 1 spell cases
log using "./sample_selection/spell_count0207.log",replace
tab max_nup 
log close

// gen college = (educ2==4)
replace ed_d4=0 if ed_d4==.

log using "./sample_selection/spell_count_college0207.log",replace
tab max_nup ed_d4
log close

* Export observations

drop if upper==0
drop if nup>2

// Re-count
drop max_nup
by id: egen max_nup = count(nup)

gen blank_type = "quit" if U_ghost==1&quit==1&recall==0
replace blank_type = "SE" if U_ghost==1&self_emp==1&recall==0
replace blank_type = "short" if U_ghost==1&short_emp==1&recall==0
replace blank_type = "recall" if U_ghost==1&recall==1
replace blank_type ="other" if U_ghost==1&recall==0&quit==0&self_emp==0&short_emp==0

* Export spells to a csv for plots
gen n_spell_u=nup
gen yin = year(dtin)
replace U_ghost=0 if U_ghost==.
export delimited real_days_1 n_spell_u yin blank_type U_ghost max_nup using "./sample_selection/Upper10207.csv", replace

restore
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
* Sample selection: 2008-2013
drop if dtout>td(31dec2013)|dtout<=td(31dec2007)

* Identify STU cases
sort id upper jobcount
by id upper: gen nup = _n if upper == 1
// drop if nup>2

* count spells
sort id jobcount
by id: egen max_nup = max(nup)
replace max_nup = 0 if max_nup  ==.
by id: replace max_nup = 2 if max_nup>2

keep if nup==2|nup==1&max_nup==1|max_nup==0
by id: keep if (_n==1&max_nup==0)|max_nup>0

//Table with 1 spell cases
log using "./sample_selection/spell_count0813.log",replace
tab max_nup 
log close

// gen college = (educ2==4)
replace ed_d4=0 if ed_d4==.

log using "./sample_selection/spell_count_college0813.log",replace
tab max_nup ed_d4
log close

* Export observations

drop if upper==0
drop if nup>2

// Re-count
drop max_nup
by id: egen max_nup = count(nup)

gen blank_type = "quit" if U_ghost==1&quit==1&recall==0
replace blank_type = "SE" if U_ghost==1&self_emp==1&recall==0
replace blank_type = "short" if U_ghost==1&short_emp==1&recall==0
replace blank_type = "recall" if U_ghost==1&recall==1
replace blank_type ="other" if U_ghost==1&recall==0&quit==0&self_emp==0&short_emp==0

* Export spells to a csv for plots
gen n_spell_u=nup
gen yin = year(dtin)
replace U_ghost=0 if U_ghost==.
export delimited real_days_1 n_spell_u yin blank_type U_ghost max_nup using "./sample_selection/Upper10813.csv", replace
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
