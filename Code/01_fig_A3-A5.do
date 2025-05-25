**************
***********************************
clear all
use "${data_dir}/_Francis_Impacts/End1_MobileCredit_attrition.dta", clear
gen end=1
gen round=3
append using "${data_dir}/_Francis_Impacts/End2_MobileCredit_attrition.dta"
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
merge m:m caseidx using "${data_dir}/_Francis_Impacts/TrtList00.dta" //bring in round 1 = base
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
use "${data_dir}/DATA/Round_3/round3_data_21.11.dta", clear
gen round=3
gen end = 1
tab round
keep if interviewn_result==1
** endlineII: add-round 4
append using "${data_dir}/DATA/Round_4/round4_data_14.12.dta"
'/round4_data_14.12.dta'
replace round=4 if missing(round)
replace end=2 if missing(end)
tab round
tab end
keep if interviewn_result==1

**bring in Interventions - verify
merge m:1 caseidx using "${data_dir}/_Francis_Impacts/MobileCredit40GHS_376list"
drop _merge
gen MobileCredit40=MobileCredit
drop MobileCredit
tab MobileCredit40 

merge m:m caseidx using "${data_dir}/_Francis_Impacts/MobileCredit20GHS_371list_Wave1"
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


merge m:m caseidx using "${data_dir}/_Francis_Impacts/TrtList00" //bring in round 1 = base
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
// cd "${data_dir}/_Francis_Impacts/paper/results"
cd "${replication_dir}/Output/Figures"


ls

distplot number_of_calls //no of time called b/4 picking up
hist number_of_calls, gap(10) percent xtitle("Number of phone call times before answering survey") lcolor(none) fcolor(gray) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid)
gr export "subjects_calltimeS.eps", replace

**K10 and cons
*low (scores of 10-15, indicating little or no psychological distress)
*moderate (scores of 16-21)
*high (scores of 22-29)
*Very high/ severe (scores of 30-50)
gen k10 = exp(logk10)
hist k10 if end==1, percent xline(30, lp(dash)) xtitle("K10 score at baseline") lcolor(none) fcolor(gray) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid)
gr export "subjects_k10_base.eps", replace
sum severe_distress if end==1 // 11.5% rate of severe distress

hist totExp7days if end==1, percent xline(500, lp(dash)) xtitle("Total consumption expenditure - weekly (GHS)") lcolor(none) fcolor(gray) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid)
gr export "subjects_totconsump_base.eps", replace
gen poor_consump = totExp7days<=500 if end==1 
sum poor_consump if end==1 // 81.7% rate of poor consumption
