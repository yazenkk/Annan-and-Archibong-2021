/*
Construct data, balance, and attrition

Input (Data/01_raw): 
	Round_1/impact10.102020Final.dta
	Round_2/impact_covid_roundFINAL.dta
	Round_3/round3_data_21.11.dta
	Round_4/round4_data_14.12.dta

Merge (Data/01_raw):
	select1396Final_sample.dta

Output (Data/02_intermediate):
	round1_round2 (baseline: waves 1 + 2)
	MobileCredit40GHS_376list.xls
	MobileCredit20GHS_371list_Wave1.xls
	MobileCredit20GHS_371list_Wave2.xls
	MobileCredit_attrition.dta
	End1_MobileCredit_attrition.dta (wave 3)
	End2_MobileCredit_attrition.dta (wave 4)
	
*/

set graphics off


**round 1
use "${replication_dir}/Data/01_raw/impact10.102020Final.dta", clear
gen round =1
** add-round 2
append using "${replication_dir}/Data/01_raw/impact_covid_roundFINAL.dta"
replace round=2 if missing(round)
tab round

keep if interviewn_result==1

**bring in base GLSS7
gen caseidX=caseidx
merge m:1 caseidX using "${replication_dir}/Data/01_raw/select1396Final_sample.dta", ///
	keepusing(districtX regionX pov_likelihood motherTogether noReligion spouseTogether ageMarried)
drop if _merge==2


**i) communication?
gen needToCOVID=(i9==1) if !missing(i9)
gen unableToCOVID=(i10==1) if !missing(i10)
gen unableCall7days =(cr1==1) if !missing(cr1)
gen unableTrans7days =(cr2==1) if !missing(cr2)
gen ct1a0 = ct1a
gen ct1b0 = ct1b
gen ct2a0 = ct2a
gen ct2b0 = ct2b
**ii) cons expenditure?
egen totExp7days= rowtotal(c1-e5), missing

**iii) gender relations?
gen threatenPartner=g1
gen hitPartner=g2

*number of districts?
egen nDistricts=group(districtX)
tab nDistricts 
*=193
egen nRegions=group(regionX)
tab nRegions
*=10

**iv) mental health?
*low (scores of 10-15, indicating little or no psychological distress)
*moderate (scores of 16-21)
*high (scores of 22-29)
*Very high/ severe (scores of 30-50)
egen k10= rowtotal(m1-m10), missing
hist k10, percent xline(30) xtitle("K10 Score") 

gen logk10 = log(k10)
gen severe_distress = (k10>=30) if !missing(k10)
bys round: sum severe_distress

gen tiredCOVID=(i8==1) if !missing(i8)

gen awareofCOVID0 = (b1a==1) if !missing(b1a)
gen trustgovtCOVIDNos0 =b1aa

**other baselines
gen m110 =m11
gen m120 =m12
gen m130 =m13
gen m140 =m14
gen bd10 =bd1
gen bd20 =bd2
gen bd30 =bd3


**xi-s
gen female0=(d2==2)
gen akan0=(d3==1)
gen married0=(d4==1)
gen ageYrs0=d5
replace ageYrs0=. if d5==99
gen jhs0=(d6>=4)
gen hhsize0=d7
gen selfEmploy0=(d8==1)
gen informal0=(d9==2)
gen incomegrp0=d10

gen self_hseWork0=(i0==1) if !missing(i0)

sum needToCOVID unableToCOVID unableCall7days unableTrans7days ct1a0 ct1b0 ct2a0 ct2b0 totExp7days threatenPartner hitPartner logk10 severe_distress tiredCOVID awareofCOVID0 trustgovtCOVIDNos0 m110 m120 m130 m140 bd10 bd20 bd30 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 

gen digitborrow0=(bd1==1) if !missing(bd1) 
gen digitloan0=(bd2==1) if !missing(bd1) 
gen relocated0=(bd3==1) if !missing(bd1) 
count if round == 2 & !mi(digitborrow0)

gen previouslock =(regionX==3 | regionX==6)
gen Trust = (trustgovtCOVIDNos0>=3) if !missing(trustgovtCOVIDNos0)


** Save data for balance table
saveold "${replication_dir}/Data/02_intermediate/round1_round2", replace


**Attrition: Prepare stats
use "${replication_dir}/Data/01_raw/impact10.102020Final.dta", clear
gen wave =1
keep if interviewn_result==1
bys caseidx wave: keep if _n==1  // tot subjects = 1130

merge m:1 caseidx using "${replication_dir}/Data/01_raw/MobileCredit40GHS_376list.dta" //(but 1:1 for 12/6)
drop _merge
gen MobileCredit40=MobileCredit
drop MobileCredit
tab MobileCredit40 
merge m:m caseidx using "${replication_dir}/Data/01_raw/MobileCredit20GHS_371list_Wave1.dta"  //(but 1:m for 12/6)
drop _merge
gen MobileCredit20=MobileCredit
drop MobileCredit
tab MobileCredit20
gen MobileCredit = MobileCredit40 
replace MobileCredit = MobileCredit20 if !missing(MobileCredit20)

replace MobileCredit = "0GHS" if missing(MobileCredit)
gen MobileCredit_attrition = MobileCredit
tab MobileCredit 
tab MobileCredit_attrition

*bys caseidx: keep if _n==1  
keep caseidx MobileCredit_attrition
tab MobileCredit_attrition
saveold "${replication_dir}/Data/02_intermediate/MobileCredit_attrition", replace

** Wave 3, end 1
use "${replication_dir}/Data/01_raw/round3_data_21.11.dta", clear
keep if interviewn_result==1
bys caseidx: keep if _n==1  //only subjects + dropouts
merge m:m caseidx using "${replication_dir}/Data/02_intermediate/MobileCredit_attrition" //just 1 repeat in Aftrition file so do m:m
*bys caseidx: keep if _n==1  //only subjects + dropouts
tab _merge //83 no reachable
gen dropouts = (_merge==2)
tab MobileCredit_attrition if dropouts==0
gen ins=(dropouts==0)
tabstat ins, stat(mean sd n) by(MobileCredit_attrition) //get means and sd
tabstat dropouts, stat(mean sd n) by(MobileCredit_attrition)
saveold "${replication_dir}/Data/02_intermediate/End1_MobileCredit_attrition", replace


** Wave 4, end 2
use "${replication_dir}/Data/01_raw/round4_data_14.12.dta", clear
keep if interviewn_result==1
*bys caseidx: keep if _n==1  //only subjects + dropouts
merge m:m caseidx using "${replication_dir}/Data/02_intermediate/MobileCredit_attrition" //just 1 repeat in Aftrition file so do m:m
*bys caseidx: keep if _n==1  //only subjects + dropouts
tab _merge //134 no reachable
gen dropouts = (_merge==2)
tab MobileCredit_attrition if dropouts==0
gen ins=(dropouts==0)
tabstat ins, stat(mean sd n) by(MobileCredit_attrition) //get means and sd
tabstat dropouts, stat(mean sd n) by(MobileCredit_attrition)
**estimation with attrition adjustments
saveold "${replication_dir}/Data/02_intermediate/End2_MobileCredit_attrition", replace
