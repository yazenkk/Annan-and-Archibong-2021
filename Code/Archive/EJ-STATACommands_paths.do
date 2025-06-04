

	
	
use "${replication_dir}/Data/03_clean/end1_end2.dta", replace	


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
reg unableCall7days tmt01 tmt02 if round==3, r cluster(districtX)
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
reg logk10 tmt01 tmt02 if round==3, r cluster(districtX)
reg severe_distress tmt01 tmt02 if round==3, r cluster(districtX)
reg tiredCOVID tmt01 tmt02 if round==3, r cluster(districtX)

reg m110 tmt01 tmt02 if round==3, r cluster(districtX) //depressed? 1-5
reg m120 tmt01 tmt02 if round==3, r cluster(districtX) //relaxed? 1-5
reg m130 tmt01 tmt02 if round==3, r cluster(districtX) //life-satisfied: 1-5 scale
reg m140 tmt01 tmt02 if round==3, r cluster(districtX) //finance-satisfied:  1-5 scale



**bring in Wave 2 (for a few other controls but not in Wave 1?)
use "${data_dir}/DATA/Round_2/impact_covid_roundFINAL.dta", clear
gen round=2
tab round
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
merge m:m caseidx using "${data_dir}/_Francis_Impacts/TrtList00" //bring in round 1 = base & X's

**balance?
gen digitborrow0=(bd1==1) if !missing(bd1) 
gen digitloan0=(bd2==1) if !missing(bd1) 
gen relocated0=(bd3==1) if !missing(bd1) 

sum digitborrow0 digitloan0 relocated0 
reg digitborrow0 tmt01 tmt02, r cluster(districtX) // borrowed airtime?
reg digitloan0 tmt01 tmt02, r cluster(districtX) // seek or borrowed digital loan?
reg relocated0 tmt01 tmt02, r cluster(districtX) // has related?


