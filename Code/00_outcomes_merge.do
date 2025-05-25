/*
Merge data

	Input: 
		- End1_MobileCredit_attrition
		- End2_MobileCredit_attrition
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

**bring-In baseline data-
merge m:m caseidx using "${replication_dir}/Data/02_intermediate/TrtList00.dta" //bring in round 1 = base
bys caseidx end: keep if _n==1  
drop _merge


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



** save data
save "${replication_dir}/Data/03_clean/end1_end2.dta", replace
