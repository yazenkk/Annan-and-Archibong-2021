/*
Table 3
*/




***********************************
clear all
// use "${data_dir}/_Francis_Impacts/End1_MobileCredit_attrition.dta", clear
use "${replication_dir}/Data/clean/end1_end2.dta", replace


**framework-channels?
*ssc install lassopack
sum tmt01 tmt02 tmt_all
set more off

** Table 3 columns 1-2
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
outreg2 using "${replication_dir}/Output/Tables/ejSepEffectsXChannels.doc", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') replace

pdslasso i2 tmt01 tmt02 (i.districtX i.dateinterviewend i2c female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
test tmt01 tmt02
sum i2 if tmt_all==0
outreg2 using "${replication_dir}/Output/Tables/ejSepEffectsXChannels.doc", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

** not shown
*pooled?
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


** Table 3 columns 3
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
outreg2 using "${replication_dir}/Output/Tables/ejSepEffectsXChannels.doc", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

** Not shown
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
outreg2 using "${replication_dir}/Output/Tables/ejSepEffectsXChannels.doc", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

** not shown
*pooled?
pdslasso stayedHomelast5wks tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum stayedHomelast5wks if tmt_all==0
outreg2 using "${replication_dir}/Output/Tables/ejMetaEffectsXChannels.doc", keep(tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append
*not surprising, trted indivs are very compliant and stayed home more, corroborative of a comm-driven social inclusion of treated indivs



** Figure A10
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
gr export "${replication_dir}/Output/Figures/ejconsumpgrowthShock_graph.eps", replace
ksmirnov xgrowth if (xgrowth>-300 & xgrowth<100), by(previouslock) exact //p-val=0.020
*Title: "Distribution of consumption growth among individuals located outside and inside lockdown areas
*Note: Figure plots the distribution (CDF) of consumption growth per week at endline for the different subsamples (lockdown areas vs non-lockdown areas). Observations are at the individual level. Median (mean) percent consumption growth is -13% (-45%) for individuals in lockdown areas and -8% (-27%) for those in non-lockdown areas. From a Kolmogorov–Smirnov (KS) test for the equality of distributions, p-value equal 0.020 (for equality test, we trimmed the individual consumption growth outcome at the 5% level). Equality tests reject the null that the distributional pairs are equal.

** Table 3 edits
*[rejuvination] test: what happens when combined with communication credit trts?
**//interact w COVID CASES in district?**
*separate?
pdslasso xgrowth c.tmt01##c.previouslock c.tmt02##c.previouslock (i.districtX i.dateinterviewend totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0) if (xgrowth>=-300 & xgrowth<=100), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
test c.tmt01#c.previouslock c.tmt02#c.previouslock

sum xgrowth if tmt_all==0
outreg2 using "${replication_dir}/Output/Tables/ejSepEffectsXChannels.doc", keep(c.tmt01 c.tmt02#c.previouslock c.tmt02 c.tmt01#c.previouslock c.previouslock) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

not shown
*pooled?
pdslasso xgrowth c.tmt_all##c.previouslock (i.districtX i.dateinterviewend totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0) if (xgrowth>=-300 & xgrowth<=100), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum xgrowth if tmt_all==0
outreg2 using "${replication_dir}/Output/Tables/ejMetaEffectsXChannels.doc", keep(tmt_all c.tmt_all#c.previouslock c.previouslock) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append
*limited evidence (though insig +7% increase in consumption grpowth for tranche treatment) -- yet theoretically plausible

** not clear where these are 
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


