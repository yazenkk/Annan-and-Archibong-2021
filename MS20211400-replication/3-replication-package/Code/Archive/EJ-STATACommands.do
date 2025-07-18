*cd "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/_Francis_"
cd "/Users/fannan/Dropbox/Annan Archibong et al./belinda_main/covid19 paper/IMPACT_COVID19 DATA/_Francis_Impacts"
ls
set more off
/*


*---------------------------------------------*
* SECTION: Data Preparation - Round 1 & 2     *
* Used to build baseline and endline datasets *
*---------------------------------------------*
**round 1
use "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/DATA/Round_1/impact10.102020Final.dta", clear
gen round =1
** add-round 2
append using "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/DATA/Round_2/impact_covid_roundFINAL.dta"
replace round=2 if missing(round)
tab round

keep if interviewn_result==1

*--- Merge with Baseline Sampling Frame (GLSS7) ---*
**bring in base GLSS7
gen caseidX=caseidx
merge m:1 caseidX using "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/COVID ZERO STEP/Stata/select1396Final_sample.dta"
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

/*
keep caseidx caseidX Trt districtX regionX needToCOVID unableToCOVID unableCall7days unableTrans7days ct1a0 ct1b0 ct2a0 ct2b0 totExp7days threatenPartner hitPartner logk10 severe_distress tiredCOVID awareofCOVID0 trustgovtCOVIDNos0 m110 m120 m130 m140 bd10 bd20 bd30 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 pov_likelihood motherTogether noReligion female spouseTogether ageMarried self_hseWork0 i11
saveold "TrtList00", replace

keep caseidx caseidX Trt districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 pov_likelihood motherTogether noReligion female spouseTogether ageMarried
saveold "TrtList0", replace
*/

?


/*
**sammy/ vodafone: delivering "Mobile Credit Invervention"
preserve
keep caseidx phone_number_of_respondent Trt
rename phone_number_of_respondent PhoneNumber
keep if Trt==1
gen MobileCredit="40GHS"
saveold MobileCredit40GHS_376list, replace
outsheet using "MobileCredit40GHS_376list.xls", replace
restore

preserve
keep caseidx phone_number_of_respondent Trt
rename phone_number_of_respondent PhoneNumber
keep if Trt==2
gen MobileCredit="20GHS"
gen Wave=1
saveold MobileCredit20GHS_371list_Wave1, replace
outsheet using "MobileCredit20GHS_371list_Wave1.xls", replace
restore

preserve
keep caseidx phone_number_of_respondent Trt
rename phone_number_of_respondent PhoneNumber
keep if Trt==2
gen MobileCredit="20GHS"
gen Wave=2
saveold MobileCredit20GHS_371list_Wave2, replace
outsheet using "MobileCredit20GHS_371list_Wave2.xls", replace
restore
*/

*tab regionX
*tab regionX Trt


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

reg bd1 i.Trt
reg bd2 i.Trt

reg bd3 i.Trt


*x-s
* Balance check on gender (female dummy)
reg female0 i.Trt
reg akan0 i.Trt
* Balance check on marital status
reg married0 i.Trt
* Balance check on age
reg ageYrs0 i.Trt
reg jhs0 i.Trt
reg hhsize0 i.Trt
reg selfEmploy0 i.Trt
* Balance check on informal sector employment (used in heterogeneity)
reg informal0 i.Trt
reg incomegrp0 i.Trt
**more x-s: step 0?
reg pov_likelihood i.Trt 
reg motherTogether i.Trt  
reg noReligion i.Trt  
* Balance check on gender (female dummy)
reg female i.Trt  
reg spouseTogether i.Trt  
* Balance check on age
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
?


*/


/*
**Attrition Estimates?
*base 1
use "/Users/fannan/Dropbox/Annan Archibong et al./belinda_main/covid19 paper/IMPACT_COVID19 DATA/DATA/Round_1/impact10.102020Final.dta", clear
keep if interviewn_result==1
bys caseidx: keep if _n==1  //only subjects + dropouts
merge 1:m caseidx using "/Users/fannan/Dropbox/Annan Archibong et al./belinda_main/covid19 paper/IMPACT_COVID19 DATA/_Francis_Impacts/MobileCredit_attrition" //just 1 repeat in Aftrition file so do m:m
*bys caseidx: keep if _n==1  //only subjects + dropouts
tab _merge //0 no reachable
gen dropouts = (_merge==2)
gen ins=(dropouts==0)
tabstat ins, stat(mean sd n) by(MobileCredit_attrition) //get means and sd
*tabstat dropouts, stat(mean sd n) by(MobileCredit_attrition)

*base 2
use "/Users/fannan/Dropbox/Annan Archibong et al./belinda_main/covid19 paper/IMPACT_COVID19 DATA/DATA/Round_2/impact_covid_roundFINAL.dta", clear
keep if interviewn_result==1
bys caseidx: keep if _n==1  //only subjects + dropouts
*drop _merge
merge 1:m caseidx using "/Users/fannan/Dropbox/Annan Archibong et al./belinda_main/covid19 paper/IMPACT_COVID19 DATA/_Francis_Impacts/MobileCredit_attrition" //just 1 repeat in Aftrition file so do m:m
*bys caseidx: keep if _n==1  //only subjects + dropouts
tab _merge //88 no reachable
gen dropouts = (_merge==2)
tab MobileCredit_attrition if dropouts==0
gen ins=(dropouts==0)
tabstat ins, stat(mean sd n) by(MobileCredit_attrition) //get means and sd
*tabstat dropouts, stat(mean sd n) by(MobileCredit_attrition)


*end 1
use "/Users/fannan/Dropbox/Annan Archibong et al./belinda_main/covid19 paper/IMPACT_COVID19 DATA/DATA/Round_3/round3_data_21.11.dta", clear
keep if interviewn_result==1
bys caseidx: keep if _n==1  //only subjects + dropouts
merge m:m caseidx using "/Users/fannan/Dropbox/Annan Archibong et al./belinda_main/covid19 paper/IMPACT_COVID19 DATA/_Francis_Impacts/MobileCredit_attrition" //just 1 repeat in Aftrition file so do m:m
*bys caseidx: keep if _n==1  //only subjects + dropouts
tab _merge //83 no reachable
gen dropouts = (_merge==2)
tab MobileCredit_attrition if dropouts==0
gen ins=(dropouts==0)
tabstat ins, stat(mean sd n) by(MobileCredit_attrition) //get means and sd
tabstat dropouts, stat(mean sd n) by(MobileCredit_attrition)
saveold "/Users/fannan/Dropbox/Annan Archibong et al./belinda_main/covid19 paper/IMPACT_COVID19 DATA/_Francis_Impacts/End1_MobileCredit_attrition", replace


*end 2
use "/Users/fannan/Dropbox/Annan Archibong et al./belinda_main/covid19 paper/IMPACT_COVID19 DATA/DATA/Round_4/round4_data_14.12.dta", clear
keep if interviewn_result==1
*bys caseidx: keep if _n==1  //only subjects + dropouts
merge m:m caseidx using "/Users/fannan/Dropbox/Annan Archibong et al./belinda_main/covid19 paper/IMPACT_COVID19 DATA/_Francis_Impacts/MobileCredit_attrition" //just 1 repeat in Aftrition file so do m:m
*bys caseidx: keep if _n==1  //only subjects + dropouts
tab _merge //134 no reachable
gen dropouts = (_merge==2)
tab MobileCredit_attrition if dropouts==0
gen ins=(dropouts==0)
tabstat ins, stat(mean sd n) by(MobileCredit_attrition) //get means and sd
tabstat dropouts, stat(mean sd n) by(MobileCredit_attrition)
**estimation with attrition adjustments
saveold "/Users/fannan/Dropbox/Annan Archibong et al./belinda_main/covid19 paper/IMPACT_COVID19 DATA/_Francis_Impacts/End2_MobileCredit_attrition", replace



**overall rate differential?
use "/Users/fannan/Dropbox/Annan Archibong et al./belinda_main/covid19 paper/IMPACT_COVID19 DATA/_Francis_Impacts/End1_MobileCredit_attrition", clear
append using "/Users/fannan/Dropbox/Annan Archibong et al./belinda_main/covid19 paper/IMPACT_COVID19 DATA/_Francis_Impacts/End2_MobileCredit_attrition"
tab MobileCredit_attrition, gen(TMT)
reg dropouts TMT2 TMT3
ttest dropouts if TMT3 !=1, by(TMT2) 
ttest dropouts if TMT2 !=1, by(TMT3) 

*/



**************
***********************************
clear all
use "/Users/fannan/Dropbox/Annan Archibong et al./belinda_main/covid19 paper/IMPACT_COVID19 DATA/_Francis_Impacts/End1_MobileCredit_attrition.dta", clear
gen end=1
gen round=3
append using "/Users/fannan/Dropbox/Annan Archibong et al./belinda_main/covid19 paper/IMPACT_COVID19 DATA/_Francis_Impacts/End2_MobileCredit_attrition.dta"
replace end=2 if missing(end)
replace round=4 if missing(round)
tab end
tab round
tab MobileCredit_attrition
gen tmt_all= (MobileCredit_attrition !="0GHS") 
gen tmt01= (MobileCredit_attrition=="40GHS") 
gen tmt02= (MobileCredit_attrition=="20GHS")
sum tmt_all tmt01 tmt02

tab _merge //Attritors
drop _merge

**bring-In baseline data-
merge m:m caseidx using "/Users/fannan/Dropbox/Annan Archibong et al./belinda_main/covid19 paper/IMPACT_COVID19 DATA/_Francis_Impacts/TrtList00.dta" //bring in round 1 = base
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
*gen severe_distress1 =(k101>=30)
gen severe_distress1 =(k101>=30) if !missing(k101)


/*
reg unableCall7days1 tmt_all, r 
leebounds unableCall7days1 tmt_all, level(90) cieffect tight() 

gen attempts= number_of_calls
bys tmt_all: tab attempts
**with 4 or less phone /contact attempts: control has 92.8% response rate, treatment has 93.3% response rate
**use number of attempts=effort to rank & bound te
**so trim (93.3-92.8)/93.8 =+0.5% of trt group, x 77= 2 customers / obs out
gen itemB= unableCall7days1 if tmt_all==1 & attempts<=4
egen iranklo_aB =rank(itemB) if tmt_all==1, unique //from above
egen iranklo_bB =rank(-itemB) if tmt_all==1, unique //from below
gen yupperB= unableCall7days1
replace yupperB=. if (tmt_all==1 & iranklo_aB<=2) | (tmt_all==1 & tmt_all>4)
gen ylowerB= unableCall7days1
replace ylowerB=. if (tmt_all==1 & iranklo_bB<=2) | (tmt_all==1 & attempts>4)
reg ylowerB tmt_all, r //tighter...
reg yupperB tmt_all, r


**Pooled endlineI + endlineII
***********************************
***********************************
** endlineI: add-round 3
use "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/DATA/Round_3/round3_data_21.11.dta", clear
gen round=3
gen end = 1
tab round
keep if interviewn_result==1
** endlineII: add-round 4
append using "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/DATA/Round_4/round4_data_14.12.dta"
replace round=4 if missing(round)
replace end=2 if missing(end)
tab round
tab end
keep if interviewn_result==1

**bring in Interventions - verify
merge m:1 caseidx using "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/_Francis_/MobileCredit40GHS_376list"
drop _merge
gen MobileCredit40=MobileCredit
drop MobileCredit
tab MobileCredit40 

merge m:m caseidx using "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/_Francis_/MobileCredit20GHS_371list_Wave1"
drop _merge
gen MobileCredit20=MobileCredit
drop MobileCredit
tab MobileCredit20

gen MobileCredit = MobileCredit40 
replace MobileCredit = MobileCredit20 if !missing(MobileCredit20)

gen tmt_all= !missing(MobileCredit) 
gen tmt01= (MobileCredit=="40GHS") 
gen tmt02= (MobileCredit=="20GHS") 
gen tmt= 0
replace tmt=1 if tmt01==1
replace tmt=2 if tmt02==1
sum tmt_all tmt01 tmt02 tmt if round==3
sum tmt_all tmt01 tmt02 tmt if round==4


merge m:m caseidx using "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/_Francis_/TrtList00" //bring in round 1 = base
bys caseidx round: keep if _n==1  
drop _merge
*/

tab round
tab round, gen(round)

/*
**outcomes: stage1, stage2 (KEY: use same var naming?)
gen needToCOVID1 =(i9==1) if !missing(i9)
gen unableToCOVID1 =(i10==1) if !missing(i10)
gen unableCall7days1 =(cr1==1) if !missing(cr1)
gen unableTrans7days1 =(cr2==1) if !missing(cr2)
gen digitborrow1 =(bd1==1) if !missing(bd1)
gen digitloan1 =(bd2==1) if !missing(bd2)

egen totExp7days1 =rowtotal(c1-e5), missing
gen threatenPartner1 =g1
gen hitPartner1 =g2 // ************************************************ not g1
egen k101 =rowtotal(m1-m10), missing
gen logk101 =log(k101)
gen severe_distress1 =(k101>=30) if !missing(cr1)
gen tiredCOVID1 =(i8==1) if !missing(cr1)
*/


**regressions?
**get results?
*cd "/Users/fannan/Dropbox/Annan Archibong et al./belinda_main/covid19 paper/IMPACT_COVID19 DATA/_Francis_Impacts/paper/results"
cd "/Users/fannan/Dropbox/Annan Archibong et al./belinda_main/covid19 paper/IMPACT_COVID19 DATA/_Francis_Impacts/paper/results"

ls

distplot number_of_calls //no of time called b/4 picking up
* Outcome Analysis: Hitting Partner — Table 2, Column 3
hist number_of_calls, gap(10) percent xtitle("Number of phone call times before answering survey") lcolor(none) fcolor(gray) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid)
gr export "subjects_calltimeS.eps", replace

**K10 and cons
*low (scores of 10-15, indicating little or no psychological distress)
*moderate (scores of 16-21)
*high (scores of 22-29)
*Very high/ severe (scores of 30-50)
gen k10 = exp(logk10)
* Outcome Analysis: Mental Health (log K10 score) — Table 2, Column 4
* Outcome Analysis: Hitting Partner — Table 2, Column 3
hist k10 if end==1, percent xline(30, lp(dash)) xtitle("K10 score at baseline") lcolor(none) fcolor(gray) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid)
gr export "subjects_k10_base.eps", replace
sum severe_distress if end==1 // 11.5% rate of severe distress

* Outcome Analysis: Hitting Partner — Table 2, Column 3
hist totExp7days if end==1, percent xline(500, lp(dash)) xtitle("Total consumption expenditure - weekly (GHS)") lcolor(none) fcolor(gray) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid)
gr export "subjects_totconsump_base.eps", replace
gen poor_consump = totExp7days<=500 if end==1 
sum poor_consump if end==1 // 81.7% rate of poor consumption



**framework-channels?
*ssc install lassopack
sum tmt01 tmt02 tmt_all
set more off

*1. professional networks: cc improved business-related services? we measure: use c.wages and c.income?
sum i1 //hrs worked for income (last 7days)
sum i2 //amt received from business income-related activites (last 7days)
*separate?
pdslasso i1 tmt01 tmt02 (i.districtX i.dateinterviewend i1b female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
test tmt01 tmt02
sum i1 if tmt_all==0
outreg2 using "ejSepEffectsXChannels.doc", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') replace

pdslasso i2 tmt01 tmt02 (i.districtX i.dateinterviewend i2c female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
test tmt01 tmt02
sum i2 if tmt_all==0
outreg2 using "ejSepEffectsXChannels.doc", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append


*pooled?
pdslasso i1 tmt_all (i.districtX i.dateinterviewend i1b female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum i1 if tmt_all==0
outreg2 using "ejMetaEffectsXChannels.doc", keep(tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') replace
pdslasso i2 tmt_all (i.districtX i.dateinterviewend i2c female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum i2 if tmt_all==0
outreg2 using "ejMetaEffectsXChannels.doc", keep(tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

*some evidence only on amt received from bus income-related activities



*2. social networks #1-inclusion: cc help indivs stay in touch with friends-related (social inclusion)? we measure: c.emotion and c. socinclusion?
tab i8 //emotionally + socially tired of staying home q= Are you tired (emotionally or socially) of staying home due to COVID19, its lockdown restrictions and other personal avoidance steps you have taken??
gen EmotSoc_Tired = (i8==1) if !missing(i8)
sum EmotSoc_Tired
*no baseline?
*separate?
pdslasso EmotSoc_Tired tmt01 tmt02 (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
test tmt01 tmt02
sum EmotSoc_Tired if tmt_all==0
outreg2 using "ejSepEffectsXChannels.doc", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

*pooled?
pdslasso EmotSoc_Tired tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum EmotSoc_Tired if tmt_all==0

outreg2 using "ejMetaEffectsXChannels.doc", keep(tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append
*very robust evidence improved soc inclusion


gen stayedHomelast5wks=(p3==1) if !missing(p3) //asked (@ end 2 only): Consider the last 5 weeks - are you staying home as much as possible because of the covid19 outbreak?
tab round stayedHomelast5wks
*separate?
pdslasso stayedHomelast5wks tmt01 tmt02 (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
test tmt01 tmt02
sum stayedHomelast5wks if tmt_all==0
outreg2 using "ejSepEffectsXChannels.doc", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

*pooled?
pdslasso stayedHomelast5wks tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum stayedHomelast5wks if tmt_all==0
outreg2 using "ejMetaEffectsXChannels.doc", keep(tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append
*not surprising, trted indivs are very compliant and stayed home more, corroborative of a comm-driven social inclusion of treated indivs



*3. social networks #2-risk sharing: cc improves or ejunivates perishing informal insurance arrangs? we measure: c.consumption taking adv of our indiv panel on consumption?
*see: https://www.jstor.org/stable/2937654?seq=16 
*totExp7days
bys caseidx: gen xdif=totExp7days1[_n]-totExp7days1[_n-1]
bys caseidx: gen xgrowth=(xdif/totExp7days1[_n])*100
tab regionX
tab regionX, nolab
gen  previouslock =(regionX==3 | regionX==6)
sum xgrowth if xgrowth, d
bys previouslock: sum xgrowth if (xgrowth>-300 & xgrowth<100), d //worst cgrowth in locked areas! so truly a shock [trimmed at 95%?]
/*
cdfplot xgrowth if (xgrowth>-650 & xgrowth<100), ///
  xline(-23.6, lp(dash) lw(vthin)) text(0.97 -100 "Shock: Median [-24%]", size(vsmall)) ///
  xline(-10.3, lp(solid) lw(vthin)) text(0.05 80 "No shock: Median [-10%]", size(vsmall)) ///
  by(previouslock) opt1(lc() lp(solid dash)) ///
  xtitle("Percent consumption growth") ytitle("Cumulative Probability") legend(pos(7) row(1) stack label(1 "No lockdown shock") label(2 "Lockdown shock"))
*/
cdfplot xgrowth if (xgrowth>-300 & xgrowth<100), ///
  by(previouslock) opt1(lc() lp(solid dash)) ///
  xtitle("Percent consumption growth") ytitle("Cumulative Probability") legend(pos(7) row(1) stack label(1 "Outside lockdown") label(2 "Inside lockdown (negative consumption shock)") size(small) region(lcolor(none))) ///
  graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid)
gr export "ejconsumpgrowthShock_graph.eps", replace
ksmirnov xgrowth if (xgrowth>-300 & xgrowth<100), by(previouslock) exact //p-val=0.020
*Title: "Distribution of consumption growth among individuals located outside and inside lockdown areas
*Note: Figure plots the distribution (CDF) of consumption growth per week at endline for the different subsamples (lockdown areas vs non-lockdown areas). Observations are at the individual level. Median (mean) percent consumption growth is -13% (-45%) for individuals in lockdown areas and -8% (-27%) for those in non-lockdown areas. From a Kolmogorov–Smirnov (KS) test for the equality of distributions, p-value equal 0.020 (for equality test, we trimmed the individual consumption growth outcome at the 5% level). Equality tests reject the null that the distributional pairs are equal.

*[rejuvination] test: what happens when combined with communication credit trts?
**//interact w COVID CASES in district?**
*separate?
pdslasso xgrowth c.tmt01##c.previouslock c.tmt02##c.previouslock (i.districtX i.dateinterviewend totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0) if (xgrowth>=-300 & xgrowth<=100), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
test c.tmt01#c.previouslock c.tmt02#c.previouslock

sum xgrowth if tmt_all==0
outreg2 using "ejSepEffectsXChannels.doc", keep(c.tmt01 c.tmt02#c.previouslock c.tmt02 c.tmt01#c.previouslock c.previouslock) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

*pooled?
pdslasso xgrowth c.tmt_all##c.previouslock (i.districtX i.dateinterviewend totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0) if (xgrowth>=-300 & xgrowth<=100), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum xgrowth if tmt_all==0
outreg2 using "ejMetaEffectsXChannels.doc", keep(tmt_all c.tmt_all#c.previouslock c.previouslock) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append
*limited evidence (though insig +7% increase in consumption grpowth for tranche treatment) -- yet theoretically plausible


**get rwolf pvals?
gen tmt01xLock =tmt01*previouslock 
gen tmt02xLock =tmt02*previouslock
rwolf i1 i2 EmotSoc_Tired stayedHomelast5wks xgrowth, indepvar(tmt01 tmt02) seed(124) reps(499)
rwolf i1 i2 EmotSoc_Tired xgrowth, indepvar(tmt01 tmt02 tmt01xLock tmt02xLock previouslock) seed(124) reps(499) //get for interactions
*rwolf i1 i2 EmotSoc_Tired stayedHomelast5wks xgrowth, indepvar(tmt01 tmt02 tmt01xLock tmt02xLock previouslock) seed(124)

*reply comment: 
*our conjecture was that this is related to the # of boots reps (of r=100) and it is not.
*the default # of bootstrap replications is 100 in STATA. 
*changing this to a larger number (which is usually recommended fo IV models) does not seem to change our overall inference, so ended up keeping the default
?






**presentation?
*I show separate effects
*I mention - effects larger + lasting for Installment credit
*gen Lumpsum =tmt01
*gen Installment = tmt02

**mitigation of unmitigated mobile calls/connections
pdslasso unableCall7days1 Lumpsum Installment (i.districtX i.dateinterviewend unableCall7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
estimates store unableCall7days1_meta
pdslasso unableToCOVID1 Lumpsum Installment (i.districtX i.dateinterviewend unableToCOVID female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
estimates store unableToCOVID1_meta
pdslasso digitborrow1 Lumpsum Installment (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
estimates store digitborrow1_meta
pdslasso digitloan1 Lumpsum Installment (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
estimates store digitloan1_meta


**plot individually and stack
coefplot ///
(unableCall7days1_meta, aseq(unable to call past 7days: 0-1) ///
\ unableToCOVID1_meta, aseq(unable to call due COVID19: 0-1) ///
\ digitborrow1_meta, aseq(seek / borrow SOS airtime: 0-1) ///
\ digitloan1_meta, aseq(seek digital loan: 0-1)), ///
keep(Lumpsum Installment) swapnames ///
level(90) xline(0, lp(dash) lw(vthin) lc(black)) ///
mlabel format(%9.02f) mlabposition(12) mlabgap(*4.5) mlabsize(tiny) ciopts(lwidth(*2) lcolor(*.6))
*coeflabels(tmt01="Trt program: lumpsum" tmt02="Trt program: installment")
gr export present_Mitigate.eps, replace


**real effects: outcomes
pdslasso totExp7days1 Lumpsum Installment (i.districtX i.dateinterviewend unableCall7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
estimates store totExp7days1_meta
pdslasso threatenPartner1 Lumpsum Installment  (i.districtX i.dateinterviewend unableToCOVID female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
estimates store threatenPartner1_meta
pdslasso hitPartner1 Lumpsum Installment  (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
estimates store hitPartner1_meta
pdslasso logk101 Lumpsum Installment  (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
estimates store logk101_meta
pdslasso severe_distress1 Lumpsum Installment  (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
estimates store severe_distress1_meta

**plot individually and stack
coefplot ///
(totExp7days1_meta, aseq(total expenditure: GHS) ///
\ threatenPartner1_meta, aseq(threatened partner: 1-4) ///
\ hitPartner1_meta, aseq(Hit Partner: 1-4) ///
\ logk101_meta, aseq(log [K10]) ///
\ severe_distress1_meta, aseq(severe distress: 0-1)), ///
keep(Lumpsum Installment) swapnames ///
level(90) xline(0, lp(dash) lw(vthin) lc(black)) ///
mlabel format(%9.02f) mlabposition(12) mlabgap(*4.5) mlabsize(tiny) ciopts(lwidth(*25) lcolor(*.6))
coeflabels(tmt01="Trt program: lumpsum" tmt02="Trt program: installment")
*gr export /Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/_Francis_Impacts/paper/results/_metateffects_outcomes.eps, replace

	coefplot ///
	(threatenPartner1_meta, aseq(threatened partner: 1-4) ///
	\ hitPartner1_meta, aseq(Hit Partner: 1-4) ///
	\ logk101_meta, aseq(log [K10]) ///
	\ severe_distress1_meta, aseq(severe distress: 0-1)), ///
	keep(Lumpsum Installment) swapnames ///
	level(90) xline(0, lp(dash) lw(vthin) lc(black)) ///
	mlabel format(%9.02f) mlabposition(12) mlabgap(*4.5) mlabsize(tiny) ciopts(lwidth(*2) lcolor(*.6))
	*coeflabels(tmt01="Trt program: lumpsum" tmt02="Trt program: installment")
	gr export present_Outcomes.eps, replace



	
	
	

	
**Comment: MHT Correction - The Romano-Wolf Multiple Hypothesis Correction
**Calculates Romano-Wolf stepdown adjusted p-values, which control the FWER and allows for dependence among p-values by bootstrap resampling
*NOTE:  The Romano-Wolf correction (asymptotically) controls the familywise error rate (FWER), that is, the probability of rejecting at least one true null hypothesis in a family of hypotheses under test (Clarke et al. 2020)
*(i) MEta?
rwolf unableCall7days1 unableToCOVID1 digitborrow1 digitloan1, indepvar(tmt_all) seed(124) reps(499) //fam 1 (fist stage outcomes)
rwolf totExp7days1 c1 c2 e1 e2 e3 e4 e5, indepvar(tmt_all) seed(124) reps(499) //fam 2 (second stage real impact outcomes)
rwolf threatenPartner1 hitPartner1 logk101 severe_distress1, indepvar(tmt_all) seed(124) //fam 3 (second stage real impact outcomes)
*(ii) SEparate?

rwolf unableCall7days1 unableToCOVID1 digitborrow1 digitloan1, indepvar(tmt01 tmt02) seed(124) //fam 1 (fist stage outcomes)
rwolf totExp7days1 c1 c2 e1 e2 e3 e4 e5, indepvar(tmt01 tmt02) seed(124) //fam 2 (second stage real impact outcomes - consumption)
rwolf threatenPartner1 hitPartner1 logk101 severe_distress1, indepvar(tmt01 tmt02) seed(124) //fam 3 (second stage real impact outcomes - mental health)



**meta Effects
**mitigate "unexpected" comm probl?
	leebounds unableCall7days1 tmt_all, level(90) cieffect tight() 
* Communication Constraint Outcome: Unable to Call — Table 1 or A1
reg unableCall7days1 tmt_all, r cluster(districtX)
sum unableCall7days1 if tmt_all==0
outreg2 using "metaEffects_mitigate.tex", keep(c.tmt_all) addtext(District FE, No, Date FE, No, Controls, None, Mean of dep. variable, `r(mean)') replace
pdslasso unableCall7days1 tmt_all (i.districtX i.dateinterviewend unableCall7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum unableCall7days1 if tmt_all==0
outreg2 using "metaEffects_mitigate.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append
*dyna fig
pdslasso unableCall7days1 c.tmt_all#c.round1 c.tmt_all#c.round2 (i.districtX i.dateinterviewend unableCall7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt_all#c.round1 c.tmt_all#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(45) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt_all#c.round1="Endline (round 1): Assignment" c.tmt_all#c.round2="Endline (round 2): Assignment") title("Survey-level: unable to communicate or call in past 7 days 0-1", size(med))
gr export "meta_unableCall7days.eps", replace

*robust-indivi-level clustering?
pdslasso unableCall7days1 tmt_all (i.districtX i.dateinterviewend unableCall7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
	
	
	leebounds unableToCOVID1 tmt_all, level(90) cieffect tight() 
* Communication Constraint Outcome: Unable to Call — Table 1 or A1
reg unableToCOVID1 tmt_all, r cluster(districtX)
sum unableToCOVID1 if tmt_all==0
outreg2 using "metaEffects_mitigate.tex", keep(c.tmt_all) addtext(District FE, No, Date FE, No, Controls, None, Mean of dep. variable, `r(mean)') append
pdslasso unableToCOVID1 tmt_all (i.districtX i.dateinterviewend unableToCOVID female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum unableToCOVID1 if tmt_all==0
outreg2 using "metaEffects_mitigate.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append
*dyna fig
pdslasso unableToCOVID1 c.tmt_all#c.round1 c.tmt_all#c.round2 (i.districtX i.dateinterviewend unableToCOVID female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt_all#c.round1 c.tmt_all#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(45) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt_all#c.round1="Endline (round 1): Assignment" c.tmt_all#c.round2="Endline (round 2): Assignment") title("Survey-level: unable to communicate or call due to COVID19 0-1", size(med))
gr export "meta_unableToCOVID.eps", replace
	
*robust-indivi-level clustering?
pdslasso unableToCOVID1 tmt_all (i.districtX i.dateinterviewend unableToCOVID female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
	
	
	leebounds digitborrow1 tmt_all, level(90) cieffect tight() 
reg digitborrow1 tmt_all, r cluster(districtX)
sum digitborrow1 if tmt_all==0
outreg2 using "metaEffects_mitigate.tex", keep(c.tmt_all) addtext(District FE, No, Date FE, No, Controls, None, Mean of dep. variable, `r(mean)') append
pdslasso digitborrow1 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum digitborrow1 if tmt_all==0
outreg2 using "metaEffects_mitigate.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append
*dyna fig
pdslasso digitborrow1 c.tmt_all#c.round1 c.tmt_all#c.round2 (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt_all#c.round1 c.tmt_all#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(45) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt_all#c.round1="Endline (round 1): Assignment" c.tmt_all#c.round2="Endline (round 2): Assignment") title("Survey-level: seek or borrow mobile credit 0-1")
gr export "meta_digitborrow.eps", replace

*robust-indivi-level clustering?
pdslasso digitborrow1 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
	

	leebounds digitloan1 tmt_all, level(90) cieffect tight() 
reg digitloan1 tmt_all, r cluster(districtX)
sum digitloan1 if tmt_all==0
outreg2 using "metaEffects_mitigate.tex", keep(c.tmt_all) addtext(District FE, No, Date FE, No, Controls, None, Mean of dep. variable, `r(mean)') append
pdslasso digitloan1 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum digitloan1 if tmt_all==0
outreg2 using "metaEffects_mitigate.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append title("Mitigation of communication constraints - unsaturated")
*dyna fig
pdslasso digitloan1 c.tmt_all#c.round1 c.tmt_all#c.round2 (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt_all#c.round1 c.tmt_all#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(45) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt_all#c.round1="Endline (round 1): Assignment" c.tmt_all#c.round2="Endline (round 2): Assignment") title("Survey-level: seek digital loan 0-1")
gr export "meta_digitloan.eps", replace
	
*robust-indivi-level clustering?
pdslasso digitloan1 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
	
	
	
**expenditure Shifts [resource reallocation effect]?
	leebounds totExp7days1 tmt_all, level(90) cieffect tight() 
pdslasso totExp7days1 tmt_all (i.districtX i.dateinterviewend totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum totExp7days1 if tmt_all==0
outreg2 using "metaEffects_consume.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') replace

	leebounds c1 tmt_all, level(90) cieffect tight() 
pdslasso c1 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum c1 if tmt_all==0
outreg2 using "metaEffects_consume.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

	leebounds c2 tmt_all, level(90) cieffect tight() 
pdslasso c2 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum c2 if tmt_all==0
outreg2 using "metaEffects_consume.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

	leebounds e1 tmt_all, level(90) cieffect tight() 
pdslasso e1 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum e1 if tmt_all==0
outreg2 using "metaEffects_consume.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

	leebounds e2 tmt_all, level(90) cieffect tight() 
pdslasso e2 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum e2 if tmt_all==0
outreg2 using "metaEffects_consume.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

	leebounds e3 tmt_all, level(90) cieffect tight() 
pdslasso e3 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum e3 if tmt_all==0
outreg2 using "metaEffects_consume.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

	leebounds e4 tmt_all, level(90) cieffect tight() 
pdslasso e4 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum e4 if tmt_all==0
outreg2 using "metaEffects_consume.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

	leebounds e5 tmt_all, level(90) cieffect tight() 
pdslasso e5 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(districtX) ///
    rlasso
sum e5 if tmt_all==0
outreg2 using "metaEffects_consume.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append title(" of communication credit on consumption expenditure - unsaturated")

*dyna fig
pdslasso totExp7days1 c.tmt_all#c.round1 c.tmt_all#c.round2 (i.districtX i.dateinterviewend totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt_all#c.round1 c.tmt_all#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(45) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt_all#c.round1="Endline (round 1): Assignment" c.tmt_all#c.round2="Endline (round 2): Assignment") title("Survey-level: consumption expenses (GHS)")
gr export "meta_totExp7days.eps", replace
	
	
**dV
	leebounds threatenPartner1 tmt_all, level(90) cieffect tight() 
pdslasso threatenPartner1 tmt_all (i.districtX i.dateinterviewend threatenPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum threatenPartner1 if tmt_all==0
outreg2 using "metaEffects_dv_mhealth.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') replace
*dyna fig
pdslasso threatenPartner1 c.tmt_all#c.round1 c.tmt_all#c.round2 (i.districtX i.dateinterviewend threatenPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///

    rlasso
coefplot, keep(c.tmt_all#c.round1 c.tmt_all#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(45) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt_all#c.round1="Endline (round 1): Assignment" c.tmt_all#c.round2="Endline (round 2): Assignment") title("Survey-level: threatened partner 1-4")
gr export "meta_threatenPartner.eps", replace

*robust-indivi-level clustering?
pdslasso threatenPartner1 tmt_all (i.districtX i.dateinterviewend threatenPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
	
	

	leebounds hitPartner1 tmt_all, level(90) cieffect tight() 
pdslasso hitPartner1 tmt_all (i.districtX i.dateinterviewend hitPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum hitPartner1 if tmt_all==0 
outreg2 using "metaEffects_dv_mhealth.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append
*dyna fig
pdslasso hitPartner1 c.tmt_all#c.round1 c.tmt_all#c.round2 (i.districtX i.dateinterviewend hitPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt_all#c.round1 c.tmt_all#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(45) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt_all#c.round1="Endline (round 1): Assignment" c.tmt_all#c.round2="Endline (round 2): Assignment") title("Survey-level: hit partner 1-4")
gr export "meta_hitPartner.eps", replace
	
*robust-indivi-level clustering?
pdslasso hitPartner1 tmt_all (i.districtX i.dateinterviewend hitPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso	

	
**mH
	leebounds logk101 tmt_all, level(90) cieffect tight() 
pdslasso logk101 tmt_all (i.districtX i.dateinterviewend logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum logk101 if tmt_all==0
outreg2 using "metaEffects_dv_mhealth.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append
*dyna fig
pdslasso logk101 c.tmt_all#c.round1 c.tmt_all#c.round2 (i.districtX i.dateinterviewend logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt_all#c.round1 c.tmt_all#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(45) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt_all#c.round1="Endline (round 1): Assignment" c.tmt_all#c.round2="Endline (round 2): Assignment") title("Survey-level: logK10")
gr export "meta_logk10.eps", replace

*robust-indivi-level clustering?
pdslasso logk101 tmt_all (i.districtX i.dateinterviewend logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso	

	leebounds severe_distress1 tmt_all, level(90) cieffect tight() 	
pdslasso severe_distress1 tmt_all (i.districtX i.dateinterviewend severe_distress female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0) , ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum severe_distress if tmt_all==0
outreg2 using "metaEffects_dv_mhealth.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append title(" of communication credit on domestic voilence and mental meaalth - unsaturated")

*dyna fig
pdslasso severe_distress1 c.tmt_all#c.round1 c.tmt_all#c.round2 (i.districtX i.dateinterviewend severe_distress female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt_all#c.round1 c.tmt_all#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(45) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt_all#c.round1="Endline (round 1): Assignment" c.tmt_all#c.round2="Endline (round 2): Assignment") title("Survey-level: severe distress 0-1")
gr export "meta_severe_distress.eps", replace

*robust-indivi-level clustering?
pdslasso severe_distress1 tmt_all (i.districtX i.dateinterviewend severe_distress female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso	
	
**Reviewer #4, request to report DV+MH results for w/out LASSO spec - MANUALLY ADD
reg threatenPartner1 tmt_all, r cluster(districtX)
reg hitPartner1 tmt_all, r cluster(districtX)
reg logk101 tmt_all, r cluster(districtX)
reg severe_distress1 tmt_all, r cluster(districtX)

**Reviewer #4 (robustness of log consump) + #3 (robustness of util/durables consump):
*Try log (consumption), log(e1, e5), results still there?
*try drop outliers -- To account for outliers, 
**we trimmed the utilities/durables consumption data at both the 1% and 5% levels, still sig
**however, when we take log of utilities/durables consumption, the results are insignificance
**we conclude that, the bseline effects on utilities/durables consumption are inconclusive
gen logtotExp7days1 = log(totExp7days1) 
gen loge1 = log(e1) //utilities
sum e1, d
gen trim1pctE1=e1 if e1>=r(p1) & e1<=r(p99)
gen trim5pctE1=e1 if e1>=r(p5) & e1<=r(p95)
gen loge5 = log(e5) //durables
sum e5, d
gen trim1pctE5=e5 if e5>=r(p1) & e5<=r(p99)
gen trim5pctE5=e5 if e5>=r(p5) & e5<=r(p95)


reg totExp7days1 tmt_all, r cluster(districtX) //not sig
reg logtotExp7days1 tmt_all, r cluster(districtX) //not sig
reg e1 tmt_all, r cluster(districtX) //sig
reg loge1 tmt_all, r cluster(districtX) //not sig
reg trim1pctE1 tmt_all, r cluster(districtX) //sig
reg trim5pctE1 tmt_all, r cluster(districtX) //sig

reg e5 tmt_all, r cluster(districtX) //sig
reg loge5 tmt_all, r cluster(districtX) //not sig
reg trim1pctE5 tmt_all, r cluster(districtX) //sig
reg trim5pctE5 tmt_all, r cluster(districtX) //sig

**Reviewer #1: baseline differences in DV/hit rates
*baseline?
bys female0: sum threatenPartner hitPartner
*hit: 1.19/4(m) vs 1.16/4(f) but insignificant (p-val=0.464)
ttest hitPartner, by(female0)
*endline?
bys female0: sum threatenPartner1 hitPartner1
*hit: 1.15/4(m) vs 1.09/4(f) but (in) sig at 13% (pval=1.124)
ttest hitPartner1, by(female0)

bys female0: sum k101
ttest k101, by(female0)


**Reviewer #$: hetero wrt baseline mh quartiles?
xtile quartMH = k10, nq(4)
pdslasso logk101 c.tmt_all#c.round1 c.tmt_all#c.round2 (i.districtX i.dateinterviewend logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt_all#c.round1 c.tmt_all#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(45) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt_all#c.round1="Endline (round 1): Assignment" c.tmt_all#c.round2="Endline (round 2): Assignment") title("Survey-level: logK10")



	
**separate Effects
**mitigate "unexpected" comm probl?
	leebounds unableCall7days1 tmt01, level(90) cieffect tight() 	
	leebounds unableCall7days1 tmt02, level(90) cieffect tight() 	
pdslasso unableCall7days1 tmt01 tmt02 (i.districtX i.dateinterviewend unableCall7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum unableCall7days1 if tmt_all==0
test tmt01 tmt02
outreg2 using "sepEffects_mitigate.tex", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, XX, p-value-jointtest, `r(p)') replace

*dyna fig
pdslasso unableCall7days1 c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2 (i.districtX i.dateinterviewend unableCall7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(60) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt01#c.round1="Endline (round 1): lumpsum" c.tmt02#c.round1="Endline (round 1): Installments" c.tmt01#c.round2="Endline (round 2): lumpsum" c.tmt02#c.round2="Endline (round 2): Installments") title("Survey-level: unable to communicate or call in past 7 days 0-1", size(med))
gr export "sep_unableCall7days.eps", replace
	
	
	leebounds unableToCOVID1 tmt01, level(90) cieffect tight() 	
	leebounds unableToCOVID1 tmt02, level(90) cieffect tight() 	
pdslasso unableToCOVID1 tmt01 tmt02 (i.districtX i.dateinterviewend unableToCOVID female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum unableToCOVID1 if tmt_all==0
test tmt01 tmt02
outreg2 using "sepEffects_mitigate.tex", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, XX, p-value-jointtest, `r(p)') append

*dyna fig
pdslasso unableToCOVID1 c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2  (i.districtX i.dateinterviewend unableToCOVID female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2 ) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(60) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt01#c.round1="Endline (round 1): lumpsum" c.tmt02#c.round1="Endline (round 1): Installments" c.tmt01#c.round2="Endline (round 2): lumpsum" c.tmt02#c.round2="Endline (round 2): Installments") title("Survey-level: unable to communicate or call due to COVID19 0-1", size(med))
gr export "sep_unableToCOVID.eps", replace
	
	
	leebounds digitborrow1 tmt01, level(90) cieffect tight() 	
	leebounds digitborrow1 tmt02, level(90) cieffect tight() 	
pdslasso digitborrow1 tmt01 tmt02 (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum digitborrow1 if tmt_all==0
test tmt01 tmt02
outreg2 using "sepEffects_mitigate.tex", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, XX, p-value-jointtest, `r(p)') append

*dyna fig
pdslasso digitborrow1 c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2  (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso

coefplot, keep(c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(60) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt01#c.round1="Endline (round 1): lumpsum" c.tmt02#c.round1="Endline (round 1): Installments" c.tmt01#c.round2="Endline (round 2): lumpsum" c.tmt02#c.round2="Endline (round 2): Installments") title("Survey-level: seek or borrow mobile credit 0-1")
gr export "sep_digitborrow.eps", replace
	
	leebounds digitloan1 tmt01, level(90) cieffect tight() 	
	leebounds digitloan1 tmt02, level(90) cieffect tight() 	
pdslasso digitloan1 tmt01 tmt02 (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum digitloan1 if tmt_all==0
test tmt01 tmt02
outreg2 using "sepEffects_mitigate.tex", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, XX, p-value-jointtest, `r(p)') append title("Mitigation of communication constraints - saturated")

*dyna fig
pdslasso digitloan1 c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2 (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(60) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt01#c.round1="Endline (round 1): lumpsum" c.tmt02#c.round1="Endline (round 1): Installments" c.tmt01#c.round2="Endline (round 2): lumpsum" c.tmt02#c.round2="Endline (round 2): Installments") title("Survey-level: seek digital loan 0-1")
gr export "sep_digitloan.eps", replace
	
	
	leebounds totExp7days1 tmt01, level(90) cieffect tight() 	
	leebounds totExp7days1 tmt02, level(90) cieffect tight() 	
**expenditure Shifts [resource reallocation effect]?
pdslasso totExp7days1 tmt01 tmt02 (i.districtX i.dateinterviewend totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum totExp7days1 if tmt_all==0
test tmt01 tmt02
outreg2 using "sepEffects_wellbeing_econ_mh.tex", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, XX, p-value-jointtest, `r(p)') replace

*dyna fig
pdslasso totExp7days1 c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2 (i.districtX i.dateinterviewend totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(60) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt01#c.round1="Endline (round 1): lumpsum" c.tmt02#c.round1="Endline (round 1): Installments" c.tmt01#c.round2="Endline (round 2): lumpsum" c.tmt02#c.round2="Endline (round 2): Installments") title("Survey-level: consumption expenses (GHS)")
gr export "sep_totExp7days.eps", replace
	

**dV
	leebounds threatenPartner1 tmt01, level(90) cieffect tight() 	
	leebounds threatenPartner1 tmt02, level(90) cieffect tight() 	
pdslasso threatenPartner1 tmt01 tmt02 (i.districtX i.dateinterviewend threatenPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum threatenPartner1 if tmt_all==0
test tmt01 tmt02
outreg2 using "sepEffects_wellbeing_econ_mh.tex", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, XX, p-value-jointtest, `r(p)') append

*dyna fig
pdslasso threatenPartner1 c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2 (i.districtX i.dateinterviewend threatenPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(60) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt01#c.round1="Endline (round 1): lumpsum" c.tmt02#c.round1="Endline (round 1): Installments" c.tmt01#c.round2="Endline (round 2): lumpsum" c.tmt02#c.round2="Endline (round 2): Installments") title("Survey-level: threatened partner 1-4")
gr export "sep_threatenPartner.eps", replace
	

	leebounds hitPartner1 tmt01, level(90) cieffect tight() 	
	leebounds hitPartner1 tmt02, level(90) cieffect tight() 	
pdslasso hitPartner1 tmt01 tmt02 (i.districtX i.dateinterviewend hitPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum hitPartner1 if tmt_all==0
test tmt01 tmt02
outreg2 using "sepEffects_wellbeing_econ_mh.tex", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, XX, p-value-jointtest, `r(p)') append

*dyna fig
pdslasso hitPartner1 c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2 (i.districtX i.dateinterviewend hitPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(60) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt01#c.round1="Endline (round 1): lumpsum" c.tmt02#c.round1="Endline (round 1): Installments" c.tmt01#c.round2="Endline (round 2): lumpsum" c.tmt02#c.round2="Endline (round 2): Installments") title("Survey-level: hit partner 1-4")
gr export "sep_hitPartner.eps", replace
	
	
	
**mH
	leebounds logk101 tmt01, level(90) cieffect tight() 	
	leebounds logk101 tmt02, level(90) cieffect tight() 	
pdslasso logk101 c.tmt01 c.tmt02 (i.districtX i.dateinterviewend logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum logk101 if tmt_all==0
test tmt01 tmt02
outreg2 using "sepEffects_wellbeing_econ_mh.tex", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, XX, p-value-jointtest, `r(p)') append

*dyna fig
pdslasso logk101 c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2 (i.districtX i.dateinterviewend logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(60) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt01#c.round1="Endline (round 1): lumpsum" c.tmt02#c.round1="Endline (round 1): Installments" c.tmt01#c.round2="Endline (round 2): lumpsum" c.tmt02#c.round2="Endline (round 2): Installments") title("Survey-level: logK10")
gr export "sep_logk10.eps", replace
	
	leebounds severe_distress1 tmt01, level(90) cieffect tight() 	
	leebounds severe_distress1 tmt02, level(90) cieffect tight() 	
pdslasso severe_distress1 c.tmt01 c.tmt02 (i.districtX i.dateinterviewend i.severe_distress female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum severe_distress1 if tmt_all==0
sum severe_distress if tmt_all==0
test tmt01 tmt02
outreg2 using "sepEffects_wellbeing_econ_mh.tex", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, XX, p-value-jointtest, `r(p)') append title(" of communication credit on wellbeing - saturated")

*dyna fig
pdslasso severe_distress1 c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2  (i.districtX i.dateinterviewend severe_distress female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(60) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt01#c.round1="Endline (round 1): lumpsum" c.tmt02#c.round1="Endline (round 1): Installments" c.tmt01#c.round2="Endline (round 2): lumpsum" c.tmt02#c.round2="Endline (round 2): Installments") title("Survey-level: severe distress 0-1")
gr export "sep_severe_distress.eps", replace
	
	
	
	
	
	

	
**Heterogeneity: ?
* Robustness Check: Romano-Wolf Multiple Testing Correction
**Comment: MHT Correction - The Romano-Wolf Multiple Hypothesis Correction
*(i) MEta?
*rwolf unableCall7days1 unableToCOVID1 digitborrow1 digitloan1, indepvar(tmt_all) seed(124) //fam 1 (fist stage outcomes)
gen jointPov = tmt_all*pov_likelihood
gen jointInf = tmt_all*informal0
gen jointFem = tmt_all*female0
gen jointLoc = tmt_all*previouslock
rwolf totExp7days1 c1 c2 e1 e2 e3 e4 e5, indepvar(tmt_all pov_likelihood jointPov) seed(124)
rwolf threatenPartner1 hitPartner1 logk101 severe_distress1, indepvar(tmt_all jointPov) seed(124) //not estimable for all 3

rwolf totExp7days1 c1 c2 e1 e2 e3 e4 e5, indepvar(tmt_all informal0 jointInf) seed(124)
rwolf threatenPartner1 hitPartner1 logk101 severe_distress1, indepvar(tmt_all informal0 jointInf) seed(124)

rwolf totExp7days1 c1 c2 e1 e2 e3 e4 e5, indepvar(tmt_all jointFem female0) seed(124)
rwolf threatenPartner1 hitPartner1 logk101 severe_distress1, indepvar(tmt_all female0 jointFem) seed(124)

rwolf totExp7days1 c1 c2 e1 e2 e3 e4 e5, indepvar(tmt_all previouslock jointLoc) seed(124)
rwolf threatenPartner1 hitPartner1 logk101 severe_distress1, indepvar(tmt_all jointLoc) seed(124) //not estimable for all 3
/*(ii) SEparate?
rwolf unableCall7days1 unableToCOVID1 digitborrow1 digitloan1, indepvar(tmt01 tmt02) seed(124) //fam 1 (fist stage outcomes)
rwolf totExp7days1 c1 c2 e1 e2 e3 e4 e5, indepvar(tmt01 tmt02) seed(124) //fam 2 (second stage real impact outcomes - consumption)
rwolf threatenPartner1 hitPartner1 logk101 severe_distress1, indepvar(tmt01 tmt02) seed(124) //fam 3 (second stage real impact outcomes - mental health)
*/

**Reviewer #4 -- asking for more heterogeneity?
**(0) baseline mhealth0?
xtile logk10_quartile=logk10,n(4)
xtile threatenPartner_quart=threatenPartner,n(4)
xtile hitPartner_quart=hitPartner,n(4)
*use a/b median to avoid running out of empty cells in quartiles
sum k10, d
gen k10_high=(k10> r(p50))
sum threatenPartner, d
gen threatenPartner_high=(threatenPartner> r(p50))
sum hitPartner, d
gen hitPartner_high=(hitPartner> r(p50))
pdslasso totExp7days1 c.tmt_all##c.k10_high (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
pdslasso threatenPartner1 c.tmt_all##c.k10_high (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
pdslasso hitPartner1 c.tmt_all##c.k10_high (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
pdslasso logk101 c.tmt_all##c.k10_high (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
pdslasso severe_distress1 c.tmt_all##c.k10_high (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso	

	*baseline dv=threatened0?
pdslasso totExp7days1 c.tmt_all##c.threatenPartner_high (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
pdslasso threatenPartner1 c.tmt_all##c.threatenPartner_high (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///

    rlasso
pdslasso hitPartner1 c.tmt_all##c.threatenPartner_high (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
pdslasso logk101 c.tmt_all##c.threatenPartner_high (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
pdslasso severe_distress1 c.tmt_all##c.threatenPartner_high (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso	
	
	*baseline dv=hit partner0?
pdslasso totExp7days1 c.tmt_all##c.hitPartner_high (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
pdslasso threatenPartner1 c.tmt_all##c.hitPartner_high (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
pdslasso hitPartner1 c.tmt_all##c.hitPartner_high (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
pdslasso logk101 c.tmt_all##c.hitPartner_high (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
pdslasso severe_distress1 c.tmt_all##c.hitPartner_high (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso	
	
	
	
	

**(1)poverty? evidence: the modest DV reduction is sig more on the very poor (similarly for mental health but ns)
pdslasso totExp7days1 c.tmt_all##c.pov_likelihood (i.districtX i.dateinterviewend totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum totExp7days1 if tmt_all==0
outreg2 using "metaEffects_Xpoverty.tex", keep(c.tmt_all c.pov_likelihood c.tmt_all#c.pov_likelihood) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') replace

pdslasso threatenPartner1 c.tmt_all##c.pov_likelihood (i.districtX i.dateinterviewend threatenPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum threatenPartner1 if tmt_all==0
outreg2 using "metaEffects_Xpoverty.tex", keep(c.tmt_all c.pov_likelihood c.tmt_all#c.pov_likelihood) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

pdslasso hitPartner1 c.tmt_all##c.pov_likelihood (i.districtX i.dateinterviewend hitPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum hitPartner1 if tmt_all==0
outreg2 using "metaEffects_Xpoverty.tex", keep(c.tmt_all c.pov_likelihood c.tmt_all#c.pov_likelihood) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

pdslasso logk101 c.tmt_all##c.pov_likelihood (i.districtX i.dateinterviewend logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum logk101 if tmt_all==0
outreg2 using "metaEffects_Xpoverty.tex", keep(c.tmt_all c.pov_likelihood c.tmt_all#c.pov_likelihood) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

pdslasso severe_distress1 c.tmt_all##c.pov_likelihood (i.districtX i.dateinterviewend severe_distress female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum severe_distress if tmt_all==0
outreg2 using "metaEffects_Xpoverty.tex", keep(c.tmt_all c.pov_likelihood c.tmt_all#c.pov_likelihood) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append



**(2)informal0? evidence: those in informal sector experienced large/better-sig mental health effects
pdslasso totExp7days1 c.tmt_all##c.informal0 (i.districtX i.dateinterviewend totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum totExp7days1 if tmt_all==0
outreg2 using "metaEffects_Xinformal.tex", keep(c.tmt_all c.informal0 c.tmt_all#c.informal0) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') replace

pdslasso threatenPartner1 c.tmt_all##c.informal0 (i.districtX i.dateinterviewend threatenPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0  incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum threatenPartner1 if tmt_all==0
outreg2 using "metaEffects_Xinformal.tex", keep(c.tmt_all c.informal0 c.tmt_all#c.informal0) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

pdslasso hitPartner1 c.tmt_all##c.informal0 (i.districtX i.dateinterviewend hitPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0  incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum hitPartner1 if tmt_all==0
outreg2 using "metaEffects_Xinformal.tex", keep(c.tmt_all c.informal0 c.tmt_all#c.informal0) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

pdslasso logk101 c.tmt_all##c.informal0 (i.districtX i.dateinterviewend logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0  incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum logk101 if tmt_all==0
outreg2 using "metaEffects_Xinformal.tex", keep(c.tmt_all c.informal0 c.tmt_all#c.informal0) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

pdslasso severe_distress1 c.tmt_all##c.pov_likelihood (i.districtX i.dateinterviewend severe_distress female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0  incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum severe_distress if tmt_all==0
outreg2 using "metaEffects_Xinformal.tex", keep(c.tmt_all c.informal0 c.tmt_all#c.informal0) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

	
	
**(3)female/gender? evidence: females experienced "slightly" (ns, but) better mental health effects
pdslasso totExp7days1 c.tmt_all##c.female0 (i.districtX i.dateinterviewend totExp7days akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum totExp7days1 if tmt_all==0
outreg2 using "metaEffects_Xfemale.tex", keep(c.tmt_all c.female0 c.tmt_all#c.female0) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') replace

pdslasso threatenPartner1 c.tmt_all##c.female0 (i.districtX i.dateinterviewend threatenPartner akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum threatenPartner1 if tmt_all==0
outreg2 using "metaEffects_Xfemale.tex", keep(c.tmt_all c.female0 c.tmt_all#c.female0) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

pdslasso hitPartner1 c.tmt_all##c.female0 (i.districtX i.dateinterviewend hitPartner akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum hitPartner1 if tmt_all==0
outreg2 using "metaEffects_Xfemale.tex", keep(c.tmt_all c.female0 c.tmt_all#c.female0) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

pdslasso logk101 c.tmt_all##c.female0 (i.districtX i.dateinterviewend logk10 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum logk101 if tmt_all==0
outreg2 using "metaEffects_Xfemale.tex", keep(c.tmt_all c.female0 c.tmt_all#c.female0) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

pdslasso severe_distress1 c.tmt_all##c.female0 (i.districtX i.dateinterviewend severe_distress akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum severe_distress if tmt_all==0
outreg2 using "metaEffects_Xfemale.tex", keep(c.tmt_all c.female0 c.tmt_all#c.female0) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append



**(4)region: never-lock vs no previously-lock = so might still be battling (direct) econ ? evidence: eager to re-allocate their budgets to more consumption (utilities and durables, as expected)
tab regionX
tab regionX, nolab
gen  previouslock =(regionX==3 | regionX==6)
pdslasso totExp7days1 c.tmt_all##c.previouslock (i.districtX i.dateinterviewend totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum totExp7days1 if tmt_all==0
outreg2 using "metaEffects_Xlockeddown.tex", keep(c.tmt_all c.previouslock c.tmt_all#c.previouslock) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') replace

pdslasso threatenPartner1 c.tmt_all##c.previouslock (i.districtX i.dateinterviewend threatenPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum threatenPartner1 if tmt_all==0
outreg2 using "metaEffects_Xlockeddown.tex", keep(c.tmt_all c.previouslock c.tmt_all#c.previouslock) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

pdslasso hitPartner1 c.tmt_all##c.previouslock (i.districtX i.dateinterviewend hitPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum hitPartner1 if tmt_all==0
outreg2 using "metaEffects_Xlockeddown.tex", keep(c.tmt_all c.previouslock c.tmt_all#c.previouslock) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

pdslasso logk101 c.tmt_all##c.previouslock (i.districtX i.dateinterviewend logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum logk101 if tmt_all==0
outreg2 using "metaEffects_Xlockeddown.tex", keep(c.tmt_all c.previouslock c.tmt_all#c.previouslock) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

pdslasso severe_distress1 c.tmt_all##c.previouslock (i.districtX i.dateinterviewend severe_distress female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum severe_distress if tmt_all==0
outreg2 using "metaEffects_Xlockeddown.tex", keep(c.tmt_all c.previouslock c.tmt_all#c.previouslock) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append



	
	
**self employed? evidence: none
pdslasso totExp7days1 c.tmt_all##c.selfEmploy0 (i.districtX i.dateinterviewend totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 informal0 incomegrp0), ///
    partial(i.districtX) ///

    cluster(districtX) ///
    rlasso
pdslasso threatenPartner1 c.tmt_all##c.selfEmploy0 (i.districtX i.dateinterviewend threatenPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(districtX) ///
    rlasso
pdslasso hitPartner1 c.tmt_all##c.selfEmploy0 (i.districtX i.dateinterviewend hitPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(districtX) ///
    rlasso
pdslasso logk101 c.tmt_all##c.selfEmploy0 (i.districtX i.dateinterviewend logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(districtX) ///
    rlasso
pdslasso severe_distress1 c.tmt_all##c.selfEmploy0 (i.districtX i.dateinterviewend severe_distress female0 akan0 married0 ageYrs0 jhs0 hhsize0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(districtX) ///
    rlasso
	
**self: does housework? evidence: none
pdslasso totExp7days1 c.tmt_all##c.self_hseWork0 (i.districtX i.dateinterviewend totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(districtX) ///
    rlasso
pdslasso threatenPartner1 c.tmt_all##c.self_hseWork0 (i.districtX i.dateinterviewend threatenPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(districtX) ///
    rlasso
pdslasso hitPartner1 c.tmt_all##c.self_hseWork0 (i.districtX i.dateinterviewend hitPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(districtX) ///
    rlasso
pdslasso logk101 c.tmt_all##c.self_hseWork0 (i.districtX i.dateinterviewend logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(districtX) ///
    rlasso
pdslasso severe_distress1 c.tmt_all##c.self_hseWork0 (i.districtX i.dateinterviewend severe_distress female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(districtX) ///
    rlasso

	
	
	
	

*Validity and balanced-yes? redo again to verify
********************************************************
********************************************************
tab i11 if end==1, miss
gen Trust = (trustgovtCOVIDNos0>=3) if !missing(trustgovtCOVIDNos0)
sum  female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 motherTogether noReligion spouseTogether ageMarried if end==1
sum pov_likelihood if end==1
sum awareofCOVID0 Trust previouslock self_hseWork0 bd30 if end==1
sum needToCOVID unableCall7days unableToCOVID unableTrans7days bd10 bd20 bd30 ct1a0 ct1b0 ct2a0 ct2b0 if end==1
sum totExp7days threatenPartner hitPartner logk10 severe_distress tiredCOVID m110 m120 m130 m140 if end==1


*x-s (from main step 1)
reg female0 tmt01 tmt02 if round==3, r cluster(districtX)
reg akan0 tmt01 tmt02 if round ==3, r cluster(districtX)
reg married0 tmt01 tmt02 if round ==3, r cluster(districtX)
reg jhs0 tmt01 tmt02 if round ==3, r cluster(districtX)
reg hhsize0 tmt01 tmt02 if round ==3, r cluster(districtX)
reg selfEmploy0 tmt01 tmt02 if round ==3, r cluster(districtX)
reg informal0 tmt01 tmt02 if round ==3, r cluster(districtX)
reg incomegrp0 tmt01 tmt02 if round ==3, r cluster(districtX)
reg self_hseWork0 tmt01 tmt02 if round ==3, r cluster(districtX)  
reg previouslock tmt01 tmt02 if round ==3, r cluster(districtX)  
reg awareofCOVID0 tmt01 tmt02 if round ==3, r cluster(districtX)  
reg trustgovtCOVIDNos0 tmt01 tmt02 if round ==3, r cluster(districtX)  

**more x-s (from step 0)
reg pov_likelihood tmt01 tmt02 if round ==3, r cluster(districtX) 
reg motherTogether tmt01 tmt02 if round ==3, r cluster(districtX) 
reg noReligion tmt01 tmt02 if round ==3, r cluster(districtX) 
reg spouseTogether tmt01 tmt02 if round ==3, r cluster(districtX) 
reg ageMarried tmt01 tmt02 if round ==3, r cluster(districtX)
reg tmt_all female0 akan0 married0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 self_hseWork0 previouslock awareofCOVID0 trustgovtCOVIDNos0 pov_likelihood motherTogether noReligion spouseTogether ageMarried, cluster(districtX)
probit tmt_all female0 akan0 married0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 self_hseWork0 previouslock awareofCOVID0 trustgovtCOVIDNos0 pov_likelihood motherTogether noReligion spouseTogether ageMarried, cluster(districtX)


*y0-best correlates
* Main Outcome: Unable to Call (7 Days or COVID-related) — Table 1 or A1
reg unableCall7days tmt01 tmt02 if round==3, r cluster(districtX)
* Main Outcome: Unable to Call (7 Days or COVID-related) — Table 1 or A1
reg unableToCOVID tmt01 tmt02 if round==3, r cluster(districtX)
reg totExp7days tmt01 tmt02 if round==3, r cluster(districtX)
reg c1 tmt01 tmt02 if round==3, r cluster(districtX)
reg c2 tmt01 tmt02 if round==3, r cluster(districtX)
reg e1 tmt01 tmt02 if round==3, r cluster(districtX)
reg e2 tmt01 tmt02 if round==3, r cluster(districtX)
reg e3 tmt01 tmt02 if round==3, r cluster(districtX)
reg e4 tmt01 tmt02 if round==3, r cluster(districtX)
reg e5 tmt01 tmt02 if round==3, r cluster(districtX)
reg threatenPartner tmt01 tmt02 if round==3, r cluster(districtX)
reg hitPartner tmt01 tmt02 if round==3, r cluster(districtX)
* Mental Health Outcome: log K10 or Severe Distress — Table 2
reg logk10 tmt01 tmt02 if round==3, r cluster(districtX)
reg severe_distress tmt01 tmt02 if round==3, r cluster(districtX)
reg tiredCOVID tmt01 tmt02 if round==3, r cluster(districtX)

reg m110 tmt01 tmt02 if round==3, r cluster(districtX) //depressed? 1-5
reg m120 tmt01 tmt02 if round==3, r cluster(districtX) //relaxed? 1-5
reg m130 tmt01 tmt02 if round==3, r cluster(districtX) //life-satisfied: 1-5 scale
reg m140 tmt01 tmt02 if round==3, r cluster(districtX) //finance-satisfied:  1-5 scale



**bring in Wave 2 (for a few other controls but not in Wave 1?)
use "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/DATA/Round_2/impact_covid_roundFINAL.dta", clear
gen round=2
tab round
merge m:1 caseidx using "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/_Francis_Impacts/MobileCredit40GHS_376list" //(but 1:1 for 12/6)
drop _merge
gen MobileCredit40=MobileCredit
drop MobileCredit
tab MobileCredit40 
merge m:m caseidx using "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/_Francis_Impacts/MobileCredit20GHS_371list_Wave1"  //(but 1:m for 12/6)
drop _merge
gen MobileCredit20=MobileCredit
drop MobileCredit
tab MobileCredit20

gen MobileCredit = MobileCredit40 
replace MobileCredit = MobileCredit20 if !missing(MobileCredit20)

*keep if interviewn_result==1
bys caseidx: keep if _n==1
gen tmt_all= !missing(MobileCredit) 
gen tmt01= (MobileCredit=="40GHS") 
gen tmt02= (MobileCredit=="20GHS") 
gen tmt_all2= (MobileCredit=="40GHS" | MobileCredit=="20GHS") 
gen tmt= 0
replace tmt=1 if tmt01==1
replace tmt=2 if tmt02==1
sum tmt_all tmt_all2 tmt01 tmt02 tmt

*add dsitrrictX
merge m:m caseidx using "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/_Francis_Impacts/TrtList00" //bring in round 1 = base & X's

**balance?
gen digitborrow0=(bd1==1) if !missing(bd1) 
gen digitloan0=(bd2==1) if !missing(bd1) 
gen relocated0=(bd3==1) if !missing(bd1) 

sum digitborrow0 digitloan0 relocated0 
* Main Outcome: Borrowed SOS Airtime — Table 1
reg digitborrow0 tmt01 tmt02, r cluster(districtX) // borrowed airtime?
* Main Outcome: Borrowed SOS Airtime — Table 1
reg digitloan0 tmt01 tmt02, r cluster(districtX) // seek or borrowed digital loan?
reg relocated0 tmt01 tmt02, r cluster(districtX) // has related?




**Attrition: stats?
use "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/DATA/Round_1/impact10.102020Final.dta", clear
gen wave =1
keep if interviewn_result==1
bys caseidx wave: keep if _n==1  //tot subjects = 1130

merge m:1 caseidx using "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/_Francis_Impacts/MobileCredit40GHS_376list" //(but 1:1 for 12/6)
drop _merge
gen MobileCredit40=MobileCredit
drop MobileCredit
tab MobileCredit40 
merge m:m caseidx using "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/_Francis_Impacts/MobileCredit20GHS_371list_Wave1"  //(but 1:m for 12/6)
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
saveold "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/_Francis_Impacts/MobileCredit_attrition", replace




	
**Data Collection- Plot Data Days - round 0, 1, 2, 3, 4
********************************************************
********************************************************
use "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/DATA/Round_1/impact10.102020Final.dta", clear
gen round =1
** add-round 2
append using "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/DATA/Round_2/impact_covid_roundFINAL.dta"
replace round=2 if missing(round)
tab round
** add-round 3
append using "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/DATA/Round_3/round3_data_21.11.dta"
replace round=3 if missing(round)
tab round
** add-round 4
append using "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/DATA/Round_4/round4_data_19.12.dta"
replace round=4 if missing(round)

tab round
*keep if interviewn_result==1

append using "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/COVID ZERO STEP/Stata/ZeroScoreData_26_09_p1.dta"
replace round=0 if missing(round)
tab round
replace date_of_interview=12092020 if (date_of_interview==1609 | date_of_interview==1709 | date_of_interview==1809 | date_of_interview==2009 | date_of_interview==2109 | date_of_interview==2209 | date_of_interview==1609202)
replace dateinterviewend = date_of_interview if round==0

keep if (interviewn_result==1 | q2==1)
tab round

gen long dates = dateinterviewend //lost precision >7 digits?
tostring dates, replace format(%08.0f)
replace dates = "0" + dates if length(dates) == 7
order dateinterviewend dates
gen edates = date(dates,"DMY")
format edates %td


levelsof edates, local(levels)
*local levels 29sep2020 10oct2020 20oct2020 29oct2020 01nov2020 11nov2020 29nov2020
*scatter yobs edates, sort msymbol(Oh) color(blue) , xla(`levels', valuelabel angle(70) labsize(vsmall)) ytitle("Number of subjects") xtitle("Date of phone survey")
hist edates, ///
 xline(`=d(27oct2020)' `=d(29oct2020)', lp(dash)) text(350 `=d(28oct2020)' "Intervention I", orient(vert)) ///
 xline(`=d(24nov2020)' `=d(26nov2020)', lp(dash)) text(350 `=d(25nov2020)' "Intervention II", orient(vert)) ///
 text(383 `=d(18sep2020)' "Data:  " "step 0" 185 `=d(04oct2020)' "Data  " "wave I" 255 `=d(23oct2020)' "Data  " "wave II" 185 `=d(06nov2020)' "Data  " "wave III" 185 `=d(05dec2020)' "Data " "wave IV") ///
 text(20 `=d(19sep2020)' "N=1,993" 20 `=d(04oct2020)' "n=1,131" 20 `=d(24oct2020)' "N=1,1043" 20 `=d(06nov2020)' "N=1,048" 20 `=d(03dec2020)' "N=0997", size(small) color(blue)) ///
 frequency discrete  xla(`=d(13sep2020)' `=d(25sep2020)' `=d(29sep2020)' `=d(10oct2020)' `=d(20oct2020)' `=d(29oct2020)' `=d(01nov2020)' `=d(11nov2020)' `=d(28nov2020)' `=d(09dec2020)', valuelabel angle(50) labsize(small)) ytitle("Number of subjects") xtitle("Date of phone survey") fcolor(green) lcolor(black) ///
* Domestic Violence Outcomes: Threaten/Hit Partner — Table 2
 title("") graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid)
 *frequency discrete  xla(#10, valuelabel angle(50) labsize(vsmall)) ytitle("Number of subjects") xtitle("Date of phone survey") fcolor(green) lcolor(black) ///
 *title("")
 *frequency discrete  xla(`levels', valuelabel angle(50) labsize(vsmall)) ytitle("Number of subjects") xtitle("Date of phone survey") fcolor(green) lcolor(black) ///
 *title("")
*gr export "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/_Francis_/paper/results/datacollection.eps", replace
gr export "/Users/fannan/Dropbox/Annan Archibong et al./belinda_main/covid19 paper/IMPACT_COVID19 DATA/_Francis_Impacts/paper/results/datacollectionr.eps", replace

/* no round 0
levelsof edates, local(levels)
*local levels 29sep2020 10oct2020 20oct2020 29oct2020 01nov2020 11nov2020 29nov2020
*scatter yobs edates, sort msymbol(Oh) color(blue) , xla(`levels', valuelabel angle(70) labsize(vsmall)) ytitle("Number of subjects") xtitle("Date of phone survey")
hist edates, xline(`=d(27oct2020)' `=d(29oct2020)', lp(dash)) text(220 `=d(28oct2020)' "Intervention I", orient(vert)) ///
 xline(`=d(24nov2020)' `=d(26nov2020)', lp(dash)) text(220 `=d(25nov2020)' "Intervention II", orient(vert)) ///
 text(175 `=d(04oct2020)' "Data  " "wave I" 245 `=d(23oct2020)' "Data  " "wave II" 175 `=d(06nov2020)' "Data  " "wave III" 170 `=d(30nov2020)' "Data  " "wave IV") ///
 frequency discrete  xla(`levels', valuelabel angle(65) labsize(vsmall)) ytitle("Number of subjects") xtitle("Date of phone survey") fcolor(green) lcolor(black) ///
 title("Data Collection")
*/
 
 
 

 

 
 
 
 
 
 
 ?
/*
 
***Main Round 3 = Endline I (1-2wks)
use "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/DATA/Round_3/round3_data_21.11.dta", clear
gen round = 3
merge 1:1 caseidx using "MobileCredit40GHS_376list"
drop _merge
gen MobileCredit40=MobileCredit
drop MobileCredit
tab MobileCredit40 
merge 1:m caseidx using "MobileCredit20GHS_371list_Wave1"
drop _merge
gen MobileCredit20=MobileCredit
drop MobileCredit
tab MobileCredit20

gen MobileCredit = MobileCredit40 
replace MobileCredit = MobileCredit20 if !missing(MobileCredit20)
/*
**share-ing lists?
keep callern caller_id MobileCredit PhoneNumber phone_number_of_respondent caseidx
*keep if !missing(MobileCredit) //round 1 list
keep if MobileCredit=="20GHS"  //round 2 list

sort caller_id
*outsheet using "MobileCredit_R1list.xls", replace
outsheet using "MobileCredit_R2list.xls", replace
*/

drop Trt
merge m:m caseidx using "TrtList00" //bring in round 1 = base & X's
drop _merge 

*keep if interviewn_result==1
bys caseidx: keep if _n==1

**get outcomes
gen needToCOVID1=(i9==1)
gen unableToCOVID1=(i10==1)
gen unableCall7days1 =(cr1==1)
gen volCalls = ct1a 
gen valueCalls = ct1b
gen unableTrans7days1 =(cr2==1)
gen volTransfer = ct2a 
gen valueTransfer = ct2a
gen digitborrow1=(bd1==1)
gen digitloan1=(bd2==1)

egen totExp7days1= rowtotal(c1-e5), missing
gen threatenPartner1=g1
gen hitPartner1=g1
egen k101= rowtotal(m1-m10), missing
*hist k101, percent xline(30) xtitle("K10 Score") 
gen logk101 = log(k101)
gen severe_distress1 = (k101>=30) if !missing(k101)
gen tiredCOVID1=(i8==1)


browse caseidx MobileCredit Trt //construct correct treatment varaibles
gen tmt_all= !missing(MobileCredit) 
gen tmt01= (MobileCredit=="40GHS") 
gen tmt02= (MobileCredit=="20GHS") 
gen tmt_all2= (MobileCredit=="40GHS" | MobileCredit=="20GHS") 
gen tmt= 0
replace tmt=1 if tmt01==1
replace tmt=2 if tmt02==1
sum tmt_all tmt_all2 tmt01 tmt02 tmt


hist k101, percent xline(30) xtitle("K10 Score") by(tmt)
tw kdensity k101 if tmt==0, xline(30) xtitle("K10 Score") lp("solid") || kdensity k101  if tmt==1, lp("shortdash") || kdensity k101  if tmt==2, lp("longdash")


*Stylized facts 
sum needToCOVID //Very congruent with administrative data evidence
sum unableToCOVID unableCall7days unableTrans7days ct1a0 ct1b0 ct2a0 ct2b0 totExp7days threatenPartner hitPartner logk10 severe_distress tiredCOVID


**y-stage 1
reg unableToCOVID1 i.districtX unableToCOVID female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 c.tmt_all , r cluster(districtX)
reg unableToCOVID1 i.districtX i.unableToCOVID female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02, r cluster(districtX)
test tmt01 tmt02

reg unableCall7days1 i.districtX unableCall7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 c.tmt_all , r cluster(districtX)
reg unableCall7days1 i.districtX unableCall7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02, r cluster(districtX)
test tmt01 tmt02

*any leaks in calls, yes for only 40ghs group
reg volCalls i.districtX ct1a0 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 c.tmt_all, r cluster(districtX)
reg volCalls i.districtX ct1a0 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02, r cluster(districtX)
reg valueCalls i.districtX ct1b0 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 c.tmt_all if valueCalls>0, r cluster(districtX)
reg valueCalls i.districtX ct1b0 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02 if valueCalls>0, r cluster(districtX)


reg unableTrans7days1 i.districtX unableTrans7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 c.tmt_all, r cluster(districtX)
reg unableTrans7days1 i.districtX unableTrans7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02, r cluster(districtX)
test tmt01 tmt02

*any leaks in transfer, no
reg volTransfer i.districtX ct2a0 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 c.tmt_all, r cluster(districtX)
reg volTransfer i.districtX ct2a0 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02, r cluster(districtX)
reg valueTransfer i.districtX ct2b0 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 c.tmt_all if valueTransfer>0, r cluster(districtX)
reg valueTransfer i.districtX ct2b0 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02 if valueTransfer>0, r cluster(districtX)

**no base-outcomes
reg digitborrow1 i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 c.tmt_all, r cluster(districtX)
reg digitborrow1 i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02, r cluster(districtX)
test tmt01 tmt02

reg digitloan1 i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 c.tmt_all , r cluster(districtX)
reg digitloan1 i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02, r cluster(districtX)
test tmt01 tmt02


*y-stage 2
**cons expenses increased=yes, but n.s (prior: resource reallocation effect)
reg totExp7days1 i.districtX totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 c.tmt_all , r cluster(districtX)
reg totExp7days1 i.districtX totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02, r cluster(districtX)
test tmt01 tmt02

**domestic voilence reduced=yes, but n.s
* Domestic Violence Outcomes: Threaten/Hit Partner — Table 2
reg threatenPartner1 i.districtX threatenPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 c.tmt_all, r cluster(districtX)
* Domestic Violence Outcomes: Threaten/Hit Partner — Table 2
reg threatenPartner1 i.districtX threatenPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02, r cluster(districtX)
test tmt01 tmt02

* Domestic Violence Outcomes: Threaten/Hit Partner — Table 2
reg hitPartner1 i.districtX hitPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 c.tmt_all, r cluster(districtX)
* Domestic Violence Outcomes: Threaten/Hit Partner — Table 2
reg hitPartner1 i.districtX hitPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02 , r cluster(districtX)
test tmt01 tmt02

**mental health improved=yes (prior: mental bandwith effects of inability to...)
reg logk101 i.districtX logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 c.tmt_all, r cluster(districtX)
reg logk101 i.districtX logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02, r cluster(districtX)
test tmt01 tmt02

* Binary Severe Distress Indicator (K10 > 30) — Table 2, Column 5
reg severe_distress1 i.districtX severe_distress female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 i.districtX tmt_all, r cluster(districtX)
* Binary Severe Distress Indicator (K10 > 30) — Table 2, Column 5
reg severe_distress1 i.districtX severe_distress female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 i.districtX tmt01 tmt02, r cluster(districtX)
test tmt01 tmt02

reg tiredCOVID1 i.districtX tiredCOVID female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt_all, r cluster(districtX)
reg tiredCOVID1 i.districtX tiredCOVID female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02, r cluster(districtX)

test tmt01 tmt02

**alternative measures of mental health - consistent
*i'm depressed(-)?
reg m11 i.districtX m110 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt_all, r cluster(districtX)
reg m11 i.districtX m110 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02, r cluster(districtX)
*i'm relaxed(+)?
reg m12 i.districtX m120 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt_all, r cluster(districtX)
reg m12 i.districtX m120 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02, r cluster(districtX)
*i'm satisfied with life, all equal(+)
reg m13 i.districtX m130 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt_all, r cluster(districtX)
reg m13 i.districtX m130 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02, r cluster(districtX)
*i'm satisfied with finance, all equal(+)
reg m14 i.districtX m140 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt_all, r cluster(districtX)
reg m14 i.districtX m140 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02, r cluster(districtX)


**movements?
**no base-outcome 
reg bd3 i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt_all, r cluster(districtX)
reg bd3 i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02, r cluster(districtX)


*balanced-yes? redo again to verify
reg needToCOVID tmt01 tmt02 if round !=3
* Table A1: Unable to Call Outcomes — COVID-specific and 7-day
reg unableToCOVID tmt01 tmt02 if round !=3
* Table A1: Unable to Call Outcomes — COVID-specific and 7-day
reg unableCall7days tmt01 tmt02 if round !=3
* Table A1: Unable to Call Outcomes — COVID-specific and 7-day
reg unableTrans7days tmt01 tmt02 if round !=3
reg totExp7days tmt01 tmt02 if round !=3
reg threatenPartner tmt01 tmt02 if round !=3
reg hitPartner tmt01 tmt02 if round !=3
reg logk10 tmt01 tmt02 if round !=3
reg severe_distress tmt01 tmt02 if round !=3
reg tiredCOVID tmt01 tmt02 if round !=3
*x-s
reg female0 tmt01 tmt02 if round !=3
reg akan0 tmt01 tmt02 if round !=3
reg married0 tmt01 tmt02 if round !=3
reg ageYrs0 tmt01 tmt02 if round !=3
reg jhs0 tmt01 tmt02 if round !=3
reg hhsize0 tmt01 tmt02 if round !=3
reg selfEmploy0 tmt01 tmt02 if round !=3
reg informal0 tmt01 tmt02 if round !=3
reg incomegrp0 tmt01 tmt02 if round !=3
**more x-s: step 0?
reg pov_likelihood tmt01 tmt02 if round !=3 
reg motherTogether tmt01 tmt02 if round !=3  
reg noReligion tmt01 tmt02 if round !=3  
reg female tmt01 tmt02 if round !=3  
reg spouseTogether tmt01 tmt02 if round !=3  
reg ageMarried tmt01 tmt02 if round !=3  
**joint tests
reg tmt01 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 pov_likelihood motherTogether noReligion female spouseTogether ageMarried //ctr vs trt1
reg tmt02 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 pov_likelihood motherTogether noReligion female spouseTogether ageMarried //ctr vs trt2
probit tmt01 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 pov_likelihood motherTogether noReligion female spouseTogether ageMarried 
probit tmt02 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 pov_likelihood motherTogether noReligion female spouseTogether ageMarried
mprobit tmt female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 pov_likelihood motherTogether noReligion female spouseTogether ageMarried




***Main Round 4 = Endline II (4-5wks)
use "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/DATA/Round_4/round4_data_13.12.dta", clear
gen round = 4

merge m:1 caseidx using "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/_Francis_/MobileCredit40GHS_376list" //(but 1:1 for 12/6)
drop _merge
gen MobileCredit40=MobileCredit
drop MobileCredit
tab MobileCredit40 
merge m:m caseidx using "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/_Francis_/MobileCredit20GHS_371list_Wave1"  //(but 1:m for 12/6)
drop _merge
gen MobileCredit20=MobileCredit
drop MobileCredit
tab MobileCredit20

gen MobileCredit = MobileCredit40 
replace MobileCredit = MobileCredit20 if !missing(MobileCredit20)

drop Trt
merge m:m caseidx using "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/_Francis_/TrtList00" //bring in round 1 = base & X's
*drop _merge 

*keep if interviewn_result==1
bys caseidx: keep if _n==1

**get outcomes
gen needToCOVID1=(i9==1)
gen unableToCOVID1=(i10==1)
gen unableCall7days1 =(cr1==1)
gen volCalls = ct1a 
gen valueCalls = ct1b
gen unableTrans7days1 =(cr2==1)
gen volTransfer = ct2a 
gen valueTransfer = ct2a
gen digitborrow1=(bd1==1)
gen digitloan1=(bd2==1)

egen totExp7days1= rowtotal(c1-e5), missing
gen threatenPartner1=g1
gen hitPartner1=g1
egen k101= rowtotal(m1-m10), missing
hist k101, percent xline(30) xtitle("K10 Score") 
gen logk101 = log(k101)
gen severe_distress1 = (k101>=30) if !missing(k101)
gen tiredCOVID1=(i8==1)


browse caseidx MobileCredit Trt //construct correct treatment varaibles
gen tmt_all= !missing(MobileCredit) 
gen tmt01= (MobileCredit=="40GHS") 
gen tmt02= (MobileCredit=="20GHS") 
gen tmt_all2= (MobileCredit=="40GHS" | MobileCredit=="20GHS") 
gen tmt= 0
replace tmt=1 if tmt01==1
replace tmt=2 if tmt02==1
sum tmt_all tmt_all2 tmt01 tmt02 tmt


keep if round==4

hist k101, percent xline(30) xtitle("K10 Score") by(tmt)
tw kdensity k101 if tmt==0, xline(30, lp(dash)) xtitle("K10 Score") lp("solid") || kdensity k101  if tmt==1, lp("shortdash") || kdensity k101  if tmt==2, lp("longdash")


**y-stage 1
* Table A1: Unable to Call Outcomes — COVID-specific and 7-day
reg unableToCOVID1 i.districtX unableToCOVID female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 c.tmt_all , r cluster(districtX)
* Table A1: Unable to Call Outcomes — COVID-specific and 7-day
reg unableToCOVID1 i.districtX i.unableToCOVID female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02, r cluster(districtX)
test tmt01 tmt02

* Table A1: Unable to Call Outcomes — COVID-specific and 7-day
reg unableCall7days1 i.districtX unableCall7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 c.tmt_all , r cluster(districtX)
* Table A1: Unable to Call Outcomes — COVID-specific and 7-day
reg unableCall7days1 i.districtX unableCall7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02, r cluster(districtX)
test tmt01 tmt02

*any leaks in calls, yes for only 40ghs group
reg volCalls i.districtX ct1a0 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 c.tmt_all, r cluster(districtX)
reg volCalls i.districtX ct1a0 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02, r cluster(districtX)
reg valueCalls i.districtX ct1b0 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 c.tmt_all if valueCalls>0, r cluster(districtX)
reg valueCalls i.districtX ct1b0 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02 if valueCalls>0, r cluster(districtX)


* Table A1: Unable to Call Outcomes — COVID-specific and 7-day
reg unableTrans7days1 i.districtX unableTrans7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 c.tmt_all, r cluster(districtX)
* Table A1: Unable to Call Outcomes — COVID-specific and 7-day
reg unableTrans7days1 i.districtX unableTrans7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02, r cluster(districtX)
test tmt01 tmt02
*any leaks in transfer, no
reg volTransfer i.districtX ct2a0 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 c.tmt_all, r cluster(districtX)
reg volTransfer i.districtX ct2a0 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02, r cluster(districtX)
reg valueTransfer i.districtX ct2b0 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 c.tmt_all if valueTransfer>0, r cluster(districtX)
reg valueTransfer i.districtX ct2b0 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02 if valueTransfer>0, r cluster(districtX)

**no base-outcomes
reg digitborrow1 i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 c.tmt_all, r cluster(districtX)
reg digitborrow1 i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02, r cluster(districtX)
test tmt01 tmt02

reg digitloan1 i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 c.tmt_all , r cluster(districtX)
reg digitloan1 i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02, r cluster(districtX)
test tmt01 tmt02


*y-stage 2
**cons expenses increased=yes, but n.s (prior: resource reallocation effect)
reg totExp7days1 i.districtX totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 c.tmt_all , r cluster(districtX)
reg totExp7days1 i.districtX totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02, r cluster(districtX)
test tmt01 tmt02
**************
bys callern: reg totExp7days1 tmt01 tmt02, r 
*******************************


**domestic voilence reduced=yes, but n.s
reg threatenPartner1 i.districtX threatenPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 c.tmt_all, r cluster(districtX)
reg threatenPartner1 i.districtX threatenPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02, r cluster(districtX)
test tmt01 tmt02

reg hitPartner1 i.districtX hitPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 c.tmt_all, r cluster(districtX)
reg hitPartner1 i.districtX hitPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02 , r cluster(districtX)
test tmt01 tmt02

**mental health improved=yes (prior: mental bandwith effects of inability to...)
reg logk101 i.districtX logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 c.tmt_all, r cluster(districtX)
reg logk101 i.districtX logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0  tmt01 tmt02, r cluster(districtX)
test tmt01 tmt02

reg severe_distress1 i.districtX severe_distress female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt_all, r cluster(districtX)
reg severe_distress1 i.districtX severe_distress female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02, r cluster(districtX)
test tmt01 tmt02
********
bys callern: reg severe_distress1 tmt_all, r 
bys callern: reg severe_distress1 tmt01 tmt02, r 
*********************


reg tiredCOVID1 i.districtX tiredCOVID female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt_all, r cluster(districtX)
reg tiredCOVID1 i.districtX tiredCOVID female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02, r cluster(districtX)
test tmt01 tmt02

**alternative measures of mental health - consistent
*i'm depressed(-)?
reg m11 i.districtX m110 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt_all, r cluster(districtX)

reg m11 i.districtX m110 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02, r cluster(districtX)
test tmt01 tmt02

*i'm relaxed(+)?
reg m12 i.districtX m120 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt_all, r cluster(districtX)
reg m12 i.districtX m120 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02, r cluster(districtX)
test tmt01 tmt02
*i'm satisfied with life, all equal(+)
reg m13 i.districtX m130 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt_all, r cluster(districtX)
reg m13 i.districtX m130 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02, r cluster(districtX)
test tmt01 tmt02
*i'm satisfied with finance, all equal(+)
reg m14 i.districtX m140 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt_all, r cluster(districtX)
reg m14 i.districtX m140 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02, r cluster(districtX)
test tmt01 tmt02

**public health effects: shelter-in-home?
**NOTE: no base-outcome
gen stayhome = (p3==1) if !missing(p3)
reg stayhome i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt_all, r cluster(districtX)
reg stayhome i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02, r cluster(districtX)
test tmt01 tmt02

reg p1 i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt_all, r cluster(districtX)
reg p1 i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02, r cluster(districtX)
test tmt01 tmt02

reg p2 i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt_all, r cluster(districtX)
reg p2 i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02, r cluster(districtX)
test tmt01 tmt02

**movements?
**no base-outcome 
reg bd3 i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt_all, r cluster(districtX)
reg bd3 i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02, r cluster(districtX)



	
	

	
?
**Diff-in-Diff...12/14
**panel?
use "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/DATA/Round_1/impact10.102020Final.dta", clear
gen round =1
** add-round 2
append using "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/DATA/Round_2/impact_covid_roundFINAL.dta"
replace round=2 if missing(round)
tab round
** add-round 3
append using "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/DATA/Round_3/round3_data_21.11.dta"
replace round=3 if missing(round)
tab round
** add-round 4
append using "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/DATA/Round_4/round4_data_13.12.dta"
replace round=4 if missing(round)
tab round
*keep if interviewn_result==1

append using "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/COVID ZERO STEP/Stata/ZeroScoreData_26_09_p1.dta"
replace round=0 if missing(round)
tab round
replace date_of_interview=12092020 if (date_of_interview==1609 | date_of_interview==1709 | date_of_interview==1809 | date_of_interview==2009 | date_of_interview==2109 | date_of_interview==2209 | date_of_interview==1609202)
replace dateinterviewend = date_of_interview if round==0
*keep if (interviewn_result==1 | q2==1)
tab round

merge m:1 caseidx using "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/_Francis_/MobileCredit40GHS_376list"
drop _merge
gen MobileCredit40=MobileCredit
drop MobileCredit
tab MobileCredit40 

merge m:m caseidx using "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/_Francis_/MobileCredit20GHS_371list_Wave1"
drop _merge
gen MobileCredit20=MobileCredit
drop MobileCredit
tab MobileCredit20

gen MobileCredit = MobileCredit40 
replace MobileCredit = MobileCredit20 if !missing(MobileCredit20)


merge m:m caseidx using "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/_Francis_/TrtList0" //bring in round 1 = base
drop _merge 


tab round
*bys caseidx round: keep if _n==1
*tab round

**outcomes: stage1, stage2 (KEY: use same var naming?)
gen needToCOVID =(i9==1)
gen unableToCOVID =(i10==1)
gen unableCall7days =(cr1==1)
gen unableTrans7days =(cr2==1)
gen digitborrow =(bd1==1)
gen digitloan =(bd2==1)

egen totExp7days =rowtotal(c1-e5), missing
gen threatenPartner =g1
gen hitPartner =g1
egen k10 =rowtotal(m1-m10), missing
*hist k10, percent xline(30) xtitle("K10 Score") 
gen logk10 =log(k10)
gen severe_distress =(k10>=30)
gen tiredCOVID =(i8==1)

**regressions?
gen post =(round>2)
gen tmt_all= !missing(MobileCredit) 
gen tmt01= (MobileCredit=="40GHS") 
gen tmt02= (MobileCredit=="20GHS") 
gen tmt= 0
replace tmt=1 if tmt01==1
replace tmt=2 if tmt02==1
sum tmt_all tmt01 tmt02 tmt if round==3
sum tmt_all tmt01 tmt02 tmt if round==4


**get results?
cd "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/_Francis_/paper/results"
ls

**mitigate "unexpected" comm probl?
**I-1
reg unableCall7days i.districtX i.caseidx i.dXt i.post tmt_all c.post#c.tmt_all, r cluster(districtX)
outreg2 using "metaEffects_mitigate.doc", keep(c.post#c.tmt_all) addtext(District FE, Yes, Subject FE, Yes, Date FE, Yes) replace
reg unableCall7days i.districtX i.caseidx i.dateinterviewend i.round tmt_all c.tmt_all#i.round, r cluster(districtX)
coefplot, keep(?.round#c.tmt_all) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(30) labsize(vsmall)) level(90) ///
coeflabels(2.round#c.tmt_all="Pre: Assignment" 3.round#c.tmt_all="Post (round 1): Assignment" 4.round#c.tmt_all="Post (round 2): Assignment") title("Survey-level: unable to communicate or call in past 7 days 0-1", size(med))
gr export "meta_unableCall7days.eps", replace

reg unableCall7days i.districtX  i.caseidx i.dateinterviewend i.post tmt01 tmt02 c.post#c.tmt01 c.post#c.tmt02, r cluster(districtX)
test c.post#c.tmt01 == c.post#c.tmt02
* Cost-effectiveness: Calculating Marginal Value of Public Funds (MVPF) — Section III.3.3
outreg2 using "sepEffects_mitigate.doc", addstat("p-value (c.post#c.tmt01 = c.post#c.tmt02)", `r(p)') keep(c.post#c.tmt01 c.post#c.tmt02) addtext(District FE, Yes, Subject FE, Yes, Date FE, Yes) replace
reg unableCall7days i.districtX i.caseidx i.dateinterviewend i.round tmt01 tmt02 c.tmt01#i.round c.tmt02#i.round, r cluster(districtX)
coefplot, keep(?.round#c.tmt01 ?.round#c.tmt02) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(30) labsize(vsmall)) level(90) ///
order(2.round#c.tmt01 2.round#c.tmt02 3.round#c.tmt01 3.round#c.tmt02 4.round#c.tmt01 4.round#c.tmt02) ///
coeflabels(2.round#c.tmt01="Pre: lumpsum" 2.round#c.tmt02="Pre: Tranche" 3.round#c.tmt01="Post (round 1): lumpsum" 3.round#c.tmt02="Post (round 1): Tranche" 4.round#c.tmt01="Post (round 2): lumpsum" 4.round#c.tmt02="Post (round 2): Tranche") title("Survey-level: unable to communicate or call in past 7 days 0-1", size(med))
gr export "sep_unableCall7days.eps", replace

**I-2
reg unableToCOVID i.districtX i.caseidx i.dateinterviewend i.post tmt_all c.post#c.tmt_all, r cluster(districtX)
outreg2 using "metaEffects_mitigate.doc", keep(c.post#c.tmt_all) addtext(District FE, Yes, Subject FE, Yes, Date FE, Yes) append
reg unableToCOVID i.districtX i.caseidx i.dateinterviewend i.round tmt_all c.tmt_all#i.round, r cluster(districtX)
coefplot, keep(?.round#c.tmt_all) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(30) labsize(vsmall)) level(90) ///
coeflabels(2.round#c.tmt_all="Pre: Assignment" 3.round#c.tmt_all="Post (round 1): Assignment" 4.round#c.tmt_all="Post (round 2): Assignment") title("Survey-level: unable to communicate or call due to COVID19 0-1", size(med))
gr export "meta_unableToCOVID.eps", replace

reg unableToCOVID i.districtX  i.caseidx i.dateinterviewend i.post tmt01 tmt02 c.post#c.tmt01 c.post#c.tmt02, r cluster(districtX)
test c.post#c.tmt01 == c.post#c.tmt02
* Cost-effectiveness: Calculating Marginal Value of Public Funds (MVPF) — Section III.3.3
outreg2 using "sepEffects_mitigate.doc", addstat("p-value (c.post#c.tmt01 = c.post#c.tmt02)", `r(p)') keep(c.post#c.tmt01 c.post#c.tmt02) addtext(District FE, Yes, Subject FE, Yes, Date FE, Yes) append
reg unableToCOVID i.districtX i.caseidx i.dateinterviewend i.round tmt01 tmt02 c.tmt01#i.round c.tmt02#i.round, r cluster(districtX)
coefplot, keep(?.round#c.tmt01 ?.round#c.tmt02) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(30) labsize(vsmall)) level(90) ///
order(2.round#c.tmt01 2.round#c.tmt02 3.round#c.tmt01 3.round#c.tmt02 4.round#c.tmt01 4.round#c.tmt02) ///
coeflabels(2.round#c.tmt01="Pre: lumpsum" 2.round#c.tmt02="Pre: Tranche" 3.round#c.tmt01="Post (round 1): lumpsum" 3.round#c.tmt02="Post (round 1): Tranche" 4.round#c.tmt01="Post (round 2): lumpsum" 4.round#c.tmt02="Post (round 2): Tranche") title("Survey-level: unable to communicate or call due to COVID19 0-1", size(med))
gr export "sep_unableToCOVID.eps", replace

**I-3
reg digitborrow i.districtX i.caseidx i.dateinterviewend i.post tmt_all c.post#c.tmt_all, r cluster(districtX)
outreg2 using "metaEffects_mitigate.doc", keep(c.post#c.tmt_all) addtext(District FE, Yes, Subject FE, Yes, Date FE, Yes) append
reg digitborrow i.districtX i.caseidx i.dateinterviewend i.round tmt_all c.tmt_all#i.round, r cluster(districtX)
coefplot, keep(?.round#c.tmt_all) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(30) labsize(vsmall)) level(90) ///
coeflabels(2.round#c.tmt_all="Pre: Assignment" 3.round#c.tmt_all="Post (round 1): Assignment" 4.round#c.tmt_all="Post (round 2): Assignment") title("Survey-level: seek or borrow mobile credit 0-1")
gr export "meta_digitborrow.eps", replace

reg digitborrow i.districtX  i.caseidx i.dateinterviewend i.post tmt01 tmt02 c.post#c.tmt01 c.post#c.tmt02, r cluster(districtX)
test c.post#c.tmt01 == c.post#c.tmt02
* Cost-effectiveness: Calculating Marginal Value of Public Funds (MVPF) — Section III.3.3
outreg2 using "sepEffects_mitigate.doc", addstat("p-value (c.post#c.tmt01 = c.post#c.tmt02)", `r(p)') keep(c.post#c.tmt01 c.post#c.tmt02) addtext(District FE, Yes, Subject FE, Yes, Date FE, Yes) append
reg digitborrow i.districtX i.caseidx i.dateinterviewend i.round tmt01 tmt02 c.tmt01#i.round c.tmt02#i.round, r cluster(districtX)
coefplot, keep(?.round#c.tmt01 ?.round#c.tmt02) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(30) labsize(vsmall)) level(90) ///
order(2.round#c.tmt01 2.round#c.tmt02 3.round#c.tmt01 3.round#c.tmt02 4.round#c.tmt01 4.round#c.tmt02) ///
coeflabels(2.round#c.tmt01="Pre: lumpsum" 2.round#c.tmt02="Pre: Tranche" 3.round#c.tmt01="Post (round 1): lumpsum" 3.round#c.tmt02="Post (round 1): Tranche" 4.round#c.tmt01="Post (round 2): lumpsum" 4.round#c.tmt02="Post (round 2): Tranche") title("Survey-level: seek or borrow mobile credit 0-1")
gr export "sep_digitborrow.eps", replace

**I-4
reg digitloan i.districtX i.caseidx i.dateinterviewend i.post tmt_all c.post#c.tmt_all, r cluster(districtX)
outreg2 using "metaEffects_mitigate.doc", keep(c.post#c.tmt_all) addtext(District FE, Yes, Subject FE, Yes, Date FE, Yes) append
reg digitloan i.districtX i.caseidx i.dateinterviewend i.round tmt_all c.tmt_all#i.round, r cluster(districtX)
coefplot, keep(?.round#c.tmt_all) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(30) labsize(vsmall)) level(90) ///
coeflabels(2.round#c.tmt_all="Pre: Assignment" 3.round#c.tmt_all="Post (round 1): Assignment" 4.round#c.tmt_all="Post (round 2): Assignment") title("Survey-level: seek digital loan 0-1")
gr export "meta_digitloan.eps", replace

reg digitloan i.districtX  i.caseidx i.dateinterviewend i.post tmt01 tmt02 c.post#c.tmt01 c.post#c.tmt02, r cluster(districtX)
test c.post#c.tmt01 == c.post#c.tmt02
* Cost-effectiveness: Calculating Marginal Value of Public Funds (MVPF) — Section III.3.3
outreg2 using "sepEffects_mitigate.doc", addstat("p-value (c.post#c.tmt01 = c.post#c.tmt02)", `r(p)') keep(c.post#c.tmt01 c.post#c.tmt02) addtext(District FE, Yes, Subject FE, Yes, Date FE, Yes) append
reg digitloan i.districtX i.caseidx i.dateinterviewend i.round tmt01 tmt02 c.tmt01#i.round c.tmt02#i.round, r cluster(districtX)
coefplot, keep(?.round#c.tmt01 ?.round#c.tmt02) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(30) labsize(vsmall)) level(90) ///
order(2.round#c.tmt01 2.round#c.tmt02 3.round#c.tmt01 3.round#c.tmt02 4.round#c.tmt01 4.round#c.tmt02) ///
coeflabels(2.round#c.tmt01="Pre: lumpsum" 2.round#c.tmt02="Pre: Tranche" 3.round#c.tmt01="Post (round 1): lumpsum" 3.round#c.tmt02="Post (round 1): Tranche" 4.round#c.tmt01="Post (round 2): lumpsum" 4.round#c.tmt02="Post (round 2): Tranche") title("Survey-level: seek digital loan 0-1")
gr export "sep_digitloan.eps", replace



 
**expenditure Shifts [resource reallocation effect]?
reg totExp7days i.districtX i.caseidx i.dateinterviewend i.post tmt_all c.post#c.tmt_all, r cluster(districtX)

outreg2 using "metaEffects_wellbeing.doc", keep(c.post#c.tmt_all) addtext(District FE, Yes, Subject FE, Yes, Date FE, Yes) replace
reg totExp7days i.districtX i.caseidx i.dateinterviewend i.round tmt_all c.tmt_all#i.round, r cluster(districtX)
coefplot, keep(?.round#c.tmt_all) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(30) labsize(vsmall)) level(90) ///
coeflabels(2.round#c.tmt_all="Pre: Assignment" 3.round#c.tmt_all="Post (round 1): Assignment" 4.round#c.tmt_all="Post (round 2): Assignment") title("Survey-level: consumption expenses (GHS)")
gr export "meta_totExp7days.eps", replace

reg totExp7days i.districtX i.caseidx i.dateinterviewend i.post tmt01 tmt02 c.post#c.tmt01 c.post#c.tmt02, r cluster(districtX)
test c.post#c.tmt01 == c.post#c.tmt02
outreg2 using "sepEffects_wellbeing.doc", addstat("p-value (c.post#c.tmt01 = c.post#c.tmt02)", `r(p)') keep(c.post#c.tmt01 c.post#c.tmt02) addtext(District FE, Yes, Subject FE, Yes, Date FE, Yes) replace
reg totExp7days i.districtX i.caseidx i.dateinterviewend i.round tmt01 tmt02 c.tmt01#i.round c.tmt02#i.round, r cluster(districtX)
coefplot, keep(?.round#c.tmt01 ?.round#c.tmt02) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(30) labsize(vsmall)) level(90) ///
order(2.round#c.tmt01 2.round#c.tmt02 3.round#c.tmt01 3.round#c.tmt02 4.round#c.tmt01 4.round#c.tmt02) ///
coeflabels(2.round#c.tmt01="Pre: lumpsum" 2.round#c.tmt02="Pre: Tranche" 3.round#c.tmt01="Post (round 1): lumpsum" 3.round#c.tmt02="Post (round 1): Tranche" 4.round#c.tmt01="Post (round 2): lumpsum" 4.round#c.tmt02="Post (round 2): Tranche") title("Survey-level: consumption expenses (GHS)")
gr export "sep_totExp7days.eps", replace



**dV
reg threatenPartner i.districtX i.caseidx i.dateinterviewend i.post tmt_all c.post#c.tmt_all, r cluster(districtX)
outreg2 using "metaEffects_wellbeing.doc", keep(c.post#c.tmt_all) addtext(District FE, Yes, Subject FE, Yes, Date FE, Yes) append
reg threatenPartner i.districtX i.caseidx i.dateinterviewend i.round tmt_all c.tmt_all#i.round, r cluster(districtX)
coefplot, keep(?.round#c.tmt_all) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(30) labsize(vsmall)) level(90) ///
coeflabels(2.round#c.tmt_all="Pre: Assignment" 3.round#c.tmt_all="Post (round 1): Assignment" 4.round#c.tmt_all="Post (round 2): Assignment") title("Survey-level: threatened partner 0-1")
gr export "meta_threatenPartner.eps", replace

reg threatenPartner i.districtX i.caseidx i.dateinterviewend i.post tmt01 tmt02 c.post#c.tmt01 c.post#c.tmt02, r cluster(districtX)
test c.post#c.tmt01 == c.post#c.tmt02
outreg2 using "sepEffects_wellbeing.doc", addstat("p-value (c.post#c.tmt01 = c.post#c.tmt02)", `r(p)') keep(c.post#c.tmt01 c.post#c.tmt02) addtext(District FE, Yes, Subject FE, Yes, Date FE, Yes) append
reg threatenPartner i.districtX i.caseidx i.dateinterviewend i.round tmt01 tmt02 c.tmt01#i.round c.tmt02#i.round, r cluster(districtX)
coefplot, keep(?.round#c.tmt01 ?.round#c.tmt02) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(30) labsize(vsmall)) level(90) ///
order(2.round#c.tmt01 2.round#c.tmt02 3.round#c.tmt01 3.round#c.tmt02 4.round#c.tmt01 4.round#c.tmt02) ///
coeflabels(2.round#c.tmt01="Pre: lumpsum" 2.round#c.tmt02="Pre: Tranche" 3.round#c.tmt01="Post (round 1): lumpsum" 3.round#c.tmt02="Post (round 1): Tranche" 4.round#c.tmt01="Post (round 2): lumpsum" 4.round#c.tmt02="Post (round 2): Tranche") title("Survey-level: threatened partner 0-1")
gr export "sep_threatenPartner.eps", replace


reg hitPartner i.districtX i.caseidx i.dateinterviewend i.post tmt_all c.post#c.tmt_all, r cluster(districtX)
outreg2 using "metaEffects_wellbeing.doc", keep(c.post#c.tmt_all) addtext(District FE, Yes, Subject FE, Yes, Date FE, Yes) append
reg hitPartner i.districtX i.caseidx i.dateinterviewend i.round tmt_all c.tmt_all#i.round, r cluster(districtX)
coefplot, keep(?.round#c.tmt_all) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(30) labsize(vsmall)) level(90) ///
coeflabels(2.round#c.tmt_all="Pre: Assignment" 3.round#c.tmt_all="Post (round 1): Assignment" 4.round#c.tmt_all="Post (round 2): Assignment") title("Survey-level: hit partner 0-1")
gr export "meta_hitPartner.eps", replace

reg hitPartner i.districtX i.caseidx i.dateinterviewend i.post tmt01 tmt02 c.post#c.tmt01 c.post#c.tmt02, r cluster(districtX)
test c.post#c.tmt01 == c.post#c.tmt02
outreg2 using "sepEffects_wellbeing.doc", addstat("p-value (c.post#c.tmt01 = c.post#c.tmt02)", `r(p)') keep(c.post#c.tmt01 c.post#c.tmt02) addtext(District FE, Yes, Subject FE, Yes, Date FE, Yes) append
reg hitPartner i.districtX i.caseidx i.dateinterviewend i.round tmt01 tmt02 c.tmt01#i.round c.tmt02#i.round, r cluster(districtX)
coefplot, keep(?.round#c.tmt01 ?.round#c.tmt02) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(30) labsize(vsmall)) level(90) ///
order(2.round#c.tmt01 2.round#c.tmt02 3.round#c.tmt01 3.round#c.tmt02 4.round#c.tmt01 4.round#c.tmt02) ///
coeflabels(2.round#c.tmt01="Pre: lumpsum" 2.round#c.tmt02="Pre: Tranche" 3.round#c.tmt01="Post (round 1): lumpsum" 3.round#c.tmt02="Post (round 1): Tranche" 4.round#c.tmt01="Post (round 2): lumpsum" 4.round#c.tmt02="Post (round 2): Tranche") title("Survey-level: hit partner 0-1")
gr export "sep_hitPartner.eps", replace


**mH
* Final Mental Health Analysis or Robustness — K10 / Severe Distress
reg logk10 i.districtX i.caseidx i.dateinterviewend i.post tmt_all c.post#c.tmt_all, r cluster(districtX)
outreg2 using "metaEffects_wellbeing.doc", keep(c.post#c.tmt_all) addtext(District FE, Yes, Subject FE, Yes, Date FE, Yes) append
* Final Mental Health Analysis or Robustness — K10 / Severe Distress
reg logk10 i.districtX i.caseidx i.dateinterviewend i.round tmt_all c.tmt_all#i.round, r cluster(districtX)
coefplot, keep(?.round#c.tmt_all) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(30) labsize(vsmall)) level(90) ///
coeflabels(2.round#c.tmt_all="Pre: Assignment" 3.round#c.tmt_all="Post (round 1): Assignment" 4.round#c.tmt_all="Post (round 2): Assignment") title("Survey-level: logK10")
gr export "meta_logk10.eps", replace

* Final Mental Health Analysis or Robustness — K10 / Severe Distress
reg logk10 i.districtX i.caseidx i.dateinterviewend i.post tmt01 tmt02 c.post#c.tmt01 c.post#c.tmt02, r cluster(districtX)
test c.post#c.tmt01 == c.post#c.tmt02
outreg2 using "sepEffects_wellbeing.doc", addstat("p-value (c.post#c.tmt01 = c.post#c.tmt02)", `r(p)') keep(c.post#c.tmt01 c.post#c.tmt02) addtext(District FE, Yes, Subject FE, Yes, Date FE, Yes) append
* Final Mental Health Analysis or Robustness — K10 / Severe Distress
reg logk10 i.districtX i.caseidx i.dateinterviewend i.round tmt01 tmt02 c.tmt01#i.round c.tmt02#i.round, r cluster(districtX)
coefplot, keep(?.round#c.tmt01 ?.round#c.tmt02) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(30) labsize(vsmall)) level(90) ///
order(2.round#c.tmt01 2.round#c.tmt02 3.round#c.tmt01 3.round#c.tmt02 4.round#c.tmt01 4.round#c.tmt02) ///
coeflabels(2.round#c.tmt01="Pre: lumpsum" 2.round#c.tmt02="Pre: Tranche" 3.round#c.tmt01="Post (round 1): lumpsum" 3.round#c.tmt02="Post (round 1): Tranche" 4.round#c.tmt01="Post (round 2): lumpsum" 4.round#c.tmt02="Post (round 2): Tranche") title("Survey-level: logK10")
gr export "sep_logk10.eps", replace

sum severe_distress if round==2
* Final Mental Health Analysis or Robustness — K10 / Severe Distress
reg severe_distress i.districtX i.caseidx i.dateinterviewend i.post tmt_all c.post#c.tmt_all, r cluster(districtX)
outreg2 using "metaEffects_wellbeing.doc", keep(c.post#c.tmt_all) addtext(District FE, Yes, Subject FE, Yes, Date FE, Yes) append
* Final Mental Health Analysis or Robustness — K10 / Severe Distress
reg severe_distress i.districtX i.caseidx i.dateinterviewend i.round tmt_all c.tmt_all#i.round, r cluster(districtX)
coefplot, keep(?.round#c.tmt_all) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(30) labsize(vsmall)) level(90) ///
coeflabels(2.round#c.tmt_all="Pre: Assignment" 3.round#c.tmt_all="Post (round 1): Assignment" 4.round#c.tmt_all="Post (round 2): Assignment") title("Survey-level: severe distress 0-1")
gr export "meta_severe_distress.eps", replace

* Final Mental Health Analysis or Robustness — K10 / Severe Distress
reg severe_distress i.districtX i.caseidx i.dateinterviewend i.post tmt01 tmt02 c.post#c.tmt01 c.post#c.tmt02, r cluster(districtX)
test c.post#c.tmt01 == c.post#c.tmt02
outreg2 using "sepEffects_wellbeing.doc", addstat("p-value (c.post#c.tmt01 = c.post#c.tmt02)", `r(p)') keep(c.post#c.tmt01 c.post#c.tmt02) addtext(District FE, Yes, Subject FE, Yes, Date FE, Yes) append
* Final Mental Health Analysis or Robustness — K10 / Severe Distress
reg severe_distress i.districtX i.caseidx i.dateinterviewend i.round tmt01 tmt02 c.tmt01#i.round c.tmt02#i.round, r cluster(districtX)
coefplot, keep(?.round#c.tmt01 ?.round#c.tmt02) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(30) labsize(vsmall)) level(90) ///
order(2.round#c.tmt01 2.round#c.tmt02 3.round#c.tmt01 3.round#c.tmt02 4.round#c.tmt01 4.round#c.tmt02) ///
coeflabels(2.round#c.tmt01="Pre: lumpsum" 2.round#c.tmt02="Pre: Tranche" 3.round#c.tmt01="Post (round 1): lumpsum" 3.round#c.tmt02="Post (round 1): Tranche" 4.round#c.tmt01="Post (round 2): lumpsum" 4.round#c.tmt02="Post (round 2): Tranche") title("Survey-level: severe distress 0-1")
gr export "sep_severe_distress.eps", replace


?
sum  pov_likelihood, d
gen highPov=(pov_likelihood>19.6)
* Final Mental Health Analysis or Robustness — K10 / Severe Distress
reg severe_distress i.districtX i.caseidx i.dateinterviewend i.post tmt_all c.post#c.tmt_all#c.highPov, r cluster(districtX)
* Final Mental Health Analysis or Robustness — K10 / Severe Distress
reg severe_distress i.districtX i.caseidx i.dateinterviewend i.post tmt_all c.post#c.tmt_all#c.pov_likelihood, r cluster(districtX)



**panel analysis
use "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/DATA/Round_3/round3_data_16.11.dta", clear
gen round = 3
merge 1:1 caseidx using "MobileCredit40GHS_376list"
drop _merge
gen MobileCredit40=MobileCredit
drop MobileCredit
tab MobileCredit40 
merge 1:m caseidx using "MobileCredit20GHS_371list_Wave1"
drop _merge
gen MobileCredit20=MobileCredit
drop MobileCredit
tab MobileCredit20

gen MobileCredit = MobileCredit40 
replace MobileCredit = MobileCredit20 if !missing(MobileCredit20)


append using "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/DATA/Round_1/impact10.102020Final.dta"
replace round = 1 if missing(round)
tab round
append using "/Users/fannan/Dropbox/research_projs/fraud-monitors/_rGroup-finfraud/IMPACT_COVID19 DATA/DATA/Round_2/impact_covid_roundFINAL.dta"
replace round = 2 if missing(round)
tab round

drop Trt
merge m:m caseidx using "TrtList0" //bring in round 1 = base
drop _merge 
*keep if interviewn_result==1
bys caseidx round: keep if _n==1

**outcomes: stage1, stage2
gen needToCOVID =(i9==1)
gen unableToCOVID =(i10==1)
gen unableCall7days =(cr1==1)
gen unableTrans7days =(cr2==1)
gen digitborrow =(bd1==1)
gen digitloan =(bd2==1)

egen totExp7days =rowtotal(c1-e5), missing
gen threatenPartner =g1
gen hitPartner =g1
egen k10 =rowtotal(m1-m10), missing
*hist k10, percent xline(30) xtitle("K10 Score") 
gen logk10 =log(k10)
gen severe_distress =(k10>=30)
gen tiredCOVID =(i8==1)

**regressions?
gen post =(round>2)
gen tmt_all= !missing(MobileCredit) 
gen tmt01= (MobileCredit=="40GHS") 
gen tmt02= (MobileCredit=="20GHS") 
gen tmt= 0
replace tmt=1 if tmt01==1
replace tmt=2 if tmt02==1
sum tmt_all tmt01 tmt02 tmt


*keep if round==1 | round==3
reg unableToCOVID i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 i.post i.tmt_all c.post#c.tmt_all, r cluster(districtX)
reg unableToCOVID i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 i.post tmt01 tmt02 c.post#c.tmt01 c.post#c.tmt02, r cluster(districtX)

reg unableCall7days i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 i.post i.tmt_all c.post#c.tmt_all, r cluster(districtX)
reg unableCall7days i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 i.post tmt01 tmt02 c.post#c.tmt01 c.post#c.tmt02, r cluster(districtX)

reg unableTrans7days i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 i.post i.tmt_all c.post#c.tmt_all, r cluster(districtX)
reg unableTrans7days i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 i.post tmt01 tmt02 c.post#c.tmt01 c.post#c.tmt02, r cluster(districtX)

reg digitborrow i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 i.post i.tmt_all c.post#c.tmt_all, r cluster(districtX)
reg digitborrow i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 i.post tmt01 tmt02 c.post#c.tmt01 c.post#c.tmt02, r cluster(districtX)

reg digitloan i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 i.post i.tmt_all c.post#c.tmt_all, r cluster(districtX)
reg digitloan i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 i.post tmt01 tmt02 c.post#c.tmt01 c.post#c.tmt02, r cluster(districtX)



reg totExp7days i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 i.post i.tmt_all c.post#c.tmt_all, r cluster(districtX)
reg totExp7days i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 i.post tmt01 tmt02 c.post#c.tmt01 c.post#c.tmt02, r cluster(districtX)

reg threatenPartner i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 i.post i.tmt_all c.post#c.tmt_all, r cluster(districtX)
reg threatenPartner i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 i.post tmt01 tmt02 c.post#c.tmt01 c.post#c.tmt02, r cluster(districtX)

reg hitPartner i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 i.post i.tmt_all c.post#c.tmt_all, r cluster(districtX)
reg hitPartner i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 i.post tmt01 tmt02 c.post#c.tmt01 c.post#c.tmt02, r cluster(districtX)

* Final Mental Health Analysis or Robustness — K10 / Severe Distress
reg logk10 i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 i.post i.tmt_all c.post#c.tmt_all, r cluster(districtX)
* Final Mental Health Analysis or Robustness — K10 / Severe Distress
reg logk10 i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 i.post tmt01 tmt02 c.post#c.tmt01 c.post#c.tmt02, r cluster(districtX)

* Final Mental Health Analysis or Robustness — K10 / Severe Distress
reg severe_distress i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 i.post i.tmt_all c.post#c.tmt_all, r cluster(districtX)
* Final Mental Health Analysis or Robustness — K10 / Severe Distress
reg severe_distress i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 i.post tmt01 tmt02 c.post#c.tmt01 c.post#c.tmt02, r cluster(districtX)

reg tiredCOVID i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 i.post i.tmt_all c.post#c.tmt_all, r cluster(districtX)
reg tiredCOVID i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 i.post tmt01 tmt02 c.post#c.tmt01 c.post#c.tmt02, r cluster(districtX)









