/// UPPER DO FILE ///

*-*-*-* mu hat i *-*-*-*

by id: egen mu_i = mean(real_days_1)
by id: replace mu_i = . if nup==1

*-*-*-* mu hat bar y *-*-*-*

egen N = count(mu_i)
egen mu_y = mean(mu_i)

*-*-*-* sigma i hat *-*-*-*

by id : gen sig_i = ((real_days_1[1]-real_days_1[2])^2)/2 if nup==2

*-*-*-* sigma y bar hat *-*-*-*

by id : gen sigyi = real_days_1[1]^2 + real_days_1[2]^2 - 2*mu_y^2 if mu_i!=.

gen sig_y = sum(sigyi)/(2*N-1)
replace sig_y = sig_y[_N]

*-*-*-*-*-*-*-*-*-*-*-* SPELLS CONTROL DECOMPOSITION *-*-*-*-*-*-*-*-*-*-*-*-*-*

gen spell_d=1 if nup==2
replace spell_d = 0 if nup==1

reg real_days_1 sex_d i.educ2 spell_d

predict res, r
replace res=0 if res==.

*-*-*-* mu hat bar eps *-*-*-*

sort id nup
by id: gen resi = (res[1]^2+res[2]^2)/2
by id: replace resi = . if [_n]!=2
gen sigma_eps = sum(resi)/(N-1)
replace sigma_eps = sigma_eps[_N]

*-*-*-* sigma hat y *-*-*-*

by id : gen mu_i2 = (real_days_1[1]+real_days_1[2])/2
by id : replace mu_i2 = . if [_n]!= 2

egen mu_y2 = mean(mu_i)

by id : gen sy = ((real_days_1[1]-mu_y2)^2 + (real_days_1[2]-mu_y2)^2)/(2*N-1)
by id : replace sy = . if [_n]!= 2

gen sig_y2 = sum(sy)
replace sig_y2 = lsig_y2[_N]

gen sig_s = sig_y2-sigma_eps

*-*-*-* sigma w bar hat *-*-*-*

by id: gen sigi2 = (N*(res[1]-res[2])^2)/(2*(N-1))
egen sig_w2 = mean(sigi2)

*-*-*-* sigma b bar hat *-*-*-*

gen sig_b2 = sigma_eps - sig_w2

*-*-*-* sigma e bar hat *-*-*-*

gen sig_e2 = sig_w2 - (c(pi)^2/6)

gen psig_s= sig_s/sig_y2
gen psig_e = sig_e2/sig_y2
gen psig_b = sig_b2/sig_y2


*-*-*-*-*-*-*-*-*-*-*-* 2 LOGS DECOMPOSITION *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

gen lreal_days_1 = log(real_days_1)

*-*-*-* mu hat i *-*-*-*

by id : gen lmu_i = (lreal_days_1[1]+lreal_days_1[2])/2 
by id : replace lmu_i = . if nup==1

*-*-*-* mu hat bar y *-*-*-*

egen lmu_y = mean(lmu_i)

*-*-*-* sigma i hat *-*-*-*

by id : gen lsig_i = ((lreal_days_1[1]-lreal_days_1[2])^2)/2
replace lsig_i=. if nup==1

*-*-*-* Clean up *-*-*-*
drop res resi sigma_eps

*-*-*-* Regression *-*-*-*
reg lreal_days_1 spell_d sex_d i.educ2

predict res, r
replace res=0 if res==.

*-*-*-* mu hat bar eps *-*-*-*

sort id nup
by id: gen resi = (res[1]^2+res[2]^2)/2
by id: replace resi = . if [_n]!=2
gen sigma_eps = sum(resi)/(N-1)
replace sigma_eps = sigma_eps[_N]

*-*-*-* sigma hat y *-*-*-*

by id : gen lmu_i2 = (lreal_days_1[1]+lreal_days_1[2])/2
by id : replace lmu_i2 = . if [_n]!= 2

egen mu_y2 = mean(lmu_i)

by id : gen lsy = ((lreal_days_1[1]-mu_y2)^2 + (lreal_days_1[2]-mu_y2)^2)/(2*N-1)
by id : replace lsy = . if [_n]!= 2

gen lsig_y2 = sum(lsy)
replace lsig_y2 = lsig_y2[_N]

gen lsig_s = lsig_y2-sigma_eps

*-*-*-* sigma w bar hat *-*-*-*

by id: gen lsigi2 = (N*(res[1]-res[2])^2)/(2*(N-1))
egen lsig_w2 = mean(lsigi2)

*-*-*-* sigma b bar hat *-*-*-*

gen lsig_b2 = sigma_eps - lsig_w2

*-*-*-* sigma e bar hat *-*-*-*

gen lsig_e2 = lsig_w2 - (c(pi)^2/6)

gen lpsig_c= (c(pi)^2/6)/lsig_y2
gen lpsig_s= sig_s/lsig_y2
gen lpsig_e = lsig_e2/lsig_y2
gen lpsig_b = lsig_b2/lsig_y2

