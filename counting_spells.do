*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
* Counting spells
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

// *-*-*-*-*-*-*-*- Censored: belongs to Lower Bound -*-*-*-*-*-*-*-*-*-
//
// by id: gen censored = 1 if state[_n]=="U"&state_future!="U"&state_future!=""
// replace censored =0 if censored==.

sort id censored jobcount
by id censored: gen nuc = _n if censored == 1
replace censored =0 if nuc>2 
// by id: gen max_nuc = sum(censored)
// by id: replace max_nuc = . if _n!=_N

sort id jobcount

by id: egen max_nuc = max(nuc)
replace max_nuc = 0 if max_nuc  ==.
//replace censored =0 if max_nuc<2

*-*-*-*-*-*-*-*- Upper: belongs to Upper Bound -*-*-*-*-*-*-*-*

// sort id jobcount
//
// by id: gen upper=1 if state2[_n]=="U"&state_future!="U"&state_future!=""
// replace upper=0 if upper==.

// by id: gen max_nup = sum(upper)
// by id: replace max_nup = . if _n!=_N

sort id upper jobcount
by id upper: gen nup = _n if upper == 1
// replace upper=0  if nup>2

sort id jobcount
by id: egen max_nup = max(nup)
replace max_nup = 0 if max_nup  ==.
//replace upper=0  if max_nup<2

*to get number of individuals with less than 1 spell
// log using ./results/spell_no.log,replace
// tab max_nup if id!=id[_n-1] 
// log close

********************************************************************************
// Won't be in either of them
drop if censored==0&upper==0

//Will be in either of those
drop if nuc>2&nup>2

// Re-count
drop max_nup max_nuc
by id: egen max_nup = count(nup)
by id: egen max_nuc = count(nuc)

// log on
// tab max_nup if id!=id[_n-1]
// log close

//Won't be in upper - too few observations
drop if max_nup<2

// Missing information on days (?)
replace nuc=. if Ldays==.&max_nuc==2

drop max_nuc
by id: egen max_nuc = count(nuc)

* In case of keeping the guys with one spell only
// saveold "/home/clafuente/MS/MS_1spell.dta", replace
