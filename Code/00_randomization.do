/*
Replicating randomization step.
*/


*cd "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/_Francis_"
// cd "/Users/fannan/Dropbox/Annan Archibong et al./belinda_main/covid19 paper/IMPACT_COVID19 DATA/_Francis_Impacts"
ls
set more off



*---------------------------------------------*
* SECTION: Data Preparation - Round 1 & 2     *
* Used to build baseline and endline datasets *
*---------------------------------------------*
**round 1
use "${replication_dir}/Data/01_raw/impact10.102020Final.dta", clear
gen round =1
** add-round 2
append using "${replication_dir}/Data/01_raw/impact_covid_roundFINAL.dta"
replace round=2 if missing(round)
tab round

keep if interviewn_result==1

*--- Merge with Baseline Sampling Frame (GLSS7) ---*
**bring in base GLSS7
gen caseidX=caseidx
merge m:1 caseidX using "${sample_dir}/select1396Final_sample.dta"
drop if _merge==2


*--- Create Key Outcome Variables for Table 1 (Communication Constraints) ---*
**i) communication?
* Proxy for increased need to connect due to COVID-19 (used in heterogeneity)
gen needToCOVID=(i9==1) if !missing(i9)
* Key Dependent Variable: Unable to Call due to COVID (Table 1, col 2)
gen unableToCOVID=(i10==1) if !missing(i10)
* Key Dependent Variable: Unable to Call in Last 7 Days (Table 1, col 1)
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


keep caseidx caseidX Trt districtX regionX needToCOVID unableToCOVID unableCall7days unableTrans7days ct1a0 ct1b0 ct2a0 ct2b0 totExp7days threatenPartner hitPartner logk10 severe_distress tiredCOVID awareofCOVID0 trustgovtCOVIDNos0 m110 m120 m130 m140 bd10 bd20 bd30 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 pov_likelihood motherTogether noReligion female spouseTogether ageMarried self_hseWork0 i11
saveold "${replication_dir}/Data/01_raw/TrtList00", replace
sort caseidx Trt
tempfile compares
save	`compares'

use "/Users/yazenkashlan/Dropbox (Personal)/covid19 paper/IMPACT_COVID19 DATA/_Francis_Impacts/TrtList00", clear
sort caseidx Trt
cf Trt using `compares',



