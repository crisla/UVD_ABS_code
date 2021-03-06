********************************************************************************
* DESCRIPTIVE STATS FILE II
********************************************************************************
* Composition II
****************************************************

log using ./results/descriptive_stats_part2.log, replace
log off

use "./MS.dta", clear

gen before84 =1 if year_in<1985
replace before84 =0 if before84==.

gen before92 =1 if year_in<1992
replace before92 =0 if before92==.

gen college = 1 if ed_d4==1
replace college = 0 if college==.

gen past_T = 1 if state_past_likely == "T"
replace past_T = 0 if past_T==.

gen past_P = 1 if state_past_likely == "P"
replace past_P = 0 if past_P==.

gen past_A = 1 if state_past_likely == "A"
replace past_A = 0 if past_A==.

* Adjust dummy
replace sex_d = sex_d - 1
replace sex_d = 1 if sex_d == -1

* Raw & LTU
************************
preserve

keep if max_nuc==2
keep if nuc!=.

log on
sum LLdays days_past age sex_d college year_in past_T past_P past_A before84 before92
log off

log on
sum Ldays days_past age sex_d college year_in past_T past_P past_A before84 before92
log off

restore

* STU
************************
preserve

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

log on
sum Bdays days_past age sex_d college year_in past_T past_P past_A before84 before92
log off

restore

* STU + Spell Adj
************************

by id: replace nup = _n if upper==1
keep if nup<3

log on
sum real_days_1 days_past age sex_d college year_in past_T past_P past_A before84 before92
log off

* STU + Spell Adj + recalls
****************************
use "./MS_recalls.dta", clear

gen before84 =1 if year_in<1985
replace before84 =0 if before84==.

gen before92 =1 if year_in<1992
replace before92 =0 if before92==.

gen college = 1 if ed_d4==1
replace college = 0 if college==.

gen past_T = 1 if state_past == "T"
replace past_T = 0 if past_T==.

gen past_P = 1 if state_past == "P"
replace past_P = 0 if past_P==.

gen past_A = 1 if state_past_likely == "A"
replace past_A = 0 if past_A==.

* Adjust dummy
replace sex_d = sex_d - 1
replace sex_d = 1 if sex_d == -1

by id: replace nup = _n if upper==1
keep if nup<3

log on
sum real_days_1 days_past age sex_d college year_in past_T past_P past_A before84 before92
log off

* NE - NO Spell Adj
************************

use "./MS_NE.dta", clear

gen before84 =1 if year_in<1985
replace before84 =0 if before84==.

gen before92 =1 if year_in<1992
replace before92 =0 if before92==.

gen college = 1 if ed_d4==1
replace college = 0 if college==.

gen past_T = 1 if state_past == "T"
replace past_T = 0 if past_T==.

gen past_P = 1 if state_past == "P"
replace past_P = 0 if past_P==.

gen past_A = 1 if state_past_likely == "A"
replace past_A = 0 if past_A==.

* Adjust dummy
replace sex_d = sex_d - 1
replace sex_d = 1 if sex_d == -1

preserve

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

log on
sum Bdays days_past age sex_d college year_in past_T past_P past_A before84 before92
log off

restore 

* NE
************************

by id: replace nup = _n if upper==1
keep if nup<3

log on
sum real_days_1 days_past age sex_d college year_in past_T past_P past_A before84 before92
log off

log close

