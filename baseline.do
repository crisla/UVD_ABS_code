**  LOADING THE 2013 FILE ***************************************************

use "./data/afilianon2013.dta",clear

* Old contract correction ***************************************************
* Other, older temporary contracts:
replace state = "T" if tyco>=4&tyco<8
replace state = "T" if tyco>=14&tyco<18
replace state = "T" if tyco==22|(tyco>=24&tyco<28)
replace state = "T" if tyco>=34&tyco<39
replace state = "T" if tyco>=53&tyco<59
replace state = "T" if tyco==64|(tyco>=66&tyco<69)
replace state = "T" if tyco>=72&tyco<100
* Other, older permanet contracts:
replace state = "P" if tyco==18
replace state = "P" if tyco>0&tyco<4
replace state = "P" if tyco>10&tyco<14
replace state = "P" if tyco==20|tyco==23
replace state = "P" if tyco>=28&tyco<34
replace state = "P" if tyco>=39&tyco<53
replace state = "P" if tyco>=59&tyco<64
replace state = "P" if tyco==65
replace state = "P" if tyco>=69&tyco<72

* Pensions ********************************************************
append using "./data/pension2013.dta"
* New state: Retired (R)
sort id jobcount dtin
replace state = "R" if state=="" & p_type!=.
replace dtin = p_dtin if state=="R"
drop if state=="R"&id!=id[_n-1]&id!=id[_n+1]
by id: replace dtbirth = dtbirth[_n-1] if state=="R"
gen age_in = year(dtin)-year(dtbirth)

* Redefining unemployment for pensioneers
replace dtout = dtin[_n+1] if state=="U"&state[_n+1]=="R"
replace days = dtout-dtin if state=="U"&state[_n+1]=="R"
drop if dtin>td(31dec2013)
replace dtout=td(31dec2013) if  dtout>td(31dec2013)
gen ext_dt = dtout
*********************************************************************

* Prepare firm identifier
tostring firm2, replace
** Autonomous adjustment **
replace state = "A" if regi>700&regi<800
replace state = "A" if regi>824&regi<840
** Early retirement adjustment
replace state = "R" if regi==140


** CONTRACT MODIFICATION ADJUSTMENT ******************************************

* Format the date of 1st change of contract
gen mod1dt_copy = date(mod1dt,"YMD")
drop mod1dt
rename mod1dt_copy mod1dt
order mod1dt, before(mod1ty)
destring mod1ty,replace
* Format the date of 2nd change of contract
gen mod2dt_copy = date(mod2dt,"YMD")
drop mod2dt
rename mod2dt_copy mod2dt
order mod2dt, before(mod2ty)
destring mod2ty,replace
* Generate split variable if there was an effective  change in labour contract 
* on the 1st modification
gen statch1 = ""
replace statch1 = "T" if mod1ty> 400 & mod1ty < 900
replace statch1 = "P" if mod1ty>0 & mod1ty < 400
gen splitt = 1 if statch1!=""&state!=statch1&year(mod1dt)>=2004&year(mod1dt)<=2013
* Generate split2 variable if there was an effective change in labour contract 
* on the 2nd modification
gen statch2 = ""
replace statch2 = "T" if mod2ty> 400 & mod2ty < 900
replace statch2 = "P" if mod2ty>0 & mod2ty < 400
gen split2 = 1 if statch2!=""&state!=statch2&year(mod2dt)>=2004&year(mod2dt)<=2013
* If teh actual change came int he 2nd modification, do not count the first
replace splitt=. if statch1==statch2
* Separate the job spell into 2 periods with different contracts (1st mod)
expand 2 if splitt==1, gen(contract_change)
sort id dtin contract_change
by id: replace state = statch1 if contract_change==0&contract_change[_n+1]==1
by id: replace dtin = mod1dt if contract_change==1
by id: replace dtout = mod1dt if contract_change==0&contract_change[_n+1]==1
by id: replace cause = 50 if contract_change==0&contract_change[_n+1]==1	// Cause 50: promotion!
* Separate the job spell into 2 periods with different contracts (2nd mod)
expand 2 if split2==1, gen(contract_change2)
sort id dtin contract_change2
by id: replace state = statch2 if contract_change2==0&contract_change2[_n+1]==1
by id: replace dtin = mod2dt if contract_change2==1
by id: replace dtout = mod2dt if contract_change2==0&contract_change2[_n+1]==1
by id: replace cause = 50 if contract_change2==0&contract_change2[_n+1]==1	// Cause 50: promotion!


** CREATING VARIABLES ********************************************************

* Age variables
gen age_now = (2013- year(dtbirth))
gen cohort = year(dtbirth)
replace age = year(dtin) - year(dtbirth)

* NoP and NoT : number of P/T contracts held
sort id state jobcount
by id state: gen NoP = _n if state=="P"
by id state: gen NoT = _n if state=="T"
by id state: gen NoU = _n if state=="U"

* ExpT/P: days of experience in each contract type
by id state: gen ExpT = sum(days) if state=="T"
by id state: gen ExpP = sum(days) if state=="P"

* Filling gaps (after MaxT/P and AvT to avoid double counting)
sort id jobcount
by id: replace NoT=NoT[_n-1] if NoT==. //
replace NoT=0 if NoT==. 
by id: replace NoP=NoP[_n-1] if NoP==. //filling gaps
replace NoP=0 if NoP==. 
by id: replace NoU=NoU[_n-1] if NoU==. //filling gaps
replace NoU=0 if NoU==. 
by id: replace ExpT=ExpT[_n-1] if ExpT==. //
by id: replace ExpP=ExpP[_n-1] if ExpP==.
replace ExpT=0 if ExpT==.
replace ExpP=0 if ExpP==. 
* Passing to years
replace ExpT = ExpT/365
replace ExpP = ExpP/365

* Total number of contracts
sort id jobcount
by id: egen MaxP = max(NoP)
replace MaxP = 0 if MaxP==.
// sum MaxP if id[_n]!=id[_n-1], d
by id: egen MaxT = max(NoT)
replace MaxT = 0 if MaxT==.
//sum MaxT if id[_n]!=id[_n-1], d

* AvT: Average number of T contracts held
sort cohort id
by cohort: egen AvT = mean(MaxT) if id[_n]!=id[_n-1]

* Weeks since last unemployment spell
sort id NoU jobcount
by id NoU: gen weeksE = sum(days) if state!="U"
sort id jobcount
by id: replace weeksE=weeksE[_n-1] if weeksE==. 
replace weeksE = 0 if weeksE==.
replace weeksE = weeksE/7
gen yearsE = weeksE/52

* Previous tenure (NO UPGRADES) and labour status
sort id jobcount dtin dtout
by id: gen state1 = state[_n-1]
by id: gen days1 = days[_n-1]
by id: gen nextS = state[_n+1]

* First_P: first permanent contract
by id: gen First_P = NoT if NoP[_n]==1&NoP[_n-1]==0

* Dummy for last contract being permanet (and its tenure interaction dummy)
by id: gen lastP = 1 if state1=="P"
by id: replace lastP =0 if lastP==.
by id: gen lastA = 1 if state1=="A"
by id: replace lastA =0 if lastA==.
gen lastPdays = days1*lastP 

* Long-term unemployment (greater than a year)
by id: gen LTU1 = 1 if state=="U"&days>=365
replace LTU1 = 0 if LTU1==.
* Long-term unemployment (greater than 2 years)
by id: gen LTU2 = 1 if state=="U"&days>=730
replace LTU2 = 0 if LTU2==.

* Dummy for sex (1 is male)
gen sex_d = 1 if sex==1
replace sex_d = 0 if sex_d==.

* Formating  education
replace education = "0" if education=="C0"
destring(education), replace
gen educ2 = .
* 1: less than primary studies
replace educ2 = 1 if education <30
* 2: less than secondary studies/primary studiues and some more 
* (graduado escolar + FP basic)
replace educ2 = 2 if education >=30 & education <40
* 2: Secondary studies
* (FP Superior + Bachiller + BUP)
replace educ2 = 3 if education >=40 & education <44
* 4: College and beyond
replace educ2 = 4 if education >=44 & education <50

* Dummy for post 2008
gen post08 = 1 if dtin>=td(01jan2008)
replace post08 = 0 if post08 ==.
gen pre08 = 1 if dtin<td(01jan2008)&dtin>=td(01jan2004)
replace pre08 = 0 if post08 ==.

* Unfinished spell (does NOT end in employment) as of 2013:
sort id jobcount dtin
gen unfin = 1 if dtout>=td(31dec2013)|state[_n+1]=="R"|state=="R"|cause==58|cause==56
replace unfin=0 if unfin==.

* Collective Dismissals
gen colldiss = 1 if cause==77&state!="U"&state!="R"
replace colldiss=0 if colldiss==.
sort id dtin
by id: replace colldiss = 1 if colldiss[_n-1]==1&state=="U"&(state[_n-1]=="P"|state[_n-1]=="T")

* Industry Cleaning
rename newind ind_old
quietly do "./data/industry_clean.do"

replace ind_short = 0 if state=="U"|state=="R"
by id: replace ind_short=ind_short[_n-1] if state=="U"&ind[_n-1]!=0&state[_n-1]!="U"
quietly tab ind_short, gen(ind_dummy_)
drop ind_dummy_1 ind_dummy_2 ind_dummy_8

* Construction special
gen const_post = 1 if ind_short==7&post08==1
gen const_pre = 1 if ind_short==7&post08==0
replace const_post=0 if const_post==.
replace const_pre=0 if const_pre==.

* Regions (barcelona and madrid aside. Reference poit: La Rioja)
rename adress address
gen province = int(address/1000)
by id: replace province = province[_n-1] if province==0
gen madrid = 1 if province == 28
replace  madrid = 0 if madrid == .
gen barna = 1 if province == 8
replace  barna = 0 if barna == .
quietly tabulate province, gen(region_d)
drop region_d8
drop region_d28
drop region_d26

* Education dummys (simplified, reference: no education/no primary studies)
quietly tab educ2, gen(ed_d)
drop ed_d1

* Quit with proper quit dummy
gen quit = 0
replace quit = 1 if cause==51&(state=="P"|state=="T")
by id: replace quit = 1 if quit[_n-1]==1&state=="U"&(state[_n-1]=="P"|state[_n-1]=="T")

* Fired or quit or collective dismissal (normal fire)
gen normal_f = 1 if (cause>50&cause<60)|cause==77|cause==69|(cause>90&cause<94)
by id: replace normal_f = 1 if state=="U"&(state[_n-1]=="P"|state[_n-1]=="T")&normal_f[_n-1]==1
replace normal_f = 0 if normal_f == .

* Other Auxiliary variables
sort id jobcount dtin
gen log_days = ln(days)
gen Sqage = age*age
gen weeks = days/7
gen log_weeks = ln(weeks)
gen weeks1 = days1/7
gen years1 = days1/365
gen lastPyears = (days1/365)*lastP
gen TotalExp = (ExpT+ExpP)
gen TotalExp2 = TotalExp^2
gen NoT2 = NoT^2
gen NoP2 = NoP^2
gen years12 = years1^2
gen yearsE2 = yearsE^2
gen foreign_born = 1 if nationality!="N00"&nationality!=""
replace foreign_born = 0 if foreign_born ==.

* For exporting: Year in/year out
gen year_in = year(dtin)
quietly tab year_in if year_in>=2005, gen(year_d) 
gen year_out = year(dtout)
drop year_d1 // 2005 base year

* Save
saveold "./baseline13.dta", v(12) replace
