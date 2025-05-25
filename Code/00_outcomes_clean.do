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
	TrtList00
	TrtList0
	MobileCredit40GHS_376list.xls
	MobileCredit20GHS_371list_Wave1.xls
	MobileCredit20GHS_371list_Wave2.xls
	MobileCredit_attrition.dta
	End1_MobileCredit_attrition.dta
	End2_MobileCredit_attrition.dta
	
*/

set graphics off


**round 1
use "${data_dir}/DATA/Round_1/impact10.102020Final.dta", clear
gen round =1
** add-round 2
append using "${data_dir}/DATA/Round_2/impact_covid_roundFINAL.dta"
replace round=2 if missing(round)
tab round

keep if interviewn_result==1

**bring in base GLSS7
gen caseidX=caseidx
merge m:1 caseidX using "${sample_dir}/select1396Final_sample.dta"
drop if _merge==2


**i) communication?
gen needToCOVID=(i9==1) if !missing(i9)
gen unableToCOVID=(i10==1) if !missing(i10)
gen unableCall7days =(cr1==1) if !missing(cr1)
gen unableTrans7days =(cr2==1) if !missing(cr2)
gen ct1a0 =ct1a
gen ct1b0 =ct1b
gen ct2a0 =ct2a
gen ct2b0 =ct2b
**ii) cons expenditure?
egen totExp7days= rowtotal(c1-e5), missing

**iii) gender relations?
gen threatenPartner=g1
gen hitPartner=g1

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




/*
**old: randomization & balance...
*y's
reg needToCOVID i.treatment_status
reg unableToCOVID i.treatment_status
reg unableCall7days i.treatment_status
reg unableTrans7days i.treatment_status
reg totExp7days i.treatment_status
reg threatenPartner i.treatment_status
reg hitPartner i.treatment_status
reg logk10 i.treatment_status
reg severe_distress i.treatment_status
reg tiredCOVID i.treatment_status

*xi-s
reg female0 i.treatment_status
reg akan0 i.treatment_status
reg married0 i.treatment_status
reg ageYrs0 i.treatment_status
reg jhs0 i.treatment_status
reg hhsize0 i.treatment_status
reg selfEmploy0 i.treatment_status
reg informal0 i.treatment_status
reg incomegrp0 i.treatment_status
**joint tests
reg treatment_status female akan married ageYrs jhs hhsize selfEmploy informal incomegrp if (treatment_status==0 | treatment_status==1) //Ctr vs Trt1
reg treatment_status female akan married ageYrs jhs hhsize selfEmploy informal incomegrp if (treatment_status==0 | treatment_status==2) //Ctr vs Trt2
probit treatment_status female akan married ageYrs jhs hhsize selfEmploy informal incomegrp if (treatment_status==0 | treatment_status==1)
probit treatment_status female akan married ageYrs jhs hhsize selfEmploy informal incomegrp if (treatment_status==0 | treatment_status==2) 
mprobit treatment_status female akan married ageYrs jhs hhsize selfEmploy informal incomegrp
*/

**new: redo-randomization?
keep if round==1
randtreat, generate(trt) replace unequal(1/3 1/3 1/3) strata(districtX) misfits(wstrata) setseed(1357911)
tab trt, miss

gen Trt=.
replace Trt=0 if trt==2
replace Trt=1 if trt==1
replace Trt=2 if trt==0
drop trt
tab Trt, miss

tab round


preserve
	keep caseidx caseidX Trt districtX regionX needToCOVID unableToCOVID unableCall7days unableTrans7days ct1a0 ct1b0 ct2a0 ct2b0 totExp7days threatenPartner hitPartner logk10 severe_distress tiredCOVID awareofCOVID0 trustgovtCOVIDNos0 m110 m120 m130 m140 bd10 bd20 bd30 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 pov_likelihood motherTogether noReligion female spouseTogether ageMarried self_hseWork0 i11
	saveold "${replication_dir}/Data/02_intermediate/TrtList00", replace
restore

preserve
	keep caseidx caseidX Trt districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 pov_likelihood motherTogether noReligion female spouseTogether ageMarried
	saveold "${replication_dir}/Data/02_intermediate/TrtList0", replace
restore






**sammy/ vodafone: delivering "Mobile Credit Invervention"
preserve
keep caseidx phone_number_of_respondent Trt
rename phone_number_of_respondent PhoneNumber
keep if Trt==1
gen MobileCredit="40GHS"
saveold "${replication_dir}/Data/02_intermediate/MobileCredit40GHS_376list.dta", replace
outsheet using "${replication_dir}/Data/02_intermediate/MobileCredit40GHS_376list.xls", replace
restore

preserve
keep caseidx phone_number_of_respondent Trt
rename phone_number_of_respondent PhoneNumber
keep if Trt==2
gen MobileCredit="20GHS"
gen Wave=1
saveold "${replication_dir}/Data/02_intermediate/MobileCredit20GHS_371list_Wave1.dta", replace
outsheet using "${replication_dir}/Data/02_intermediate/MobileCredit20GHS_371list_Wave1.xls", replace
restore

preserve
keep caseidx phone_number_of_respondent Trt
rename phone_number_of_respondent PhoneNumber
keep if Trt==2
gen MobileCredit="20GHS"
gen Wave=2
saveold "${replication_dir}/Data/02_intermediate/MobileCredit20GHS_371list_Wave2.dta", replace
outsheet using "${replication_dir}/Data/02_intermediate/MobileCredit20GHS_371list_Wave2.xls", replace
restore



*y-s
reg needToCOVID i.Trt
reg unableToCOVID i.Trt
reg unableCall7days i.Trt
reg unableTrans7days i.Trt
reg totExp7days i.Trt
reg threatenPartner i.Trt
reg hitPartner i.Trt
reg logk10 i.Trt
reg severe_distress i.Trt
reg tiredCOVID i.Trt

** Yazen *?* come back here
// reg bd1 i.Trt
// reg bd2 i.Trt
// reg bd3 i.Trt


*x-s
reg female0 i.Trt
reg akan0 i.Trt
reg married0 i.Trt
reg ageYrs0 i.Trt
reg jhs0 i.Trt
reg hhsize0 i.Trt
reg selfEmploy0 i.Trt
reg informal0 i.Trt
reg incomegrp0 i.Trt
**more x-s: step 0?
reg pov_likelihood i.Trt 
reg motherTogether i.Trt  
reg noReligion i.Trt  
reg female i.Trt  
reg spouseTogether i.Trt  
reg ageMarried i.Trt  


**joint tests (exclude y-s)
reg Trt female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 pov_likelihood motherTogether noReligion female spouseTogether ageMarried if (Trt==0 | Trt==1) //ctr vs trt1
reg Trt female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 pov_likelihood motherTogether noReligion female spouseTogether ageMarried if (Trt==0 | Trt==2) //ctr vs trt2
probit Trt female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 pov_likelihood motherTogether noReligion female spouseTogether ageMarried if (Trt==0 | Trt==1) 
probit Trt female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 pov_likelihood motherTogether noReligion female spouseTogether ageMarried if (Trt==0 | Trt==2)
mprobit Trt female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 pov_likelihood motherTogether noReligion female spouseTogether ageMarried


**3-step test for successful randomization?
gen pvalLR=.
mprobit Trt female0 
replace pvalLR= e(p) if _n==1
mprobit Trt akan0 
replace pvalLR= e(p) if _n==2
mprobit Trt married0 
replace pvalLR= e(p) if _n==3
mprobit Trt ageYrs0 
replace pvalLR= e(p) if _n==4
mprobit Trt jhs0 
replace pvalLR= e(p) if _n==5
mprobit Trt hhsize0 
replace pvalLR= e(p) if _n==6
mprobit Trt selfEmploy0 
replace pvalLR= e(p) if _n==7
mprobit Trt informal0 
replace pvalLR= e(p) if _n==8
mprobit Trt incomegrp0
replace pvalLR= e(p) if _n==9


mprobit Trt needToCOVID 
replace pvalLR= e(p) if _n==10
mprobit Trt unableToCOVID 
replace pvalLR= e(p) if _n==11
mprobit Trt unableCall7days 
replace pvalLR= e(p) if _n==12
mprobit Trt unableTrans7days 
replace pvalLR= e(p) if _n==13
mprobit Trt totExp7days 
replace pvalLR= e(p) if _n==14
mprobit Trt threatenPartner 
replace pvalLR= e(p) if _n==15
mprobit Trt hitPartner 
replace pvalLR= e(p) if _n==15
mprobit Trt logk10 
replace pvalLR= e(p) if _n==16
mprobit Trt severe_distress 
replace pvalLR= e(p) if _n==17
mprobit Trt tiredCOVID
replace pvalLR= e(p) if _n==18

**more x-s: step 0?
mprobit Trt pov_likelihood
replace pvalLR= e(p) if _n==19
mprobit Trt motherTogether 
replace pvalLR= e(p) if _n==20
mprobit Trt noReligion 
replace pvalLR= e(p) if _n==21
mprobit Trt female 
replace pvalLR= e(p) if _n==22
mprobit Trt spouseTogether 
replace pvalLR= e(p) if _n==23
mprobit Trt ageMarried 
replace pvalLR= e(p) if _n==24

hist pvalLR

set seed 12345
gen unif=runiform() 
gen unif2=_n/24 if _n<=24

distplot pvalLR unif unif2

stack pvalLR unif, into(kstest) clear
ksmirnov kstest, by(_stack) //1-sided test of pvals-LR test stochastically dominate unif, p=0.96




**Attrition: stats?
use "${data_dir}/DATA/Round_1/impact10.102020Final.dta", clear
gen wave =1
keep if interviewn_result==1
bys caseidx wave: keep if _n==1  //tot subjects = 1130

merge m:1 caseidx using "${data_dir}/_Francis_Impacts/MobileCredit40GHS_376list" //(but 1:1 for 12/6)
drop _merge
gen MobileCredit40=MobileCredit
drop MobileCredit
tab MobileCredit40 
merge m:m caseidx using "${data_dir}/_Francis_Impacts/MobileCredit20GHS_371list_Wave1"  //(but 1:m for 12/6)
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



** Analyze Baseline
use "${data_dir}/DATA/Round_1/impact10.102020Final.dta", clear
keep if interviewn_result==1
bys caseidx: keep if _n==1  //only subjects + dropouts
merge 1:m caseidx using "${replication_dir}/Data/02_intermediate/MobileCredit_attrition" //just 1 repeat in Aftrition file so do m:m
*bys caseidx: keep if _n==1  //only subjects + dropouts
tab _merge //0 no reachable
gen dropouts = (_merge==2)
gen ins=(dropouts==0)
tabstat ins, stat(mean sd n) by(MobileCredit_attrition) //get means and sd
*tabstat dropouts, stat(mean sd n) by(MobileCredit_attrition)


*base 2
use "${data_dir}/DATA/Round_2/impact_covid_roundFINAL.dta", clear
keep if interviewn_result==1
bys caseidx: keep if _n==1  //only subjects + dropouts
*drop _merge
merge 1:m caseidx using "${replication_dir}/Data/02_intermediate/MobileCredit_attrition" //just 1 repeat in Aftrition file so do m:m
*bys caseidx: keep if _n==1  //only subjects + dropouts
tab _merge //88 no reachable
gen dropouts = (_merge==2)
tab MobileCredit_attrition if dropouts==0
gen ins=(dropouts==0)
tabstat ins, stat(mean sd n) by(MobileCredit_attrition) //get means and sd
*tabstat dropouts, stat(mean sd n) by(MobileCredit_attrition)


** Analyze Endline
*end 1
use "${data_dir}/DATA/Round_3/round3_data_21.11.dta", clear
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


*end 2
use "${data_dir}/DATA/Round_4/round4_data_14.12.dta", clear
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



**overall rate differential?
use "${replication_dir}/Data/02_intermediate/End1_MobileCredit_attrition", clear
append using "${replication_dir}/Data/02_intermediate/End2_MobileCredit_attrition"
tab MobileCredit_attrition, gen(TMT)
reg dropouts TMT2 TMT3
ttest dropouts if TMT3 !=1, by(TMT2) 
ttest dropouts if TMT2 !=1, by(TMT3) 


