/*
Rounds 3 and 4
*/



 
***Main Round 3 = Endline I (1-2wks)
use "${data_dir}/DATA/Round_3/round3_data_21.11.dta", clear
gen round = 3
merge 1:1 caseidx using "${replication_dir}/Data/02_intermediate/MobileCredit40GHS_376list"
drop _merge
gen MobileCredit40=MobileCredit
drop MobileCredit
tab MobileCredit40 
merge 1:m caseidx using "${replication_dir}/Data/02_intermediate/MobileCredit20GHS_371list_Wave1"
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
merge m:m caseidx using "${replication_dir}/Data/02_intermediate/TrtList00" //bring in round 1 = base & X's
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


// browse caseidx MobileCredit Trt //construct correct treatment varaibles
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
reg threatenPartner1 i.districtX threatenPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 c.tmt_all, r cluster(districtX)
reg threatenPartner1 i.districtX threatenPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02, r cluster(districtX)
test tmt01 tmt02

reg hitPartner1 i.districtX hitPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 c.tmt_all, r cluster(districtX)
reg hitPartner1 i.districtX hitPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02 , r cluster(districtX)
test tmt01 tmt02

**mental health improved=yes (prior: mental bandwith effects of inability to...)
reg logk101 i.districtX logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 c.tmt_all, r cluster(districtX)
reg logk101 i.districtX logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 tmt01 tmt02, r cluster(districtX)
test tmt01 tmt02

reg severe_distress1 i.districtX severe_distress female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 i.districtX tmt_all, r cluster(districtX)
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
reg unableToCOVID tmt01 tmt02 if round !=3
reg unableCall7days tmt01 tmt02 if round !=3
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
use "${data_dir}/DATA/Round_4/round4_data_13.12.dta", clear
gen round = 4

merge m:1 caseidx using "${replication_dir}/Data/02_intermediate/MobileCredit40GHS_376list" //(but 1:1 for 12/6)
drop _merge
gen MobileCredit40=MobileCredit
drop MobileCredit
tab MobileCredit40 
merge m:m caseidx using "${replication_dir}/Data/02_intermediate//MobileCredit20GHS_371list_Wave1"  //(but 1:m for 12/6)
drop _merge
gen MobileCredit20=MobileCredit
drop MobileCredit
tab MobileCredit20

gen MobileCredit = MobileCredit40 
replace MobileCredit = MobileCredit20 if !missing(MobileCredit20)

drop Trt
merge m:m caseidx using "${replication_dir}/Data/02_intermediate/TrtList00" //bring in round 1 = base & X's
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


// browse caseidx MobileCredit Trt //construct correct treatment varaibles
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



	
	

	

**Diff-in-Diff...12/14
**panel?
use "${data_dir}/DATA/Round_1/impact10.102020Final.dta", clear
gen round =1
** add-round 2
append using "${data_dir}/DATA/Round_2/impact_covid_roundFINAL.dta"
replace round=2 if missing(round)
tab round
** add-round 3
append using "${data_dir}/DATA/Round_3/round3_data_21.11.dta"
replace round=3 if missing(round)
tab round
** add-round 4
append using "${data_dir}/DATA/Round_4/round4_data_13.12.dta"
replace round=4 if missing(round)
tab round
*keep if interviewn_result==1

append using "${sample_dir}/ZeroScoreData_26_09_p1.dta"
replace round=0 if missing(round)
tab round
replace date_of_interview=12092020 if (date_of_interview==1609 | date_of_interview==1709 | date_of_interview==1809 | date_of_interview==2009 | date_of_interview==2109 | date_of_interview==2209 | date_of_interview==1609202)
replace dateinterviewend = date_of_interview if round==0
*keep if (interviewn_result==1 | q2==1)
tab round

merge m:1 caseidx using "${replication_dir}/Data/02_intermediate//MobileCredit40GHS_376list"
drop _merge
gen MobileCredit40=MobileCredit
drop MobileCredit
tab MobileCredit40 

merge m:m caseidx using "${replication_dir}/Data/02_intermediate//MobileCredit20GHS_371list_Wave1"
drop _merge
gen MobileCredit20=MobileCredit
drop MobileCredit
tab MobileCredit20

gen MobileCredit = MobileCredit40 
replace MobileCredit = MobileCredit20 if !missing(MobileCredit20)


merge m:m caseidx using "${replication_dir}/Data/02_intermediate//TrtList0" //bring in round 1 = base
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
cd "${replication_dir}/Output/Figures"
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
reg logk10 i.districtX i.caseidx i.dateinterviewend i.post tmt_all c.post#c.tmt_all, r cluster(districtX)
outreg2 using "metaEffects_wellbeing.doc", keep(c.post#c.tmt_all) addtext(District FE, Yes, Subject FE, Yes, Date FE, Yes) append
reg logk10 i.districtX i.caseidx i.dateinterviewend i.round tmt_all c.tmt_all#i.round, r cluster(districtX)
coefplot, keep(?.round#c.tmt_all) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(30) labsize(vsmall)) level(90) ///
coeflabels(2.round#c.tmt_all="Pre: Assignment" 3.round#c.tmt_all="Post (round 1): Assignment" 4.round#c.tmt_all="Post (round 2): Assignment") title("Survey-level: logK10")
gr export "meta_logk10.eps", replace

reg logk10 i.districtX i.caseidx i.dateinterviewend i.post tmt01 tmt02 c.post#c.tmt01 c.post#c.tmt02, r cluster(districtX)
test c.post#c.tmt01 == c.post#c.tmt02
outreg2 using "sepEffects_wellbeing.doc", addstat("p-value (c.post#c.tmt01 = c.post#c.tmt02)", `r(p)') keep(c.post#c.tmt01 c.post#c.tmt02) addtext(District FE, Yes, Subject FE, Yes, Date FE, Yes) append
reg logk10 i.districtX i.caseidx i.dateinterviewend i.round tmt01 tmt02 c.tmt01#i.round c.tmt02#i.round, r cluster(districtX)
coefplot, keep(?.round#c.tmt01 ?.round#c.tmt02) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(30) labsize(vsmall)) level(90) ///
order(2.round#c.tmt01 2.round#c.tmt02 3.round#c.tmt01 3.round#c.tmt02 4.round#c.tmt01 4.round#c.tmt02) ///
coeflabels(2.round#c.tmt01="Pre: lumpsum" 2.round#c.tmt02="Pre: Tranche" 3.round#c.tmt01="Post (round 1): lumpsum" 3.round#c.tmt02="Post (round 1): Tranche" 4.round#c.tmt01="Post (round 2): lumpsum" 4.round#c.tmt02="Post (round 2): Tranche") title("Survey-level: logK10")
gr export "sep_logk10.eps", replace

sum severe_distress if round==2
reg severe_distress i.districtX i.caseidx i.dateinterviewend i.post tmt_all c.post#c.tmt_all, r cluster(districtX)
outreg2 using "metaEffects_wellbeing.doc", keep(c.post#c.tmt_all) addtext(District FE, Yes, Subject FE, Yes, Date FE, Yes) append
reg severe_distress i.districtX i.caseidx i.dateinterviewend i.round tmt_all c.tmt_all#i.round, r cluster(districtX)
coefplot, keep(?.round#c.tmt_all) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(30) labsize(vsmall)) level(90) ///
coeflabels(2.round#c.tmt_all="Pre: Assignment" 3.round#c.tmt_all="Post (round 1): Assignment" 4.round#c.tmt_all="Post (round 2): Assignment") title("Survey-level: severe distress 0-1")
gr export "meta_severe_distress.eps", replace

reg severe_distress i.districtX i.caseidx i.dateinterviewend i.post tmt01 tmt02 c.post#c.tmt01 c.post#c.tmt02, r cluster(districtX)
test c.post#c.tmt01 == c.post#c.tmt02
outreg2 using "sepEffects_wellbeing.doc", addstat("p-value (c.post#c.tmt01 = c.post#c.tmt02)", `r(p)') keep(c.post#c.tmt01 c.post#c.tmt02) addtext(District FE, Yes, Subject FE, Yes, Date FE, Yes) append
reg severe_distress i.districtX i.caseidx i.dateinterviewend i.round tmt01 tmt02 c.tmt01#i.round c.tmt02#i.round, r cluster(districtX)
coefplot, keep(?.round#c.tmt01 ?.round#c.tmt02) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(30) labsize(vsmall)) level(90) ///
order(2.round#c.tmt01 2.round#c.tmt02 3.round#c.tmt01 3.round#c.tmt02 4.round#c.tmt01 4.round#c.tmt02) ///
coeflabels(2.round#c.tmt01="Pre: lumpsum" 2.round#c.tmt02="Pre: Tranche" 3.round#c.tmt01="Post (round 1): lumpsum" 3.round#c.tmt02="Post (round 1): Tranche" 4.round#c.tmt01="Post (round 2): lumpsum" 4.round#c.tmt02="Post (round 2): Tranche") title("Survey-level: severe distress 0-1")
gr export "sep_severe_distress.eps", replace



sum  pov_likelihood, d
gen highPov=(pov_likelihood>19.6)
reg severe_distress i.districtX i.caseidx i.dateinterviewend i.post tmt_all c.post#c.tmt_all#c.highPov, r cluster(districtX)
reg severe_distress i.districtX i.caseidx i.dateinterviewend i.post tmt_all c.post#c.tmt_all#c.pov_likelihood, r cluster(districtX)



**panel analysis
use "${data_dir}/DATA/Round_3/round3_data_16.11.dta", clear
gen round = 3
merge 1:1 caseidx using "${replication_dir}/Data/02_intermediate/MobileCredit40GHS_376list.dta"
drop _merge
gen MobileCredit40=MobileCredit
drop MobileCredit
tab MobileCredit40 
merge 1:m caseidx using "${replication_dir}/Data/02_intermediate/MobileCredit20GHS_371list_Wave1.dta"
drop _merge
gen MobileCredit20=MobileCredit
drop MobileCredit
tab MobileCredit20

gen MobileCredit = MobileCredit40 
replace MobileCredit = MobileCredit20 if !missing(MobileCredit20)


append using "${data_dir}/DATA/Round_1/impact10.102020Final.dta"
replace round = 1 if missing(round)
tab round
append using "${data_dir}/DATA/Round_2/impact_covid_roundFINAL.dta"
replace round = 2 if missing(round)
tab round

drop Trt
merge m:m caseidx using "${replication_dir}/Data/02_intermediate/TrtList0" //bring in round 1 = base
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

reg logk10 i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 i.post i.tmt_all c.post#c.tmt_all, r cluster(districtX)
reg logk10 i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 i.post tmt01 tmt02 c.post#c.tmt01 c.post#c.tmt02, r cluster(districtX)

reg severe_distress i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 i.post i.tmt_all c.post#c.tmt_all, r cluster(districtX)
reg severe_distress i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 i.post tmt01 tmt02 c.post#c.tmt01 c.post#c.tmt02, r cluster(districtX)

reg tiredCOVID i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 i.post i.tmt_all c.post#c.tmt_all, r cluster(districtX)
reg tiredCOVID i.districtX female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 i.post tmt01 tmt02 c.post#c.tmt01 c.post#c.tmt02, r cluster(districtX)






