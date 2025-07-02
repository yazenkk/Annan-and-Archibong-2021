/*
Table 7
*/




***********************************
clear all
use "${replication_dir}/Data/03_clean/end1_end2.dta", replace


gen EmotSoc_Tired = (i8==1) if !missing(i8)
sum EmotSoc_Tired

gen stayed5wks=(p3==1) if !missing(p3) //asked (@ end 2 only): Consider the last 5 weeks - are you staying home as much as possible because of the covid19 outbreak?
tab round stayed5wks

**get rwolf pvals?
gen tmt01xLock =tmt01*previouslock 
gen tmt02xLock =tmt02*previouslock
// rwolf i1 i2 EmotSoc_Tired stayed5wks xgrowth, indepvar(tmt01 tmt02) seed(124) reps(499)
// rwolf i1 i2 EmotSoc_Tired 					  xgrowth, indepvar(tmt01 tmt02 tmt01xLock tmt02xLock previouslock) seed(124) reps(499) //get for interactions
*rwolf i1 i2 EmotSoc_Tired stayed5wks xgrowth, indepvar(tmt01 tmt02 tmt01xLock tmt02xLock previouslock) seed(124)

*reply comment: 
*our conjecture was that this is related to the # of boots reps (of r=100) and it is not.
*the default # of bootstrap replications is 100 in STATA. 
*changing this to a larger number (which is usually recommended fo IV models) does not seem to change our overall inference, so ended up keeping the default

**Comment: MHT Correction - The Romano-Wolf Multiple Hypothesis Correction
local y_list5 i1 i2 EmotSoc_Tired stayed5wks xgrowth
local y_list6 i1 i2 EmotSoc_Tired xgrowth
// local t_list1 tmt_all
local t_list2 tmt01 tmt02
local t_list3 tmt01 tmt02 tmt01xLock tmt02xLock previouslock
 
foreach y_list in y_list5 y_list6 { //  
	foreach t_list in t_list2 t_list3 { // t_list1
		
		** more reps for some tests
		if ("`y_list'" == "y_list1" | "`y_list'" == "y_list2") & "`t_list'" == "t_list1" local reps_option "reps(499)"
		else local reps_option ""
		local reps_option "reps(10)"
		
		** calculate RW p-values
		rwolf ``y_list'', indepvar(``t_list'') seed(124) `reps_option'
		
		ereturn list
		** collect outcomes
		foreach y in ``y_list'' {
			foreach t in ``t_list'' {
				dis "y: `y'. t: `t'"
				if "`t_list'" == "t_list1" local rw_`y' 	= string(e(rw_`y'), 	"%15.3fc")
				if "`t_list'" == "t_list2" local rw_`y'_`t' = string(e(rw_`y'_`t'), "%15.3fc")
			}
		}
	}
}


**framework-channels?
*ssc install lassopack
sum tmt01 tmt02 tmt_all
set more off

** Table 7 column 1
*1. professional networks: cc improved business-related services? we measure: use c.wages and c.income?
sum i1 //hrs worked for income (last 7days)
sum i2 //amt received from business income-related activites (last 7days)
*separate?
pdslasso i1 tmt01 tmt02 (i.districtX i.dateinterviewend i1b female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
test tmt01 tmt02
local ttest_p = string(`r(p)', "%15.3fc")
sum i1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_7.tex", keep(tmt01 tmt02) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, ///
			Mean of dep. variable, `control_mean', ///
			p-value-jointtest, `ttest_p', ///
			p-value: Romano-Wolf Correction tmt01, `rw_i1_tmt01', ///
			p-value: Romano-Wolf Correction tmt02, `rw_i1_tmt02') ///
	replace
// ejSepEffectsXChannels

** Table 7 column 2
pdslasso i2 tmt01 tmt02 (i.districtX i.dateinterviewend i2c female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
test tmt01 tmt02
local ttest_p = string(`r(p)', "%15.3fc")
sum i2 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_7.tex", keep(tmt01 tmt02) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, ///
			Mean of dep. variable, `control_mean', ///
			p-value-jointtest, `ttest_p', ///
			p-value: Romano-Wolf Correction tmt01, `rw_i2_tmt01', ///
			p-value: Romano-Wolf Correction tmt02, `rw_i2_tmt02') ///
	append

pdslasso i1 tmt_all (i.districtX i.dateinterviewend i1b female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum i1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/ejMetaEffectsXChannels.doc", keep(tmt_all) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, /// 
	Mean of dep. variable, `r(mean)') ///
	replace
	
pdslasso i2 tmt_all (i.districtX i.dateinterviewend i2c female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum i2 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/ejMetaEffectsXChannels.doc", keep(tmt_all) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, ///
			Mean of dep. variable, `r(mean)') ///
	append

*some evidence only on amt received from bus income-related activities


** Table 7 column 3
*2. social networks #1-inclusion: cc help indivs stay in touch with friends-related (social inclusion)? we measure: c.emotion and c. socinclusion?
tab i8 //emotionally + socially tired of staying home q= Are you tired (emotionally or socially) of staying home due to COVID19, its lockdown restrictions and other personal avoidance steps you have taken??
*no baseline?
*separate?
pdslasso EmotSoc_Tired tmt01 tmt02 (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
test tmt01 tmt02
local ttest_p = string(`r(p)', "%15.3fc")
sum EmotSoc_Tired if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_7.tex", keep(tmt01 tmt02) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, ///
			Mean of dep. variable, `control_mean', ///
			p-value-jointtest, `ttest_p', ///
			p-value: Romano-Wolf Correction tmt01, `rw_EmotSoc_Tired_tmt01', ///
			p-value: Romano-Wolf Correction tmt02, `rw_EmotSoc_Tired_tmt02') ///
	append

*pooled?
pdslasso EmotSoc_Tired tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum EmotSoc_Tired if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/ejMetaEffectsXChannels.doc", keep(tmt_all) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, ///
			Mean of dep. variable, `r(mean)') ///
	append
*very robust evidence improved soc inclusion

** Table 7 column 4
*separate?
pdslasso stayed5wks tmt01 tmt02 (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
test tmt01 tmt02
local ttest_p = string(`r(p)', "%15.3fc")
sum stayed5wks if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_7.tex", keep(tmt01 tmt02) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, ///
			Mean of dep. variable, `control_mean', ///
			p-value-jointtest, `ttest_p', ///
			p-value: Romano-Wolf Correction tmt01, `rw_stayed5wks_tmt01', ///
			p-value: Romano-Wolf Correction tmt02, `rw_stayed5wks_tmt02') ///
	append

*pooled?
pdslasso stayed5wks tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum stayed5wks if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/ejMetaEffectsXChannels.doc", keep(tmt_all) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, ///
			Mean of dep. variable, `r(mean)') ///
	append
*not surprising, trted indivs are very compliant and stayed home more, corroborative of a comm-driven social inclusion of treated indivs


** Table 7 column 5
*[rejuvination] test: what happens when combined with communication credit trts?
**//interact w COVID CASES in district?**
*separate?
pdslasso xgrowth c.tmt01##c.previouslock c.tmt02##c.previouslock (i.districtX i.dateinterviewend totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0) if (xgrowth>=-300 & xgrowth<=100), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
test c.tmt01#c.previouslock c.tmt02#c.previouslock
local ttest_p2 = string(`r(p)', "%15.3fc")

sum xgrowth if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_7.tex", ///
	keep(c.tmt01 c.tmt02 c.tmt01#c.previouslock c.tmt02#c.previouslock c.previouslock) ///
	sortvar(tmt01 tmt02 previouslock) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, ///
			Mean of dep. variable, `control_mean', ///
			p-value-jointtest interaction, `ttest_p2', ///
			p-value: Romano-Wolf Correction tmt01, `rw_xgrowth_tmt01', ///
			p-value: Romano-Wolf Correction tmt02, `rw_xgrowth_tmt02') ///
	append

*pooled?
pdslasso xgrowth c.tmt_all##c.previouslock (i.districtX i.dateinterviewend totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0) if (xgrowth>=-300 & xgrowth<=100), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum xgrowth if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/ejMetaEffectsXChannels.doc", ///
	keep(tmt_all c.tmt_all#c.previouslock c.previouslock) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, ///
			Mean of dep. variable, `r(mean)') ///
	append
*limited evidence (though insig +7% increase in consumption growth for tranche treatment) -- yet theoretically plausible

