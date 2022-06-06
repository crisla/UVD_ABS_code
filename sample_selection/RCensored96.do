********************************************************************************
* RIGHT-CENSORED SPELLS
********************************************************************************
* PART 1: Formatting
// *************************************************************************

use "./baseline13.dta", clear

* Update days variable
replace days = dtout-dtin

* Update age variable
replace age = year(dtin) - year(dtbirth)

sort id jobcount dtin

// *************************************************************************
* Prep part 1: apply unemployment expansions up to the final clean up 
* (follows u_expansions.do up to line 119)

* Unify consecutive unemploymetn spells:
* --------------------------------------
sort id jobcount dtin
* Some unemployment spells overlap due to administrative reasons, mostly
* expiration of regular unemployment insurance.
* This modification is useful when tabulating in quarters and for duration calculation.
gen dupu =0
by id : replace dupu = 1 if state=="U"&state[_n+1]=="U"
by id : replace dupu = dupu[_n-1]+1 if state=="U"&state[_n-1]=="U"

by id : gen dupu_cut = 1 if dupu==1&dupu[_n+1]==2
by id : replace dupu_cut=sum(dupu_cut) if state=="U"&dupu>0

sort id dupu_cut jobcount dtin dupu
by id dupu_cut: replace dtout=dtout[_N] if state=="U"&dupu==1&dupu[_n+1]>1

drop if dupu>1
drop dupu dupu_cut

replace days = dtout-dtin

sort id jobcount dtin dtout

* *****
* Recalls, part I
gen firmID = firm1+firm2
by id: gen recall_legit= (state=="U"&firmID[_n-1]==firmID[_n+1]&state[_n+1]!="U"&firmID!="00")

sort id jobcount dtin dtout
by id: gen diff_days = dtin[_n+1]-dtout[_n]
replace diff_days = 0 if diff_days==.

gen LLdays = days
sort id jobcount
by id: replace LLdays = LLdays[_n] + diff_days[_n-1] if state[_n]=="U"&state[_n-1]!="U"

gen Ldays = LLdays
by id: replace Ldays  = Ldays + diff_days if state[_n]=="U"&state[_n+1]!="U"

sort id jobcount 
gen real_days_1 = Ldays
// by id: replace real_days_1  = real_days_1 + diff_days if state[_n]=="U"&state[_n+1]!="U"&diff_days>0

*-*-*-*-*-*-*-*- Count gaps between employment too -*-*-*-*-*-*-*-*

gen state2 = state
by id: gen U_ghost = 1 if state[_n]!="U"&state[_n+1]!="U"&diff_days>1&diff_days!=.

* Recalls, part II : Gaps between employment spells added by the correction
* -----------------------------------------------------
sort id jobcount dtin dtout
by id: gen recall= (U_ghost==1&firmID==firmID[_n+1]&state[_n+1]!="U"&firmID!="00")
// by id: replace recall=0 if recall==.

* Self-Employment:
* -----------------------------------------------------
by id: gen self_emp = 0
by id: replace self_emp = 1 if U_ghost==1&state=="A"

* Quits 
* -----------------------------------------
by id: replace quit=0
by id: replace quit=1 if U_ghost==1&cause==51

* Short employment
* -----------------------------------------------------
sort id state jobcount dtin
// by id state: gen NoU = _n if state=="U"
gen emp_count = 0 if state=="U"|state=="R"
replace emp_count = days if state!="U"&state!="R"
//
// sort id jobcount dtin
// by id: replace NoU = NoU[_n-1] if NoU==.
// replace NoU = 0 if NoU==.

sort id NoU jobcount dtin
by id NoU: gen emp_spell = sum(emp_count)
gen short_emp = 0
replace short_emp = 1 if emp_spell<360 & year(dtout)>=1992 & (state=="T"|state=="P")
replace short_emp = 1 if emp_spell<180 & year(dtout)<1992 & (state=="T"|state=="P")
sort id jobcount dtin

* Trim recalls etc
* -----------------------------------------------------
replace U_ghost = 0 if U_ghost==1&recall==1
replace U_ghost = 0 if U_ghost==1&short_emp==0&self_emp==0&quit==0
// replace U_ghost = 0 if U_ghost==1&quit==1&diff_days<=7

drop if recall_legit==1

* Count Gaps too
* -----------------------------------------------------
sort id jobcount
by id: replace state2="U" if U_ghost == 1 & U_ghost != .
by id: replace real_days_1  = diff_days if U_ghost == 1 & U_ghost != .

*-*-*-*-*-*-*-*- Cleaning -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
drop if real_days_1<0
drop if real_days_1 ==.
drop if real_days_1 <= 0

drop if LLdays<=0
drop if Ldays <= 0
drop if days<=0

sort id jobcount dtin dtout
by id: gen state_future = state[_n+1]
by id: gen state_past = state[_n-1] if state == state2
by id: replace state_past = state if state != state2 & U_ghost == 1

by id: gen days_past = days[_n-1] if state == state2
by id: replace days_past = days if state != state2 & U_ghost == 1

gen state_past_likely = state_past
replace state_past_likely = "T" if days_past<365&state_past=="P"&year(dtin)<1995

* Age restriction
drop if age<25|age>50

* Time restriction
drop if (dtin < td(01jan1996)&state==state2)| (dtout < td(01jan1996)&state!=state2)

// *************************************************************************
* Prep part 2: Identify and count censored spells

*-*-*-*-*-*-*-*- Right-Censored: sample ends before spell -*-*-*-*-*-*-*-*-*-

gen original_enddate = date(baja,"YMD")
format original_enddate %td

by id: gen Rcensored = ((state[_n]=="U"|state2[_n]=="U")&state_future==""&_n==_N&original_enddate>=td(31dec2013))

*-*-*-*-*-*-*-*- Censored: belongs to Lower Bound -*-*-*-*-*-*-*-*-*-

by id: gen censored = 1 if state[_n]=="U"&state_future!="U"&state_future!=""
replace censored = 0 if censored==.

*-*-*-*-*-*-*-*- Upper: belongs to Upper Bound -*-*-*-*-*-*-*-*

by id: gen upper=1 if state2[_n]=="U"&state_future!="U"&state_future!=""
replace upper=0 if upper==.


*-*-*-*-*-*-*-*- Count Censored+: belongs to Lower Bound or right-censored -*-*-*-*-*-*-*-*-*-

gen censored_plus = (censored==1|Rcensored==1)
sort id censored_plus jobcount
by id censored_plus: gen nurc = _n if censored_plus == 1
replace censored_plus =0 if nurc>2 

sort id jobcount
by id: egen max_nurc = max(nurc)
replace max_nurc = 0 if max_nurc  ==.

*-*-*-*-*-*-*-*- Count Censored: belongs to Lower Bound -*-*-*-*-*-*-*-*-*-

sort id censored jobcount
by id censored: gen nuc = _n if censored == 1
replace censored =0 if nuc>2 

sort id jobcount
by id: egen max_nuc = max(nuc)
replace max_nuc = 0 if max_nuc  ==.

*-*-*-*-*-*-*-*- Count Upper+: belongs to Upper Bound or right-censored -*-*-*-*-*-*-*-*-*-

gen upper_plus = (upper==1|Rcensored==1)
sort id upper_plus jobcount
by id upper_plus: gen nurp = _n if upper_plus == 1
replace upper_plus =0 if nurp>2 

sort id jobcount
by id: egen max_nurp = max(nurp)
replace max_nurp = 0 if max_nurp  ==.

*-*-*-*-*-*-*-*- Count Upper: belongs to Upper Bound -*-*-*-*-*-*-*-*

sort id upper jobcount
by id upper: gen nup = _n if upper == 1

sort id jobcount
by id: egen max_nup = max(nup)
replace max_nup = 0 if max_nup  ==.

********************************************************************************
// Won't be in either of them
drop if censored==0&upper==0&censored_plus==0&upper_plus==0

gen obs_ltu_rcensored = max_nurc - max_nuc
// replace obs_ltu_rcensored = 0 if max_nuc>=2

gen obs_stu_rcensored = max_nurp - max_nup
// replace obs_ltu_rcensored = 0 if max_nuc>=2

log using "./sample_selection/table_lower_plus.log",replace

tabstat Rcensored, s(sum)

sum Rcensored if id!=id[_n+1]

tab obs_ltu_rcensored if id!=id[_n+1]&max_nuc==1

tab obs_stu_rcensored if id!=id[_n+1]&max_nup==1
log close


********************************************************************************
