**************
***********************************
clear all
use "${replication_dir}/Data/02_intermediate/End1_MobileCredit_attrition", clear
cf _all using "/Users/yazenkashlan/Dropbox (Personal)/covid19 paper/IMPACT_COVID19 DATA/_Francis_Impacts/End1_MobileCredit_attrition.dta" , verbose
use "/Users/yazenkashlan/Dropbox (Personal)/covid19 paper/IMPACT_COVID19 DATA/_Francis_Impacts/End1_MobileCredit_attrition.dta", clear
gen end=1
gen round=3
append using "${replication_dir}/Data/02_intermediate/End2_MobileCredit_attrition"
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
merge m:m caseidx using "${replication_dir}/Data/02_intermediate/TrtList00.dta" //bring in round 1 = base	
bys caseidx end: keep if _n==1  

drop _merge


**main outcomes
gen unableCall7days1 =(cr1==1) if !missing(cr1)

pdslasso unableCall7days1 tmt01 tmt02 (i.districtX i.dateinterviewend unableCall7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum unableCall7days1 if tmt_all==0
test tmt01 tmt02
outreg2 using "${replication_dir}/Output/Tables/table_3.tex", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, XX, p-value-jointtest, `r(p)') replace




use "${replication_dir}/Data/01_raw/round3_data_21.11.dta", clear
cf _all using "/Users/yazenkashlan/Dropbox (Personal)/covid19 paper/IMPACT_COVID19 DATA/DATA/Round_3/round3_data_21.11.dta"


use "${replication_dir}/Data/02_intermediate/MobileCredit_attrition", clear
cf _all using "/Users/yazenkashlan/Dropbox (Personal)/covid19 paper/IMPACT_COVID19 DATA/_Francis_Impacts/MobileCredit_attrition" //just 1 repeat in Aftrition file so do m:m
// here

use "${replication_dir}/Data/01_raw/impact10.102020Final.dta", clear
cf _all using "/Users/yazenkashlan/Dropbox (Personal)/covid19 paper/IMPACT_COVID19 DATA/DATA/Round_1/impact10.102020Final.dta"


use "/Users/yazenkashlan/Dropbox (Personal)/covid19 paper/IMPACT_COVID19 DATA/_Francis_Impacts/MobileCredit40GHS_376list", clear
sort caseidx
tempfile compares
save	`compares'
use "${replication_dir}/Data/02_intermediate/MobileCredit40GHS_376list.dta", clear
sort caseidx
cf _all using `compares'


use "/Users/yazenkashlan/Dropbox (Personal)/covid19 paper/IMPACT_COVID19 DATA/_Francis_Impacts/TrtList00", clear
sort caseidx
tempfile compares
save	`compares'
use "${replication_dir}/Data/02_intermediate/TrtList00.dta", clear
sort caseidx
cf _all using `compares'

** copied this
use "${sample_dir}/select1396Final_sample.dta", clear
cf _all using "${replication_dir}/Data/01_raw/select1396Final_sample.dta"


CAN I DEFINITELY NOT REPLICATE THE RANDOMIZATION?
