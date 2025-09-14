/*
Table 7
*/




***********************************
clear all
use "${replication_dir}/Data/03_clean/end1_end2.dta", clear


gen EmotSoc_Tired = (i8==1) if !missing(i8)
sum EmotSoc_Tired

gen stayed5wks=(p3==1) if !missing(p3) //asked (@ end 2 only): Consider the last 5 weeks - are you staying home as much as possible because of the covid19 outbreak?
tab round stayed5wks

label var i1 "Professional/Business, Networks:, Hours worked, (last 7 days) (Hrs)"
label var i2 "Professional/Business, Networks:, Business Income, (last 7 days) (GHS)"
label var EmotSoc_Tired "Social Inclusion/, Networks:, Emotionally, -Tired 0-1"
label var stayed5wks "Social Inclusion/, Networks:, Stayed Home, (last 5 weeks) 0-1"
label var xgrowth "Insurance, Networks:, Consumption, Growth (%)"
label var previouslock "Locked-down 0-1, [Consumption shock]"

**get rwolf pvals?
gen tmt01xLock =tmt01*previouslock 
gen tmt02xLock =tmt02*previouslock
gen tmt_allxLock =tmt_all*previouslock
// rwolf i1 i2 EmotSoc_Tired stayed5wks xgrowth, indepvar(tmt01 tmt02) seed(124) reps(499)
// rwolf i1 i2 EmotSoc_Tired 		    xgrowth, indepvar(tmt01 tmt02 tmt01xLock tmt02xLock previouslock) seed(124) reps(499) //get for interactions
*rwolf i1 i2 EmotSoc_Tired stayed5wks xgrowth, indepvar(tmt01 tmt02 tmt01xLock tmt02xLock previouslock) seed(124)

*reply comment: 
*our conjecture was that this is related to the # of boots reps (of r=100) and it is not.
*the default # of bootstrap replications is 100 in STATA. 
*changing this to a larger number (which is usually recommended fo IV models) does not seem to change our overall inference, so ended up keeping the default

**Comment: MHT Correction - The Romano-Wolf Multiple Hypothesis Correction
local y_list5 i1 i2 EmotSoc_Tired stayed5wks xgrowth
local y_list6 i1 i2 EmotSoc_Tired xgrowth
local t_list1 tmt_all
local t_list4 tmt_all tmt_allxLock previouslock
// local t_list2 tmt01 tmt02
// local t_list3 tmt01 tmt02 tmt01xLock tmt02xLock previouslock
 
foreach y_list in y_list5 y_list6 { //  
	foreach t_list in t_list1 t_list4 { //
		
// 		local reps_option "reps(10)"
		
		** calculate RW p-values
		rwolf ``y_list'', indepvar(``t_list'') seed(124) `reps_option'
		
		ereturn list
		** collect outcomes
		foreach y in ``y_list'' {
			foreach t in ``t_list'' {
				dis "y: `y'. t: `t'"
				local rw_`y'_`t' = string(e(rw_`y'_`t'), "%15.3fc")
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
pdslasso i1 tmt_all (i.districtX i.dateinterviewend i1b female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum i1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_7.tex", keep(tmt_all) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, PD LASSO, ///
			Mean of dep. variable, `control_mean', ///
			p-value: Romano-Wolf Correction $\beta$, `rw_i1_tmt_all', ///
			Treatment, 										"-", ///
			\hspace{0.5cm} x Locked-down 0-1 $\delta$, 		"-", ///
			p-value: Romano-Wolf Correction $\delta$, 		"-", ///
			p-value: Romano-Wolf Correction Lockdown, 		"-") ///
	replace tex(frag) nonotes label nocons
// ejSepEffectsXChannels

** Table 7 column 2
pdslasso i2 tmt_all (i.districtX i.dateinterviewend i2c female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum i2 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_7.tex", keep(tmt_all) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, PD LASSO, ///
			Mean of dep. variable, `control_mean', ///
			p-value: Romano-Wolf Correction $\beta$, `rw_i2_tmt_all', ///
			Treatment, 										"-", ///
			\hspace{0.5cm} x Locked-down 0-1 $\delta$, 		"-", ///
			p-value: Romano-Wolf Correction $\delta$, 		"-", ///
			p-value: Romano-Wolf Correction Lockdown, 		"-") ///
	append tex(frag) nonotes label nocons


** Table 7 column 3
*2. social networks #1-inclusion: cc help indivs stay in touch with friends-related (social inclusion)? we measure: c.emotion and c. socinclusion?
tab i8 //emotionally + socially tired of staying home q= Are you tired (emotionally or socially) of staying home due to COVID19, its lockdown restrictions and other personal avoidance steps you have taken??
*no baseline?
*separate?
pdslasso EmotSoc_Tired tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum EmotSoc_Tired if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_7.tex", keep(tmt_all) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, PD LASSO, ///
			Mean of dep. variable, `control_mean', ///
			p-value: Romano-Wolf Correction $\beta$, `rw_EmotSoc_Tired_tmt_all', ///
			Treatment, 										"-", ///
			\hspace{0.5cm} x Locked-down 0-1 $\delta$, 		"-", ///
			p-value: Romano-Wolf Correction $\delta$, 		"-", ///
			p-value: Romano-Wolf Correction Lockdown, 		"-") ///
	append tex(frag) nonotes label nocons


** Table 7 column 4
*separate?
pdslasso stayed5wks tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum stayed5wks if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_7.tex", keep(tmt_all) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, PD LASSO, ///
			Mean of dep. variable, `control_mean', ///
			p-value: Romano-Wolf Correction $\beta$, `rw_stayed5wks_tmt_all', ///
			Treatment, 										"-", ///
			\hspace{0.5cm} x Locked-down 0-1 $\delta$, 		"-", ///
			p-value: Romano-Wolf Correction $\delta$, 		"-", ///
			p-value: Romano-Wolf Correction Lockdown, 		"-") ///
	append tex(frag) nonotes label nocons



** Table 7 column 5
*[rejuvination] test: what happens when combined with communication credit trts?
**//interact w COVID CASES in district?**
*separate?
pdslasso xgrowth c.tmt_all##c.previouslock (i.districtX i.dateinterviewend totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0) if (xgrowth>=-300 & xgrowth<=100), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
** collect interaction terms to include in addtext
mat M = r(table)
local het_dimension previouslock
	
loc b_`het_dimension'  = string(M[rownumb(matrix(M), "b"),	    colnumb(matrix(M), "c.tmt_all#c.`het_dimension'")], "%15.3fc")
loc se_`het_dimension' = string(M[rownumb(matrix(M), "se"),     colnumb(matrix(M), "c.tmt_all#c.`het_dimension'")], "%12.3fc")
loc se_`het_dimension' = "[`se_`het_dimension'']"
loc p_`het_dimension'  = string(M[rownumb(matrix(M), "pvalue"), colnumb(matrix(M), "c.tmt_all#c.`het_dimension'")], "%12.3fc")
loc st_`het_dimension' = cond(`p_`het_dimension''<=.01,"***", ///
								  cond(`p_`het_dimension''<=.05,"**", ///
									   cond(`p_`het_dimension''<=.1,"*","")))
loc bs_`het_dimension' "`b_`het_dimension''`st_`het_dimension''" // combine b with star


sum xgrowth if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_7.tex", ///
	keep(c.tmt_all c.previouslock) ///
	sortvar(tmt_all previouslock) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, PD LASSO, ///
			Mean of dep. variable, `control_mean', ///
			p-value: Romano-Wolf Correction $\beta$, 	`rw_stayed5wks_tmt_all', ///
			Treatment, 									`b_previouslock', ///
			\hspace{0.5cm} x Locked-down 0-1 $\delta$, 	`se_previouslock', ///
			p-value: Romano-Wolf Correction $\delta$, 	`rw_xgrowth_tmt_allxLock', ///
			p-value: Romano-Wolf Correction Lockdown, 	`rw_xgrowth_previouslock') ///
	append tex(frag) nonotes label nocons

** import table to drop one row
import delimited "${replication_dir}/Output/Tables/table_7.tex", clear delimiters("<>")
drop if strpos(v1, "Number of groups") > 0
outfile v1 using  "${replication_dir}/Output/Tables/table_7.tex", replace noquote
