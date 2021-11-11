/// LOWER LOWER DO FILE ///

by id: egen mu_i = mean(LLdays)
by id: replace mu_i = . if n_spell_u==1

*-*-*-* mu hat bar y *-*-*-*

egen N = count(mu_i)
egen mu_y = mean(mu_i)

*-*-*-* sigma i hat *-*-*-*

by id : gen sig_i = ((LLdays[1]-LLdays[2])^2)/2 if n_spell_u==2

*-*-*-* sigma y bar hat *-*-*-*

by id : gen sigyi = LLdays[1]^2 + LLdays[2]^2 - 2*mu_y^2 if mu_i!=.

gen sig_y = sum(sigyi)/(2*N-1)
replace sig_y = sig_y[_N]

*-*-*-* sigma w bar hat *-*-*-*

egen sig_w = mean(sig_i)

*-*-*-* sigma b bar hat *-*-*-*

by id : gen sigbi = mu_i^2 - 0.5*sig_i - mu_y^2 + (1/(2*N))*sig_y
egen sig_b = mean(sigbi)

*-*-*-* sigma c bar hat *-*-*-*

by id : gen sigci = mu_i^2 - 0.5*sig_i
egen sig_c = mean(sigci)

*-*-*-* sigma e bar hat *-*-*-*

by id : gen sigei = (3/2)*sig_i - mu_i^2
egen sig_e = mean(sigei)

*-*-*-*-*-*-*-*-*-*-*-* 4.2 LOGS DECOMPOSITION *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

gen lLLdays = log(LLdays)

*-*-*-* mu hat i *-*-*-*

by id : gen lmu_i = (lLLdays[1]+lLLdays[2])/2 
by id : replace lmu_i = . if n_spell_u==1

*-*-*-* mu hat bar y *-*-*-*

egen lmu_y = mean(lmu_i)

*-*-*-* sigma i hat *-*-*-*

by id : gen lsig_i = ((lLLdays[1]-lLLdays[2])^2)/2
replace lsig_i=. if n_spell_u==1

*-*-*-* sigma y bar hat *-*-*-*

by id: gen lsigyi = lLLdays[1]^2 + lLLdays[2]^2 - 2*lmu_y^2 if lmu_i!=.

gen lsig_y = sum(lsigyi)/((2*N)-1)
replace lsig_y = lsig_y[_N]

*-*-*-* sigma w bar hat *-*-*-*

gen lsig_w = sum(lsig_i)/N
replace lsig_w = lsig_w[_N]

*-*-*-* sigma b bar hat *-*-*-*

by id : gen lsigbi = lmu_i^2 - 0.5*lsig_i - lmu_y^2 + (1/(2*N))*lsig_y
gen lsig_b = sum(lsigbi)/N
replace lsig_b = lsig_b[_N]

*-*-*-* sigma e bar hat *-*-*-*

gen lsig_e = lsig_w - c(pi)^2/6

gen lsig_c = (c(pi)^2/6)

*-*-*-* Saving results *-*-*-*

gen psig_c = sig_c/sig_y
gen psig_e = sig_e/sig_y 
gen psig_b = sig_b/sig_y

gen plsig_c = lsig_c/lsig_y
gen plsig_e = lsig_e/lsig_y 
gen plsig_b = lsig_b/lsig_y

//sum sig_y sig_c sig_e sig_b

//sum psig_c psig_e psig_b

//sum lsig_y lsig_c lsig_e lsig_b

//sum plsig_c plsig_e plsig_b

*-*-*-*-*-*-*-*-*-*-*-* SPELLS CONTROL DECOMPOSITION *-*-*-*-*-*-*-*-*-*-*-*-*-*

gen spell_d=1 if n_spell_u==2
replace spell_d = 0 if n_spell_u==1

gen age2 = age^2

reg lLLdays sex_d i.educ2 spell_d age age2

predict res, r

replace res = 0 if res==.

*-*-*-* mu hat bar eps *-*-*-*

sort id n_spell_u
by id: gen resi = (res[1]^2+res[2]^2)/2
by id: replace resi = . if [_n]!=2
gen sigma_eps = sum(resi)/(N-1)
replace sigma_eps = sigma_eps[_N]

*-*-*-* sigma hat y *-*-*-*

by id : gen lmu_i2 = (lLLdays[1]+lLLdays[2])/2
by id : replace lmu_i2 = . if [_n]!= 2

egen mu_y2 = mean(lmu_i)

by id : gen lsy = ((lLLdays[1]-mu_y2)^2 + (lLLdays[2]-mu_y2)^2)/(2*N-1)
by id : replace lsy = . if [_n]!= 2

gen lsig_y2 = sum(lsy)
replace lsig_y2 = lsig_y2[_N]

gen sig_x = lsig_y2-sigma_eps


*-*-*-* sigma w bar hat *-*-*-*

by id: gen lsigi2 = (N*(res[1]-res[2])^2)/(2*(N-1))
egen lsig_w2 = mean(lsigi2)

*-*-*-* sigma b bar hat *-*-*-*

gen lsig_b2 = sigma_eps - lsig_w2

*-*-*-* sigma e bar hat *-*-*-*

gen lsig_e2 = lsig_w2 - (c(pi)^2/6)

gen lpsig_x= sig_x/lsig_y2
gen lpsig_e = lsig_e2/lsig_y2
gen lpsig_b = lsig_b2/lsig_y2

//sum lsig_y2 sig_x lsig_c lsig_e2 lsig_b2

//sum lpsig_x lpsig_e lpsig_b

