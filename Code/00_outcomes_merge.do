/*
Merge data

	Input: 
		- End1_MobileCredit_attrition
		- End2_MobileCredit_attrition
		
	Output:
		- end1_end2
*/



***********************************
clear all
use "${replication_dir}/Data/02_intermediate/End1_MobileCredit_attrition.dta", clear
gen end=1
gen round=3
append using "${replication_dir}/Data/02_intermediate/End2_MobileCredit_attrition.dta"
replace end=2 if missing(end)
replace round=4 if missing(round)
tab end
tab round
tab MobileCredit_attrition


gen tmt_all= (MobileCredit_attrition !="0GHS") 
gen tmt01= (MobileCredit_attrition=="40GHS") 
gen tmt02= (MobileCredit_attrition=="20GHS")
sum tmt_all tmt01 tmt02

tab _merge // Attritors
drop _merge

**bring-In baseline data- (wave 1, round 1)
merge m:m caseidx using "${replication_dir}/Data/02_intermediate/TrtList00.dta" //bring in round 1 = base	
bys caseidx end: keep if _n==1  
drop _merge

**bring-In baseline data- (wave 2, round 2)
preserve
	use "${replication_dir}/Data/02_intermediate/round1_round2.dta", clear
	keep if round == 2
	isid caseidx
	tempfile wave2
	save	`wave2'
restore
isid caseidx round
merge m:1 caseidx using `wave2', keepusing(relocated0 digitborrow0 digitloan0)



**main outcomes
gen unableCall7days1 =(cr1==1) if !missing(cr1)
gen unableToCOVID1 =(i10==1) if !missing(i10)
gen digitborrow1 =(bd1==1) if !missing(bd1)
gen digitloan1 =(bd2==1) if !missing(bd2)

egen totExp7days1 =rowtotal(c1-e5), missing
gen threatenPartner1 =g1
gen hitPartner1 =g2
egen k101 =rowtotal(m1-m10), missing
gen logk101 =log(k101)
gen severe_distress1 =(k101>=30) if !missing(k101)

** used in regressions
tab round
tab round, gen(round)


** Consumption growth (used in Tables 3 and A10-A13 and Figure A10)
bys caseidx: gen xdif=totExp7days1[_n]-totExp7days1[_n-1]
bys caseidx: gen xgrowth=(xdif/totExp7days1[_n])*100
tab regionX
tab regionX, nolab
gen  previouslock =(regionX==3 | regionX==6)
sum xgrowth if xgrowth, d
bys previouslock: sum xgrowth if (xgrowth>-300 & xgrowth<100), d //worst cgrowth in locked areas! so truly a shock [trimmed at 95%?]

** Label variables
label var female0  "Female 0-1"
label var akan0 "Akan ethnic 0-1"
label var married0 "Married 0-1"
label var ageYrs0
label var jhs0 "Attained Junior High School (JHS) 0-1"
label var hhsize0 "Household size (number)"
label var selfEmploy0 "Self employed 0-1"
label var informal0 "Operates in informal sector 0-1"
label var incomegrp0 "Personal income (1 to 5 scale) (monthly)"
label var motherTogether "Staying together with mother 0-1 (Wave 0"
label var noReligion "Has no religion 0-1 (Wave 0)"
label var spouseTogether "Staying together with spouse 0-1 (Wave 0)"
label var ageMarried "Age at marriage (Years) (Wave 0)"

** save data
save "${replication_dir}/Data/03_clean/end1_end2.dta", replace
