/*
Table 4
Figure A7, graph 1
*/


***********************************
use "${replication_dir}/Data/03_clean/end1_end2.dta", replace	


**Comment: MHT Correction - The Romano-Wolf Multiple Hypothesis Correction
// local y_list1 unableCall7days1 unableToCOVID1 digitborrow1 digitloan1
local y_list2 totExp7days1 c1 c2 e1 e2 e3 e4 e5
// local y_list3 threatenPartner1 hitPartner1 logk101 severe_distress1
local t_list1 tmt_all
// local t_list2 tmt01 tmt02
 
foreach y_list in y_list2  { //  y_list1 y_list3
	foreach t_list in t_list1 { // t_list2
		
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

	
** Table A8 (metaEffects_consume)
**expenditure Shifts [resource reallocation effect]?
	leebounds totExp7days1 tmt_all, level(90) cieffect tight() 
	local lee_lower = string(e(b)[1,1], "%15.3fc") // Lee (2009)
	local lee_upper = string(e(b)[1,2], "%15.3fc")
	local lee_bounds = "[`lee_lower'; `lee_upper']"	
	local im_lower = string(e(cilower), "%15.3fc") // Imbens-Manski (2004)
	local im_upper = string(e(ciupper), "%15.3fc")
	local im_bounds = "[`im_lower'; `im_upper']"
	
pdslasso totExp7days1 tmt_all (i.districtX i.dateinterviewend totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum totExp7days1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_4.tex", keep(c.tmt_all) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, ///
	Mean of dep. variable, `control_mean', ///
	Lee 2009 Attrition Bounds, `lee_bounds', ///
	Imbens-Manski 2004 CS, `im_bounds', ///
	p-value: Romano-Wolf Correction, `rw_totExp7days1') ///
	replace

	leebounds c1 tmt_all, level(90) cieffect tight() 
	local lee_lower = string(e(b)[1,1], "%15.3fc") // Lee (2009)
	local lee_upper = string(e(b)[1,2], "%15.3fc")
	local lee_bounds = "[`lee_lower'; `lee_upper']"	
	local im_lower = string(e(cilower), "%15.3fc") // Imbens-Manski (2004)
	local im_upper = string(e(ciupper), "%15.3fc")
	local im_bounds = "[`im_lower'; `im_upper']"
	
pdslasso c1 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum c1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_4.tex", keep(c.tmt_all) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, ///
	Mean of dep. variable, `control_mean', ///
	Lee 2009 Attrition Bounds, `lee_bounds', ///
	Imbens-Manski 2004 CS, `im_bounds', ///
	p-value: Romano-Wolf Correction, `rw_c1') ///
	append

	leebounds c2 tmt_all, level(90) cieffect tight() 
	local lee_lower = string(e(b)[1,1], "%15.3fc") // Lee (2009)
	local lee_upper = string(e(b)[1,2], "%15.3fc")
	local lee_bounds = "[`lee_lower'; `lee_upper']"	
	local im_lower = string(e(cilower), "%15.3fc") // Imbens-Manski (2004)
	local im_upper = string(e(ciupper), "%15.3fc")
	local im_bounds = "[`im_lower'; `im_upper']"
	
pdslasso c2 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum c2 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_4.tex", keep(c.tmt_all) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, ///
	Mean of dep. variable, `control_mean', ///
	Lee 2009 Attrition Bounds, `lee_bounds', ///
	Imbens-Manski 2004 CS, `im_bounds', ///
	p-value: Romano-Wolf Correction, `rw_c2') ///
	append

	leebounds e1 tmt_all, level(90) cieffect tight() 
	local lee_lower = string(e(b)[1,1], "%15.3fc") // Lee (2009)
	local lee_upper = string(e(b)[1,2], "%15.3fc")
	local lee_bounds = "[`lee_lower'; `lee_upper']"	
	local im_lower = string(e(cilower), "%15.3fc") // Imbens-Manski (2004)
	local im_upper = string(e(ciupper), "%15.3fc")
	local im_bounds = "[`im_lower'; `im_upper']"

	pdslasso e1 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum e1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_4.tex", keep(c.tmt_all) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, ///
	Mean of dep. variable, `control_mean', ///
	Lee 2009 Attrition Bounds, `lee_bounds', ///
	Imbens-Manski 2004 CS, `im_bounds', ///
	p-value: Romano-Wolf Correction, `rw_e1') ///
	append

	leebounds e2 tmt_all, level(90) cieffect tight() 
	local lee_lower = string(e(b)[1,1], "%15.3fc") // Lee (2009)
	local lee_upper = string(e(b)[1,2], "%15.3fc")
	local lee_bounds = "[`lee_lower'; `lee_upper']"	
	local im_lower = string(e(cilower), "%15.3fc") // Imbens-Manski (2004)
	local im_upper = string(e(ciupper), "%15.3fc")
	local im_bounds = "[`im_lower'; `im_upper']"

pdslasso e2 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum e2 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_4.tex", keep(c.tmt_all) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, ///
	Mean of dep. variable, `control_mean', ///
	Lee 2009 Attrition Bounds, `lee_bounds', ///
	Imbens-Manski 2004 CS, `im_bounds', ///
	p-value: Romano-Wolf Correction, `rw_e2') ///
	append

	leebounds e3 tmt_all, level(90) cieffect tight() 
	local lee_lower = string(e(b)[1,1], "%15.3fc") // Lee (2009)
	local lee_upper = string(e(b)[1,2], "%15.3fc")
	local lee_bounds = "[`lee_lower'; `lee_upper']"	
	local im_lower = string(e(cilower), "%15.3fc") // Imbens-Manski (2004)
	local im_upper = string(e(ciupper), "%15.3fc")
	local im_bounds = "[`im_lower'; `im_upper']"

pdslasso e3 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum e3 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_4.tex", keep(c.tmt_all) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, ///
	Mean of dep. variable, `control_mean', ///
	Lee 2009 Attrition Bounds, `lee_bounds', ///
	Imbens-Manski 2004 CS, `im_bounds', ///
	p-value: Romano-Wolf Correction, `rw_e3') ///
	append

	leebounds e4 tmt_all, level(90) cieffect tight() 
	local lee_lower = string(e(b)[1,1], "%15.3fc") // Lee (2009)
	local lee_upper = string(e(b)[1,2], "%15.3fc")
	local lee_bounds = "[`lee_lower'; `lee_upper']"	
	local im_lower = string(e(cilower), "%15.3fc") // Imbens-Manski (2004)
	local im_upper = string(e(ciupper), "%15.3fc")
	local im_bounds = "[`im_lower'; `im_upper']"
	
pdslasso e4 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum e4 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_4.tex", keep(c.tmt_all) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, ///
	Mean of dep. variable, `control_mean', ///
	Lee 2009 Attrition Bounds, `lee_bounds', ///
	Imbens-Manski 2004 CS, `im_bounds', ///
	p-value: Romano-Wolf Correction, `rw_e4') ///
	append

	leebounds e5 tmt_all, level(90) cieffect tight() 
	local lee_lower = string(e(b)[1,1], "%15.3fc") // Lee (2009)
	local lee_upper = string(e(b)[1,2], "%15.3fc")
	local lee_bounds = "[`lee_lower'; `lee_upper']"	
	local im_lower = string(e(cilower), "%15.3fc") // Imbens-Manski (2004)
	local im_upper = string(e(ciupper), "%15.3fc")
	local im_bounds = "[`im_lower'; `im_upper']"
	
pdslasso e5 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(districtX) ///
    rlasso
sum e5 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_4.tex", keep(c.tmt_all) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, ///
	Mean of dep. variable, `control_mean', ///
	Lee 2009 Attrition Bounds, `lee_bounds', ///
	Imbens-Manski 2004 CS, `im_bounds', ///
	p-value: Romano-Wolf Correction, `rw_e5') ///
	append title(" of communication credit on consumption expenditure - unsaturated")

*dyna fig
pdslasso totExp7days1 c.tmt_all#c.round1 c.tmt_all#c.round2 (i.districtX i.dateinterviewend totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt_all#c.round1 c.tmt_all#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(45) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt_all#c.round1="Endline (round 1): Assignment" c.tmt_all#c.round2="Endline (round 2): Assignment") title("Survey-level: consumption expenses (GHS)")
gr export "${replication_dir}/Output/Figures/figure_a7_1.eps", replace // meta_totExp7days
	
