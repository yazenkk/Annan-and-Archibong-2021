/*
Table 3 and Figure A8
*/

***********************************
use "${replication_dir}/Data/03_clean/end1_end2.dta", replace	


**Comment: MHT Correction - The Romano-Wolf Multiple Hypothesis Correction
local y_list1 unableCall7days1 unableToCOVID1 digitborrow1 digitloan1
// local y_list2 totExp7days1 c1 c2 e1 e2 e3 e4 e5
// local y_list3 threatenPartner1 hitPartner1 logk101 severe_distress1
// local t_list1 tmt_all
local t_list2 tmt01 tmt02
 
foreach y_list in y_list1  { //  y_list2 y_list3
	foreach t_list in t_list2 { // t_list1
		
		** more reps for some tests
		if ("`y_list'" == "y_list1" | "`y_list'" == "y_list2") & "`t_list'" == "t_list1" local reps_option "reps(499)"
		else local reps_option ""
		
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


* Table 1
**separate Effects
**mitigate "unexpected" comm probl?
	leebounds unableCall7days1 tmt01, level(90) cieffect tight() 
	local lee_lower = string(e(b)[1,1], "%15.3fc") // Lee (2009)
	local lee_upper = string(e(b)[1,2], "%15.3fc")
	local lee_bounds01 = "[`lee_lower'; `lee_upper']"	
	local im_lower = string(e(cilower), "%15.3fc") // Imbens-Manski (2004)
	local im_upper = string(e(ciupper), "%15.3fc")
	local im_bounds01 = "[`im_lower'; `im_upper']"
	
	leebounds unableCall7days1 tmt02, level(90) cieffect tight() 	
	local lee_lower = string(e(b)[1,1], "%15.3fc") // Lee (2009)
	local lee_upper = string(e(b)[1,2], "%15.3fc")
	local lee_bounds02 = "[`lee_lower'; `lee_upper']"	
	local im_lower = string(e(cilower), "%15.3fc") // Imbens-Manski (2004)
	local im_upper = string(e(ciupper), "%15.3fc")
	local im_bounds02 = "[`im_lower'; `im_upper']"

pdslasso unableCall7days1 tmt01 tmt02 (i.districtX i.dateinterviewend unableCall7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum unableCall7days1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
test tmt01 tmt02
local ttest_p = string(`r(p)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_3.tex", ///
	keep(tmt01 tmt02) ///
	replace tex(frag) nonotes label nocons ///
	addtext(District FE, Yes, Date FE, Yes, Controls, PD LASSO, ///
			Mean of dep. variable, `control_mean', ///
			p-value for test: $\beta_1$ = $\beta_2$, `ttest_p', ///
			Lee 2009 Attrition Bounds $\beta_1$, `lee_bounds01', ///
			Lee 2009 Attrition Bounds $\beta_2$, `lee_bounds02', ///
			Imbens-Manski 2004 CS $\beta_1$, `im_bounds01', ///
			Imbens-Manski 2004 CS $\beta_2$, `im_bounds02', ///
			p-value: Romano-Wolf Correction $\beta_1$, `rw_unableCall7days1_tmt01', ///
			p-value: Romano-Wolf Correction $\beta_2$, `rw_unableCall7days1_tmt02')
// sepEffects_mitigate

*dyna fig
pdslasso unableCall7days1 c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2 (i.districtX i.dateinterviewend unableCall7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(60) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt01#c.round1="Endline (round 1): lumpsum" c.tmt02#c.round1="Endline (round 1): Installments" c.tmt01#c.round2="Endline (round 2): lumpsum" c.tmt02#c.round2="Endline (round 2): Installments") title("Survey-level: unable to communicate or call in past 7 days 0-1", size(med))
gr export "${replication_dir}/Output/Figures/figure_a8_1.eps", replace // sep_unableCall7days
	
	
	leebounds unableToCOVID1 tmt01, level(90) cieffect tight() 	
	local lee_lower = string(e(b)[1,1], "%15.3fc") // Lee (2009)
	local lee_upper = string(e(b)[1,2], "%15.3fc")
	local lee_bounds01 = "[`lee_lower'; `lee_upper']"	
	local im_lower = string(e(cilower), "%15.3fc") // Imbens-Manski (2004)
	local im_upper = string(e(ciupper), "%15.3fc")
	local im_bounds01 = "[`im_lower'; `im_upper']"
	
	leebounds unableToCOVID1 tmt02, level(90) cieffect tight() 	
	local lee_lower = string(e(b)[1,1], "%15.3fc") // Lee (2009)
	local lee_upper = string(e(b)[1,2], "%15.3fc")
	local lee_bounds02 = "[`lee_lower'; `lee_upper']"	
	local im_lower = string(e(cilower), "%15.3fc") // Imbens-Manski (2004)
	local im_upper = string(e(ciupper), "%15.3fc")
	local im_bounds02 = "[`im_lower'; `im_upper']"
	
pdslasso unableToCOVID1 tmt01 tmt02 (i.districtX i.dateinterviewend unableToCOVID female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum unableToCOVID1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
test tmt01 tmt02
local ttest_p = string(`r(p)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_3.tex", ///
	keep(tmt01 tmt02) ///
	append tex(frag) nonotes label nocons ///
	addtext(District FE, Yes, Date FE, Yes, Controls, PD LASSO, ///
	Mean of dep. variable, `control_mean', ///
	p-value for test: $\beta_1$ = $\beta_2$, `ttest_p', ///
	Lee 2009 Attrition Bounds $\beta_1$, `lee_bounds01', ///
	Lee 2009 Attrition Bounds $\beta_2$, `lee_bounds02', ///
	Imbens-Manski 2004 CS $\beta_1$, `im_bounds01', ///
	Imbens-Manski 2004 CS $\beta_2$, `im_bounds02', ///
	p-value: Romano-Wolf Correction $\beta_1$, `rw_unableToCOVID1_tmt01', ///
	p-value: Romano-Wolf Correction $\beta_2$, `rw_unableToCOVID1_tmt02')

*dyna fig
pdslasso unableToCOVID1 c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2  (i.districtX i.dateinterviewend unableToCOVID female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2 ) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(60) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt01#c.round1="Endline (round 1): lumpsum" c.tmt02#c.round1="Endline (round 1): Installments" c.tmt01#c.round2="Endline (round 2): lumpsum" c.tmt02#c.round2="Endline (round 2): Installments") title("Survey-level: unable to communicate or call due to COVID19 0-1", size(med))
gr export "${replication_dir}/Output/Figures/figure_a8_2.eps", replace // sep_unableToCOVID
	
	
	leebounds digitborrow1 tmt01, level(90) cieffect tight() 	
	local lee_lower = string(e(b)[1,1], "%15.3fc") // Lee (2009)
	local lee_upper = string(e(b)[1,2], "%15.3fc")
	local lee_bounds01 = "[`lee_lower'; `lee_upper']"	
	local im_lower = string(e(cilower), "%15.3fc") // Imbens-Manski (2004)
	local im_upper = string(e(ciupper), "%15.3fc")
	local im_bounds01 = "[`im_lower'; `im_upper']"
	
	leebounds digitborrow1 tmt02, level(90) cieffect tight() 	
	local lee_lower = string(e(b)[1,1], "%15.3fc") // Lee (2009)
	local lee_upper = string(e(b)[1,2], "%15.3fc")
	local lee_bounds02 = "[`lee_lower'; `lee_upper']"	
	local im_lower = string(e(cilower), "%15.3fc") // Imbens-Manski (2004)
	local im_upper = string(e(ciupper), "%15.3fc")
	local im_bounds02 = "[`im_lower'; `im_upper']"
	
pdslasso digitborrow1 tmt01 tmt02 (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum digitborrow1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
test tmt01 tmt02
local ttest_p = string(`r(p)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_3.tex", keep(tmt01 tmt02) ///
	append tex(frag) nonotes label nocons ///
	addtext(District FE, Yes, Date FE, Yes, Controls, PD LASSO, ///
	Mean of dep. variable, `control_mean', ///
	p-value for test: $\beta_1$ = $\beta_2$, `ttest_p', ///
	Lee 2009 Attrition Bounds $\beta_1$, `lee_bounds01', ///
	Lee 2009 Attrition Bounds $\beta_2$, `lee_bounds02', ///
	Imbens-Manski 2004 CS $\beta_1$, `im_bounds01', ///
	Imbens-Manski 2004 CS $\beta_2$, `im_bounds02', ///
	p-value: Romano-Wolf Correction $\beta_1$, `rw_digitborrow1_tmt01', ///
	p-value: Romano-Wolf Correction $\beta_2$, `rw_digitborrow1_tmt02')

*dyna fig
pdslasso digitborrow1 c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2  (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(60) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt01#c.round1="Endline (round 1): lumpsum" c.tmt02#c.round1="Endline (round 1): Installments" c.tmt01#c.round2="Endline (round 2): lumpsum" c.tmt02#c.round2="Endline (round 2): Installments") title("Survey-level: seek or borrow mobile credit 0-1")
gr export "${replication_dir}/Output/Figures/figure_a8_3.eps", replace // sep_digitborrow
	
	leebounds digitloan1 tmt01, level(90) cieffect tight() 	
	local lee_lower = string(e(b)[1,1], "%15.3fc") // Lee (2009)
	local lee_upper = string(e(b)[1,2], "%15.3fc")
	local lee_bounds01 = "[`lee_lower'; `lee_upper']"	
	local im_lower = string(e(cilower), "%15.3fc") // Imbens-Manski (2004)
	local im_upper = string(e(ciupper), "%15.3fc")
	local im_bounds01 = "[`im_lower'; `im_upper']"
	
	leebounds digitloan1 tmt02, level(90) cieffect tight() 	
	local lee_lower = string(e(b)[1,1], "%15.3fc") // Lee (2009)
	local lee_upper = string(e(b)[1,2], "%15.3fc")
	local lee_bounds02 = "[`lee_lower'; `lee_upper']"	
	local im_lower = string(e(cilower), "%15.3fc") // Imbens-Manski (2004)
	local im_upper = string(e(ciupper), "%15.3fc")
	local im_bounds02 = "[`im_lower'; `im_upper']"
	
pdslasso digitloan1 tmt01 tmt02 (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum digitloan1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
test tmt01 tmt02
local ttest_p = string(`r(p)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_3.tex", keep(tmt01 tmt02) ///
	append tex(frag) nonotes label nocons ///
	addtext(District FE, Yes, Date FE, Yes, Controls, PD LASSO, ///
	Mean of dep. variable, `control_mean', ///
	p-value for test: $\beta_1$ = $\beta_2$, `ttest_p', ///
	Lee 2009 Attrition Bounds $\beta_1$, `lee_bounds01', ///
	Lee 2009 Attrition Bounds $\beta_2$, `lee_bounds02', ///
	Imbens-Manski 2004 CS $\beta_1$, `im_bounds01', ///
	Imbens-Manski 2004 CS $\beta_2$, `im_bounds02', ///
	p-value: Romano-Wolf Correction $\beta_1$, `rw_digitloan1_tmt01', ///
	p-value: Romano-Wolf Correction $\beta_2$, `rw_digitloan1_tmt02') 

*dyna fig
pdslasso digitloan1 c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2 (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(60) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt01#c.round1="Endline (round 1): lumpsum" c.tmt02#c.round1="Endline (round 1): Installments" c.tmt01#c.round2="Endline (round 2): lumpsum" c.tmt02#c.round2="Endline (round 2): Installments") title("Survey-level: seek digital loan 0-1")
gr export "${replication_dir}/Output/Figures/figure_a8_4.eps", replace // sep_digitloan
	

