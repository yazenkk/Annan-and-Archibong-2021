/*
Table 3
*/




***********************************
clear all
use "${replication_dir}/Data/03_clean/end1_end2.dta", replace


**framework-channels?
*ssc install lassopack
sum tmt01 tmt02 tmt_all
set more off

** Table 3 column 1
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
outreg2 using "${replication_dir}/Output/Tables/table_3.doc", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') replace
// ejSepEffectsXChannels

** Table 3 column 2
pdslasso i2 tmt01 tmt02 (i.districtX i.dateinterviewend i2c female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
test tmt01 tmt02
sum i2 if tmt_all==0
outreg2 using "${replication_dir}/Output/Tables/table_3.doc", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

pdslasso i1 tmt_all (i.districtX i.dateinterviewend i1b female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum i1 if tmt_all==0
outreg2 using "${replication_dir}/Output/Tables/ejMetaEffectsXChannels.doc", keep(tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') replace
pdslasso i2 tmt_all (i.districtX i.dateinterviewend i2c female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum i2 if tmt_all==0
outreg2 using "${replication_dir}/Output/Tables/ejMetaEffectsXChannels.doc", keep(tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

*some evidence only on amt received from bus income-related activities


** Table 3 column 3
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
outreg2 using "${replication_dir}/Output/Tables/table_3.doc", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

*pooled?
pdslasso EmotSoc_Tired tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum EmotSoc_Tired if tmt_all==0
outreg2 using "${replication_dir}/Output/Tables/ejMetaEffectsXChannels.doc", keep(tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append
*very robust evidence improved soc inclusion

** Table 3 column 4
gen stayedHomelast5wks=(p3==1) if !missing(p3) //asked (@ end 2 only): Consider the last 5 weeks - are you staying home as much as possible because of the covid19 outbreak?
tab round stayedHomelast5wks
*separate?
pdslasso stayedHomelast5wks tmt01 tmt02 (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
test tmt01 tmt02
sum stayedHomelast5wks if tmt_all==0
outreg2 using "${replication_dir}/Output/Tables/table_3.doc", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

*pooled?
pdslasso stayedHomelast5wks tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum stayedHomelast5wks if tmt_all==0
outreg2 using "${replication_dir}/Output/Tables/ejMetaEffectsXChannels.doc", keep(tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append
*not surprising, trted indivs are very compliant and stayed home more, corroborative of a comm-driven social inclusion of treated indivs


** Table 3 column 5
*[rejuvination] test: what happens when combined with communication credit trts?
**//interact w COVID CASES in district?**
*separate?
pdslasso xgrowth c.tmt01##c.previouslock c.tmt02##c.previouslock (i.districtX i.dateinterviewend totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0) if (xgrowth>=-300 & xgrowth<=100), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
test c.tmt01#c.previouslock c.tmt02#c.previouslock

sum xgrowth if tmt_all==0
outreg2 using "${replication_dir}/Output/Tables/table_3.doc", keep(c.tmt01 c.tmt02#c.previouslock c.tmt02 c.tmt01#c.previouslock c.previouslock) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

*pooled?
pdslasso xgrowth c.tmt_all##c.previouslock (i.districtX i.dateinterviewend totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0) if (xgrowth>=-300 & xgrowth<=100), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum xgrowth if tmt_all==0
outreg2 using "${replication_dir}/Output/Tables/ejMetaEffectsXChannels.doc", keep(tmt_all c.tmt_all#c.previouslock c.previouslock) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append
*limited evidence (though insig +7% increase in consumption growth for tranche treatment) -- yet theoretically plausible

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


