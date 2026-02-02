/*
Table 6 and Figure A9
*/
set graphics off
set seed $project_seed

***********************************
use "${replication_dir}/Data/03_clean/end1_end2.dta", clear	


**Comment: MHT Correction - The Romano-Wolf Multiple Hypothesis Correction
// local y_list1 unableCall7days1 unableToCOVID1 digitborrow1 digitloan1
// local y_list2 totExp7days1 c1 c2 e1 e2 e3 e4 e5
// local y_list3 threatenPartner1 hitPartner1 logk101 severe_distress1
local y_list4 totExp7days1 threatenPartner1 hitPartner1 logk101 severe_distress1
// local t_list1 tmt_all
local t_list2 tmt01 tmt02
 
foreach y_list in y_list4 { // y_list1 y_list2 y_list3
	foreach t_list in t_list2 { // t_list1
		
// 		local reps_option "reps(10)"
		
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
	
** Table 2
	leebounds totExp7days1 tmt01, level(90) cieffect tight() 	
	local lee_lower = string(e(b)[1,1], "%15.3fc") // Lee (2009)
	local lee_upper = string(e(b)[1,2], "%15.3fc")
	local lee_bounds01 = "[`lee_lower'; `lee_upper']"	
	local im_lower = string(e(cilower), "%15.3fc") // Imbens-Manski (2004)
	local im_upper = string(e(ciupper), "%15.3fc")
	local im_bounds01 = "[`im_lower'; `im_upper']"
	
	leebounds totExp7days1 tmt02, level(90) cieffect tight() 	
	local lee_lower = string(e(b)[1,1], "%15.3fc") // Lee (2009)
	local lee_upper = string(e(b)[1,2], "%15.3fc")
	local lee_bounds02 = "[`lee_lower'; `lee_upper']"	
	local im_lower = string(e(cilower), "%15.3fc") // Imbens-Manski (2004)
	local im_upper = string(e(ciupper), "%15.3fc")
	local im_bounds02 = "[`im_lower'; `im_upper']"

**expenditure Shifts [resource reallocation effect]?
pdslasso totExp7days1 tmt01 tmt02 (i.districtX i.dateinterviewend totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum totExp7days1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
test tmt01 tmt02
local ttest_p = string(`r(p)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_6.tex", keep(tmt01 tmt02) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, PD LASSO, ///
			Mean of dep. variable, `control_mean', ///
			p-value for test: $\beta_1$ = $\beta_2$, `ttest_p', ///
			Lee 2009 Attrition Bounds $\beta_1$, `lee_bounds01', ///
			Lee 2009 Attrition Bounds $\beta_2$, `lee_bounds02', ///
			Imbens-Manski 2004 CS $\beta_1$, `im_bounds01', ///
			Imbens-Manski 2004 CS $\beta_2$, `im_bounds02', ///
			p-value: Romano-Wolf Correction $\beta_1$, `rw_totExp7days1_tmt01', ///
			p-value: Romano-Wolf Correction $\beta_2$, `rw_totExp7days1_tmt02') ///
	replace tex(frag) nonotes label nocons
// sepEffects_wellbeing_econ_mh

*dyna fig
pdslasso totExp7days1 c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2 (i.districtX i.dateinterviewend totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(60) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt01#c.round1="Endline (round 1): lumpsum" c.tmt02#c.round1="Endline (round 1): Installments" c.tmt01#c.round2="Endline (round 2): lumpsum" c.tmt02#c.round2="Endline (round 2): Installments") title("Survey-level: consumption expenses (GHS)")
gr export "${replication_dir}/Output/Figures/figure_a9_1.eps", replace // sep_totExp7days
	

**dV
	leebounds threatenPartner1 tmt01, level(90) cieffect tight() 	
	local lee_lower = string(e(b)[1,1], "%15.3fc") // Lee (2009)
	local lee_upper = string(e(b)[1,2], "%15.3fc")
	local lee_bounds01 = "[`lee_lower'; `lee_upper']"	
	local im_lower = string(e(cilower), "%15.3fc") // Imbens-Manski (2004)
	local im_upper = string(e(ciupper), "%15.3fc")
	local im_bounds01 = "[`im_lower'; `im_upper']"
	
	leebounds threatenPartner1 tmt02, level(90) cieffect tight() 	
	local lee_lower = string(e(b)[1,1], "%15.3fc") // Lee (2009)
	local lee_upper = string(e(b)[1,2], "%15.3fc")
	local lee_bounds02 = "[`lee_lower'; `lee_upper']"	
	local im_lower = string(e(cilower), "%15.3fc") // Imbens-Manski (2004)
	local im_upper = string(e(ciupper), "%15.3fc")
	local im_bounds02 = "[`im_lower'; `im_upper']"

pdslasso threatenPartner1 tmt01 tmt02 (i.districtX i.dateinterviewend threatenPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum threatenPartner1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
test tmt01 tmt02
local ttest_p = string(`r(p)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_6.tex", keep(tmt01 tmt02) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, PD LASSO, ///
			Mean of dep. variable, `control_mean', ///
			p-value for test: $\beta_1$ = $\beta_2$, `ttest_p', ///
			Lee 2009 Attrition Bounds $\beta_1$, `lee_bounds01', ///
			Lee 2009 Attrition Bounds $\beta_2$, `lee_bounds02', ///
			Imbens-Manski 2004 CS $\beta_1$, `im_bounds01', ///
			Imbens-Manski 2004 CS $\beta_2$, `im_bounds02', ///
			p-value: Romano-Wolf Correction $\beta_1$, `rw_threatenPartner1_tmt01', ///
			p-value: Romano-Wolf Correction $\beta_2$, `rw_threatenPartner1_tmt02') ///
	append tex(frag) nonotes label nocons

*dyna fig
pdslasso threatenPartner1 c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2 (i.districtX i.dateinterviewend threatenPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(60) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt01#c.round1="Endline (round 1): lumpsum" c.tmt02#c.round1="Endline (round 1): Installments" c.tmt01#c.round2="Endline (round 2): lumpsum" c.tmt02#c.round2="Endline (round 2): Installments") title("Survey-level: threatened partner 1-4")
gr export "${replication_dir}/Output/Figures/figure_a9_2.eps", replace // sep_threatenPartner
	

	leebounds hitPartner1 tmt01, level(90) cieffect tight() 	
	local lee_lower = string(e(b)[1,1], "%15.3fc") // Lee (2009)
	local lee_upper = string(e(b)[1,2], "%15.3fc")
	local lee_bounds01 = "[`lee_lower'; `lee_upper']"	
	local im_lower = string(e(cilower), "%15.3fc") // Imbens-Manski (2004)
	local im_upper = string(e(ciupper), "%15.3fc")
	local im_bounds01 = "[`im_lower'; `im_upper']"
	
	leebounds hitPartner1 tmt02, level(90) cieffect tight() 	
	local lee_lower = string(e(b)[1,1], "%15.3fc") // Lee (2009)
	local lee_upper = string(e(b)[1,2], "%15.3fc")
	local lee_bounds02 = "[`lee_lower'; `lee_upper']"	
	local im_lower = string(e(cilower), "%15.3fc") // Imbens-Manski (2004)
	local im_upper = string(e(ciupper), "%15.3fc")
	local im_bounds02 = "[`im_lower'; `im_upper']"

pdslasso hitPartner1 tmt01 tmt02 (i.districtX i.dateinterviewend hitPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum hitPartner1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
test tmt01 tmt02
local ttest_p = string(`r(p)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_6.tex", keep(tmt01 tmt02) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, PD LASSO, ///
			Mean of dep. variable, `control_mean', ///
			p-value for test: $\beta_1$ = $\beta_2$, `ttest_p', ///
			Lee 2009 Attrition Bounds $\beta_1$, `lee_bounds01', ///
			Lee 2009 Attrition Bounds $\beta_2$, `lee_bounds02', ///
			Imbens-Manski 2004 CS $\beta_1$, `im_bounds01', ///
			Imbens-Manski 2004 CS $\beta_2$, `im_bounds02', ///
			p-value: Romano-Wolf Correction $\beta_1$, `rw_hitPartner1_tmt01', ///
			p-value: Romano-Wolf Correction $\beta_2$, `rw_hitPartner1_tmt02') ///
	append tex(frag) nonotes label nocons

*dyna fig
pdslasso hitPartner1 c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2 (i.districtX i.dateinterviewend hitPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(60) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt01#c.round1="Endline (round 1): lumpsum" c.tmt02#c.round1="Endline (round 1): Installments" c.tmt01#c.round2="Endline (round 2): lumpsum" c.tmt02#c.round2="Endline (round 2): Installments") title("Survey-level: hit partner 1-4")
gr export "${replication_dir}/Output/Figures/figure_a9_3.eps", replace // sep_hitPartner
	
	
	
**mH
	leebounds logk101 tmt01, level(90) cieffect tight() 	
	local lee_lower = string(e(b)[1,1], "%15.3fc") // Lee (2009)
	local lee_upper = string(e(b)[1,2], "%15.3fc")
	local lee_bounds01 = "[`lee_lower'; `lee_upper']"	
	local im_lower = string(e(cilower), "%15.3fc") // Imbens-Manski (2004)
	local im_upper = string(e(ciupper), "%15.3fc")
	local im_bounds01 = "[`im_lower'; `im_upper']"
	
	leebounds logk101 tmt02, level(90) cieffect tight() 	
	local lee_lower = string(e(b)[1,1], "%15.3fc") // Lee (2009)
	local lee_upper = string(e(b)[1,2], "%15.3fc")
	local lee_bounds02 = "[`lee_lower'; `lee_upper']"	
	local im_lower = string(e(cilower), "%15.3fc") // Imbens-Manski (2004)
	local im_upper = string(e(ciupper), "%15.3fc")
	local im_bounds02 = "[`im_lower'; `im_upper']"

pdslasso logk101 c.tmt01 c.tmt02 (i.districtX i.dateinterviewend logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum logk101 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
test tmt01 tmt02
local ttest_p = string(`r(p)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_6.tex", keep(tmt01 tmt02) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, PD LASSO, ///
			Mean of dep. variable, `control_mean', ///
			p-value for test: $\beta_1$ = $\beta_2$, `ttest_p', ///
			Lee 2009 Attrition Bounds $\beta_1$, `lee_bounds01', ///
			Lee 2009 Attrition Bounds $\beta_2$, `lee_bounds02', ///
			Imbens-Manski 2004 CS $\beta_1$, `im_bounds01', ///
			Imbens-Manski 2004 CS $\beta_2$, `im_bounds02', ///
			p-value: Romano-Wolf Correction $\beta_1$, `rw_logk101_tmt01', ///
			p-value: Romano-Wolf Correction $\beta_2$, `rw_logk101_tmt02') ///
	append tex(frag) nonotes label nocons

*dyna fig
pdslasso logk101 c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2 (i.districtX i.dateinterviewend logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(60) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt01#c.round1="Endline (round 1): lumpsum" c.tmt02#c.round1="Endline (round 1): Installments" c.tmt01#c.round2="Endline (round 2): lumpsum" c.tmt02#c.round2="Endline (round 2): Installments") title("Survey-level: logK10")
gr export "${replication_dir}/Output/Figures/figure_a9_4.eps", replace // sep_logk10
	
	leebounds severe_distress1 tmt01, level(90) cieffect tight() 	
	local lee_lower = string(e(b)[1,1], "%15.3fc") // Lee (2009)
	local lee_upper = string(e(b)[1,2], "%15.3fc")
	local lee_bounds01 = "[`lee_lower'; `lee_upper']"	
	local im_lower = string(e(cilower), "%15.3fc") // Imbens-Manski (2004)
	local im_upper = string(e(ciupper), "%15.3fc")
	local im_bounds01 = "[`im_lower'; `im_upper']"
	
	leebounds severe_distress1 tmt02, level(90) cieffect tight() 	
	local lee_lower = string(e(b)[1,1], "%15.3fc") // Lee (2009)
	local lee_upper = string(e(b)[1,2], "%15.3fc")
	local lee_bounds02 = "[`lee_lower'; `lee_upper']"	
	local im_lower = string(e(cilower), "%15.3fc") // Imbens-Manski (2004)
	local im_upper = string(e(ciupper), "%15.3fc")
	local im_bounds02 = "[`im_lower'; `im_upper']"

pdslasso severe_distress1 c.tmt01 c.tmt02 (i.districtX i.dateinterviewend i.severe_distress female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum severe_distress1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
test tmt01 tmt02
local ttest_p = string(`r(p)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_6.tex", keep(tmt01 tmt02) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, PD LASSO, ///
			Mean of dep. variable, `control_mean', ///
			p-value for test: $\beta_1$ = $\beta_2$, `ttest_p', ///
			Lee 2009 Attrition Bounds $\beta_1$, `lee_bounds01', ///
			Lee 2009 Attrition Bounds $\beta_2$, `lee_bounds02', ///
			Imbens-Manski 2004 CS $\beta_1$, `im_bounds01', ///
			Imbens-Manski 2004 CS $\beta_2$, `im_bounds02', ///
			p-value: Romano-Wolf Correction $\beta_1$, `rw_severe_distress1_tmt01', ///
			p-value: Romano-Wolf Correction $\beta_2$, `rw_severe_distress1_tmt02') ///
	append tex(frag) nonotes label nocons

*dyna fig
pdslasso severe_distress1 c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2  (i.districtX i.dateinterviewend severe_distress female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(60) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt01#c.round1="Endline (round 1): lumpsum" c.tmt02#c.round1="Endline (round 1): Installments" c.tmt01#c.round2="Endline (round 2): lumpsum" c.tmt02#c.round2="Endline (round 2): Installments") title("Survey-level: severe distress 0-1")
gr export "${replication_dir}/Output/Figures/figure_a9_5.eps", replace // sep_severe_distress
	
	
** import table to drop one row
import delimited "${replication_dir}/Output/Tables/table_6.tex", clear delimiters("<>")
drop if strpos(v1, "Number of groups") > 0
outfile v1 using  "${replication_dir}/Output/Tables/table_6.tex", replace noquote
