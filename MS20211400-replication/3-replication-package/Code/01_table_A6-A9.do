/*
Tables A6-A9
*/


***********************************
use "${replication_dir}/Data/03_clean/end1_end2.dta", clear	
cd "${replication_dir}/Output/Tables"

** bring this step in although it's also used to generate Fig A10
tab regionX
tab regionX, nolab
sum xgrowth if xgrowth, d
bys previouslock: sum xgrowth if (xgrowth>-300 & xgrowth<100), d //worst cgrowth in locked areas! so truly a shock [trimmed at 95%?]


**Heterogeneity: ?
**Comment: MHT Correction - The Romano-Wolf Multiple Hypothesis Correction
*(i) MEta?
*rwolf unableCall7days1 unableToCOVID1 digitborrow1 digitloan1, indepvar(tmt_all) seed(124) //fam 1 (fist stage outcomes)
gen jointPov = tmt_all*pov_likelihood
gen jointInf = tmt_all*informal0
gen jointFem = tmt_all*female0
gen jointLoc = tmt_all*previouslock
// rwolf texp1 c1 c2 e1 e2 e3 e4 e5, indepvar(tmt_all pov_likelihood jointPov) seed(124)
// rwolf tp1 hp1 logk101 sd1, indepvar(tmt_all jointPov) seed(124) //not estimable for all 3
//
// rwolf texp1 c1 c2 e1 e2 e3 e4 e5, indepvar(tmt_all informal0 jointInf) seed(124)
// rwolf tp1 hp1 logk101 sd1, indepvar(tmt_all informal0 jointInf) seed(124)
//
// rwolf texp1 c1 c2 e1 e2 e3 e4 e5, indepvar(tmt_all jointFem female0) seed(124)
// rwolf tp1 hp1 logk101 sd1, indepvar(tmt_all female0 jointFem) seed(124)
//
// rwolf texp1 c1 c2 e1 e2 e3 e4 e5, indepvar(tmt_all previouslock jointLoc) seed(124)
// rwolf tp1 hp1 logk101 sd1, indepvar(tmt_all jointLoc) seed(124) //not estimable for all 3
/*(ii) SEparate?
rwolf unableCall7days1 unableToCOVID1 digitborrow1 digitloan1, indepvar(tmt01 tmt02) seed(124) //fam 1 (fist stage outcomes)
rwolf texp1 c1 c2 e1 e2 e3 e4 e5, indepvar(tmt01 tmt02) seed(124) //fam 2 (second stage real impact outcomes - consumption)
rwolf tp1 hp1 logk101 sd1, indepvar(tmt01 tmt02) seed(124) //fam 3 (second stage real impact outcomes - mental health)
*/

** shorten names for locals to work
rename (totExp7days1 threatenPartner1 hitPartner1 logk101 severe_distress1) ///
	   (texp1 		 tp1 			  hp1 		  logk101 sd1)

label var pov_likelihood "Poverty Likelihood"	   
label var informal0 "Informal Sector 0-1"	   
label var female0 "Female 0-1"	   
label var previouslock "Locked-Down 0-1"	
   
label var tp1 "Threatened, Partner 1-4"
label var hp1 "Hit, Partner 1-4"
label var logk101 "log K10"
label var sd1 "Severe, Distress 0-1"

**Comment: MHT Correction - The Romano-Wolf Multiple Hypothesis Correction
local y_list4 texp1 tp1 hp1 logk101 sd1
local t_list1 tmt_all pov_likelihood 	jointPov
local t_list2 tmt_all informal0 		jointInf
local t_list3 tmt_all female0 			jointFem
local t_list4 tmt_all previouslock 		jointLoc

// local reps_option "reps(10)"

foreach y_list in y_list4 {
	foreach t_list in t_list1 {
		
		** calculate RW p-values
		rwolf ``y_list'', indepvar(``t_list'') seed(124) `reps_option'
		
		ereturn list
		** collect outcomes
		foreach y in ``y_list'' {
			foreach t in ``t_list'' {
// 				dis "y: `y'. t: `t'"
				local rw_`y'_`t' 	= string(e(rw_`y'_`t'), "%15.3fc")
				dis "rw_`y'_`t' = `rw_`y'_`t''"
			}
		}
	}
}



** Table A6 (metaEffects_Xpoverty)
**(1)poverty? evidence: the modest DV reduction is sig more on the very poor (similarly for mental health but ns)
pdslasso texp1 c.tmt_all##c.pov_likelihood (i.districtX i.dateinterviewend totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum texp1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "table_a6.tex", keep(c.tmt_all c.pov_likelihood c.tmt_all#c.pov_likelihood) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, PD LASSO, ///
			Mean of dep. variable, `control_mean', ///
			p-value: Romano-Wolf Correction treatment, `rw_texp1_tmt_all', ///
			p-value: Romano-Wolf Correction poverty, `rw_texp1_pov_likelihood', ///
			p-value: Romano-Wolf Correction interaction, `rw_texp1_jointPov') ///
	replace tex(frag) nonotes label nocons

pdslasso tp1 c.tmt_all##c.pov_likelihood (i.districtX i.dateinterviewend threatenPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum tp1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "table_a6.tex", keep(c.tmt_all c.pov_likelihood c.tmt_all#c.pov_likelihood) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, PD LASSO, ///
			Mean of dep. variable, `control_mean', ///
			p-value: Romano-Wolf Correction treatment, `rw_tp1_tmt_all', ///
			p-value: Romano-Wolf Correction poverty, `rw_tp1_pov_likelihood', ///
			p-value: Romano-Wolf Correction interaction, `rw_tp1_jointPov') ///
	append tex(frag) nonotes label nocons

pdslasso hp1 c.tmt_all##c.pov_likelihood (i.districtX i.dateinterviewend hitPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum hp1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "table_a6.tex", keep(c.tmt_all c.pov_likelihood c.tmt_all#c.pov_likelihood) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, PD LASSO, ///
			Mean of dep. variable, `control_mean', ///
			p-value: Romano-Wolf Correction treatment, `rw_hp1_tmt_all', ///
			p-value: Romano-Wolf Correction poverty, `rw_hp1_pov_likelihood', ///
			p-value: Romano-Wolf Correction interaction, `rw_hp1_jointPov') ///
	append tex(frag) nonotes label nocons

pdslasso logk101 c.tmt_all##c.pov_likelihood (i.districtX i.dateinterviewend logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum logk101 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "table_a6.tex", keep(c.tmt_all c.pov_likelihood c.tmt_all#c.pov_likelihood) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, PD LASSO, ///
			Mean of dep. variable, `control_mean', ///
			p-value: Romano-Wolf Correction treatment, `rw_logk101_tmt_all', ///
			p-value: Romano-Wolf Correction poverty, `rw_logk101_pov_likelihood', ///
			p-value: Romano-Wolf Correction interaction, `rw_logk101_jointPov') ///
	append tex(frag) nonotes label nocons

pdslasso sd1 c.tmt_all##c.pov_likelihood (i.districtX i.dateinterviewend severe_distress female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum sd1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "table_a6.tex", keep(c.tmt_all c.pov_likelihood c.tmt_all#c.pov_likelihood) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, PD LASSO, ///
			Mean of dep. variable, `control_mean', ///
			p-value: Romano-Wolf Correction treatment, `rw_sd1_tmt_all', ///
			p-value: Romano-Wolf Correction poverty, `rw_sd1_pov_likelihood', ///
			p-value: Romano-Wolf Correction interaction, `rw_sd1_jointPov') ///
	append tex(frag) nonotes label nocons

** import table to fix interaction name
preserve
	import delimited  "table_a6.tex", clear delimiters("<>")
	replace v1 = subinstr(v1, "c.tmt\_all\#c.pov\_likelihood", "Credit x Poverty", .)
	drop if strpos(v1, "Number of groups") > 0
	outfile v1 using  "table_a6.tex", replace noquote
restore

** Table A7 (metaEffects_Xinformal)
**(2)informal0? evidence: those in informal sector experienced large/better-sig mental health effects

foreach y_list in y_list4 {
	foreach t_list in t_list2 {
		
		** calculate RW p-values
		rwolf ``y_list'', indepvar(``t_list'') seed(124) `reps_option'
		
		ereturn list
		** collect outcomes
		foreach y in ``y_list'' {
			foreach t in ``t_list'' {
// 				dis "y: `y'. t: `t'"
				local rw_`y'_`t' 	= string(e(rw_`y'_`t'), "%15.3fc")
				dis "rw_`y'_`t' = `rw_`y'_`t''"
			}
		}
	}
}

pdslasso texp1 c.tmt_all##c.informal0 (i.districtX i.dateinterviewend totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum texp1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "table_a7.tex", keep(c.tmt_all c.informal0 c.tmt_all#c.informal0) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, PD LASSO, ///
			Mean of dep. variable, `control_mean', ///
			p-value: Romano-Wolf Correction treatment, `rw_texp1_tmt_all', ///
			p-value: Romano-Wolf Correction informal, `rw_texp1_informal0', ///
			p-value: Romano-Wolf Correction interaction, `rw_texp1_jointInf') ///
	replace tex(frag) nonotes label nocons

pdslasso tp1 c.tmt_all##c.informal0 (i.districtX i.dateinterviewend threatenPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0  incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum tp1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "table_a7.tex", keep(c.tmt_all c.informal0 c.tmt_all#c.informal0) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, PD LASSO, ///
			Mean of dep. variable, `control_mean', ///
			p-value: Romano-Wolf Correction treatment, `rw_tp1_tmt_all', ///
			p-value: Romano-Wolf Correction informal, `rw_tp1_informal0', ///
			p-value: Romano-Wolf Correction interaction, `rw_tp1_jointInf') ///
	append tex(frag) nonotes label nocons

pdslasso hp1 c.tmt_all##c.informal0 (i.districtX i.dateinterviewend hitPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0  incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum hp1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "table_a7.tex", keep(c.tmt_all c.informal0 c.tmt_all#c.informal0) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, PD LASSO, ///
			Mean of dep. variable, `control_mean', ///
			p-value: Romano-Wolf Correction treatment, `rw_hp1_tmt_all', ///
			p-value: Romano-Wolf Correction informal, `rw_hp1_informal0', ///
			p-value: Romano-Wolf Correction interaction, `rw_hp1_jointInf') ///
	append tex(frag) nonotes label nocons

pdslasso logk101 c.tmt_all##c.informal0 (i.districtX i.dateinterviewend logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0  incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum logk101 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "table_a7.tex", keep(c.tmt_all c.informal0 c.tmt_all#c.informal0) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, PD LASSO, ///
			Mean of dep. variable, `control_mean', ///
			p-value: Romano-Wolf Correction treatment, `rw_logk101_tmt_all', ///
			p-value: Romano-Wolf Correction informal, `rw_logk101_informal0', ///
			p-value: Romano-Wolf Correction interaction, `rw_logk101_jointInf') ///
	append tex(frag) nonotes label nocons

pdslasso sd1 c.tmt_all##c.informal0 (i.districtX i.dateinterviewend severe_distress female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0  incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum sd1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "table_a7.tex", keep(c.tmt_all c.informal0 c.tmt_all#c.informal0) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, PD LASSO, ///
			Mean of dep. variable, `control_mean', ///
			p-value: Romano-Wolf Correction treatment, `rw_sd1_tmt_all', ///
			p-value: Romano-Wolf Correction informal, `rw_sd1_informal0', ///
			p-value: Romano-Wolf Correction interaction, `rw_sd1_jointInf') ///
	append tex(frag) nonotes label nocons
	
** import table to fix interaction name
preserve
	import delimited  "table_a7.tex", clear delimiters("<>")
	replace v1 = subinstr(v1, "c.tmt\_all\#c.informal0", "Credit x Informal 0-1", .)
	drop if strpos(v1, "Number of groups") > 0
	outfile v1 using  "table_a7.tex", replace noquote
restore
	
** Table A8 (metaEffects_Xfemale)
**(3)female/gender? evidence: females experienced "slightly" (ns, but) better mental health effects
foreach y_list in y_list4 {
	foreach t_list in t_list3 {
		
		** calculate RW p-values
		rwolf ``y_list'', indepvar(``t_list'') seed(124) `reps_option'
		
		ereturn list
		** collect outcomes
		foreach y in ``y_list'' {
			foreach t in ``t_list'' {
// 				dis "y: `y'. t: `t'"
				local rw_`y'_`t' 	= string(e(rw_`y'_`t'), "%15.3fc")
				dis "rw_`y'_`t' = `rw_`y'_`t''"
			}
		}
	}
}
	
pdslasso texp1 c.tmt_all##c.female0 (i.districtX i.dateinterviewend totExp7days akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum texp1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "table_a8.tex", keep(c.tmt_all c.female0 c.tmt_all#c.female0) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, PD LASSO, ///
			Mean of dep. variable, `control_mean', ///
			p-value: Romano-Wolf Correction treatment, `rw_texp1_tmt_all', ///
			p-value: Romano-Wolf Correction female, `rw_texp1_female0', ///
			p-value: Romano-Wolf Correction interaction, `rw_texp1_jointFem') ///
	replace tex(frag) nonotes label nocons

pdslasso tp1 c.tmt_all##c.female0 (i.districtX i.dateinterviewend threatenPartner akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum tp1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "table_a8.tex", keep(c.tmt_all c.female0 c.tmt_all#c.female0) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, PD LASSO, ///
			Mean of dep. variable, `control_mean', ///
			p-value: Romano-Wolf Correction treatment, `rw_tp1_tmt_all', ///
			p-value: Romano-Wolf Correction female, `rw_tp1_female0', ///
			p-value: Romano-Wolf Correction interaction, `rw_tp1_jointFem') ///
	append tex(frag) nonotes label nocons

pdslasso hp1 c.tmt_all##c.female0 (i.districtX i.dateinterviewend hitPartner akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum hp1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "table_a8.tex", keep(c.tmt_all c.female0 c.tmt_all#c.female0) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, PD LASSO, ///
			Mean of dep. variable, `control_mean', ///
			p-value: Romano-Wolf Correction treatment, `rw_hp1_tmt_all', ///
			p-value: Romano-Wolf Correction female, `rw_hp1_female0', ///
			p-value: Romano-Wolf Correction interaction, `rw_hp1_jointFem') ///
	append tex(frag) nonotes label nocons

pdslasso logk101 c.tmt_all##c.female0 (i.districtX i.dateinterviewend logk10 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum logk101 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "table_a8.tex", keep(c.tmt_all c.female0 c.tmt_all#c.female0) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, PD LASSO, ///
			Mean of dep. variable, `control_mean', ///
			p-value: Romano-Wolf Correction treatment, `rw_logk101_tmt_all', ///
			p-value: Romano-Wolf Correction female, `rw_logk101_female0', ///
			p-value: Romano-Wolf Correction interaction, `rw_logk101_jointFem') ///
	append tex(frag) nonotes label nocons

pdslasso sd1 c.tmt_all##c.female0 (i.districtX i.dateinterviewend severe_distress akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum sd1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "table_a8.tex", keep(c.tmt_all c.female0 c.tmt_all#c.female0) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, PD LASSO, ///
			Mean of dep. variable, `control_mean', ///
			p-value: Romano-Wolf Correction treatment, `rw_sd1_tmt_all', ///
			p-value: Romano-Wolf Correction female, `rw_sd1_female0', ///
			p-value: Romano-Wolf Correction interaction, `rw_sd1_jointFem') ///
	append tex(frag) nonotes label nocons

** import table to fix interaction name
preserve
	import delimited  "table_a8.tex", clear delimiters("<>")
	replace v1 = subinstr(v1, "c.tmt\_all\#c.female0", "Credit x Female 0-1", .)
	drop if strpos(v1, "Number of groups") > 0
	outfile v1 using  "table_a8.tex", replace noquote
restore	
	
** Table A9 (metaEffects_Xlockeddown)
**(4)region: never-lock vs no previously-lock = so might still be battling (direct) econ ? evidence: eager to re-allocate their budgets to more consumption (utilities and durables, as expected)

foreach y_list in y_list4 {
	foreach t_list in t_list4 {
		
		** calculate RW p-values
		rwolf ``y_list'', indepvar(``t_list'') seed(124) `reps_option'
		
		ereturn list
		** collect outcomes
		foreach y in ``y_list'' {
			foreach t in ``t_list'' {
// 				dis "y: `y'. t: `t'"
				local rw_`y'_`t' 	= string(e(rw_`y'_`t'), "%15.3fc")
				dis "rw_`y'_`t' = `rw_`y'_`t''"
			}
		}
	}
}

pdslasso texp1 c.tmt_all##c.previouslock (i.districtX i.dateinterviewend totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum texp1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "table_a9.tex", keep(c.tmt_all c.previouslock c.tmt_all#c.previouslock) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, PD LASSO, ///
			Mean of dep. variable, `control_mean', ///
			p-value: Romano-Wolf Correction treatment, `rw_texp1_tmt_all', ///
			p-value: Romano-Wolf Correction locked, `rw_texp1_previouslock', ///
			p-value: Romano-Wolf Correction interaction, `rw_texp1_jointLoc') ///
	replace tex(frag) nonotes label nocons

pdslasso tp1 c.tmt_all##c.previouslock (i.districtX i.dateinterviewend threatenPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum tp1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "table_a9.tex", keep(c.tmt_all c.previouslock c.tmt_all#c.previouslock) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, PD LASSO, ///
			Mean of dep. variable, `control_mean', ///
			p-value: Romano-Wolf Correction treatment, `rw_tp1_tmt_all', ///
			p-value: Romano-Wolf Correction locked, `rw_tp1_previouslock', ///
			p-value: Romano-Wolf Correction interaction, `rw_tp1_jointLoc') ///
	append tex(frag) nonotes label nocons

pdslasso hp1 c.tmt_all##c.previouslock (i.districtX i.dateinterviewend hitPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum hp1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "table_a9.tex", keep(c.tmt_all c.previouslock c.tmt_all#c.previouslock) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, PD LASSO, ///
			Mean of dep. variable, `control_mean', ///
			p-value: Romano-Wolf Correction treatment, `rw_hp1_tmt_all', ///
			p-value: Romano-Wolf Correction locked, `rw_hp1_previouslock', ///
			p-value: Romano-Wolf Correction interaction, `rw_hp1_jointLoc') ///
	append tex(frag) nonotes label nocons

pdslasso logk101 c.tmt_all##c.previouslock (i.districtX i.dateinterviewend logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum logk101 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "table_a9.tex", keep(c.tmt_all c.previouslock c.tmt_all#c.previouslock) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, PD LASSO, ///
			Mean of dep. variable, `control_mean', ///
			p-value: Romano-Wolf Correction treatment, `rw_logk101_tmt_all', ///
			p-value: Romano-Wolf Correction locked, `rw_logk101_previouslock', ///
			p-value: Romano-Wolf Correction interaction, `rw_logk101_jointLoc') ///
	append tex(frag) nonotes label nocons

pdslasso sd1 c.tmt_all##c.previouslock (i.districtX i.dateinterviewend severe_distress female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum sd1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "table_a9.tex", keep(c.tmt_all c.previouslock c.tmt_all#c.previouslock) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, PD LASSO, ///
			Mean of dep. variable, `control_mean', ///
			p-value: Romano-Wolf Correction treatment, `rw_sd1_tmt_all', ///
			p-value: Romano-Wolf Correction locked, `rw_sd1_previouslock', ///
			p-value: Romano-Wolf Correction interaction, `rw_sd1_jointLoc') ///
	append tex(frag) nonotes label nocons

** import table to fix interaction name
preserve
	import delimited  "table_a9.tex", clear delimiters("<>")
	replace v1 = subinstr(v1, "c.tmt\_all\#c.previouslock", "Credit x Locked-down 0-1", .)
	drop if strpos(v1, "Number of groups") > 0
	outfile v1 using  "table_a9.tex", replace noquote
restore	
	
	