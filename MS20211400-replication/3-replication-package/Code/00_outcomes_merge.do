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
isid caseidx
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
isid caseidx round
merge m:1 caseidx using "${replication_dir}/Data/02_intermediate/TrtList00_dedup.dta" //bring in round 1 = base	
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
bys caseidx (round): gen xdif=totExp7days1[_n]-totExp7days1[_n-1]
bys caseidx (round): gen xgrowth=(xdif/totExp7days1[_n])*100
tab regionX
tab regionX, nolab
gen Trust = (trustgovtCOVIDNos0>=3) if !missing(trustgovtCOVIDNos0)
gen previouslock =(regionX==3 | regionX==6)
sum xgrowth if xgrowth, d
// bys previouslock: sum xgrowth if (xgrowth>-300 & xgrowth<100), d //worst cgrowth in locked areas! so truly a shock [trimmed at 95%?]

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

label var unableCall7days1 "Unable to Call, 7days 0-1"
label var unableToCOVID1 "Unable to Call, COVID19 0-1"
label var digitborrow1 "Borrow SOS Airtime 0-1"
label var digitloan1 "Seek Digital Loan 0-1"
    
label var tmt_all "Communication Credit ($\beta$)"
label var tmt01 "Lumpsum Credit ($\beta_1$)"
label var tmt02 "Installments Credit ($\beta_2$)"

label var totExp7days1 "Total (GHS), Expenditure"
label var c1 "Food-In, (GHS)"
label var c2 "Food-Out, (GHS)"
label var e1 "Utilities, (GHS)"
label var e2 "Personal care, (GHS)"
label var e3 "Educ., (GHS)"
label var e4 "Health, (GHS)"
label var e5 "Durables, (GHS)"

label var threatenPartner1 "Threatened Partner 1-4"
label var hitPartner1 "Hit Partner 1-4"
label var logk101 "log K10"
label var severe_distress1 "Severe Distress 0-1"


** save data
sort caseidx round
save "${replication_dir}/Data/03_clean/end1_end2.dta", replace
