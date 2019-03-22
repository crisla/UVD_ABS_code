
* Format personal file * * * * * * * * * * * * * * * * * * *
clear
insheet using "./PERSANON.txt", delimiter(";")
quietly do "./personal_format.do"
saveold "./personal13.dta", v(12) replace

* Format pension file * * * * * * * * * * * * * * * * * * *
clear
insheet using "./MCVL2013PRESTAC_CDF.txt", delimiter(";")
quietly do "./pension_format.do"
saveold "./pension2013.dta", v(12) replace

* Format and merge affiliation files * * * * * * * * * * * * * * * *
clear
insheet using "./MCVL2013AFILIAD1_CDF.txt", delimiter(";")
save "./afilianon131.dta", replace
clear
insheet using "./MCVL2013AFILIAD2_CDF.txt", delimiter(";")
save "./afilianon132.dta", replace
clear
insheet using "./MCVL2013AFILIAD3_CDF.txt", delimiter(";")
save "./afilianon133.dta", replace
clear
insheet using "./MCVL2013AFILIAD4_CDF.txt", delimiter(";")
save "./afilianon134.dta", replace
clear
use "./afilianon131.dta"
append using "./afilianon132.dta"
append using "./afilianon133.dta"
append using "./afilianon134.dta"

do "./rawfiles/format_afilianon.do"

* Combine with personal file * * * * * * * * * * * * * * * *
merge m:1 id using "./personal13.dta"
drop if _merge==2
drop _merge

saveold "./afilianon2013.dta", version (12) replace
