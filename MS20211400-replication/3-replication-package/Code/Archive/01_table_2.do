/*
Table 2 and Figure A6
*/


set graphics off
***********************************
use "${replication_dir}/Data/03_clean/end1_end2.dta", replace	


	
**Comment: MHT Correction - The Romano-Wolf Multiple Hypothesis Correction
**Calculates Romano-Wolf stepdown adjusted p-values, which control the FWER and allows for dependence among p-values by bootstrap resampling
*NOTE:  The Romano-Wolf correction (asymptotically) controls the familywise error rate (FWER), that is, the probability of rejecting at least one true null hypothesis in a family of hypotheses under test (Clarke et al. 2020)

local y_list1 unableCall7days1 unableToCOVID1 digitborrow1 digitloan1
local y_list2 totExp7days1 c1 c2 e1 e2 e3 e4 e5
local y_list3 threatenPartner1 hitPartner1 logk101 severe_distress1
local t_list1 tmt_all
// local t_list2 tmt01 tmt02
 
foreach y_list in y_list1 y_list2 y_list3 { //  
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


** Table A7 (metaEffects_mitigate)
** meta Effects
** mitigate "unexpected" comm probl?
	leebounds unableCall7days1 tmt_all, level(90) cieffect tight() 
	local lee_lower = string(e(b)[1,1], "%15.3fc") // Lee (2009)
	local lee_upper = string(e(b)[1,2], "%15.3fc")
	local lee_bounds = "[`lee_lower'; `lee_upper']"	
	local im_lower = string(e(cilower), "%15.3fc") // Imbens-Manski (2004)
	local im_upper = string(e(ciupper), "%15.3fc")
	local im_bounds = "[`im_lower'; `im_upper']"
	
reg unableCall7days1 tmt_all, r cluster(districtX)
sum unableCall7days1 if tmt_all == 0
local control_mean = string(`r(mean)', "%15.3fc")

outreg2 using "${replication_dir}/Output/Tables/table_2.tex", keep(c.tmt_all) ///
	addtext(District FE, No, Date FE, No, Controls, None, ///
	Mean of dep. variable, `control_mean', ///
	Lee 2009 Attrition Bounds, `lee_bounds', ///
	Imbens-Manski 2004 CS, `im_bounds', ///
	p-value: Romano-Wolf Correction, `rw_unableCall7days1') ///
	replace tex(frag) label nocons

	
pdslasso unableCall7days1 tmt_all (i.districtX i.dateinterviewend unableCall7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum unableCall7days1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_2.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, PD LASSO, Mean of dep. variable, `control_mean') append tex(frag) label nocons
*dyna fig
pdslasso unableCall7days1 c.tmt_all#c.round1 c.tmt_all#c.round2 (i.districtX i.dateinterviewend unableCall7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt_all#c.round1 c.tmt_all#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(45) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt_all#c.round1="Endline (round 1): Assignment" c.tmt_all#c.round2="Endline (round 2): Assignment") title("Survey-level: unable to communicate or call in past 7 days 0-1", size(med))
gr export "${replication_dir}/Output/Figures/figure_a6_1.eps", replace // meta_unableCall7days

*robust-indivi-level clustering?
pdslasso unableCall7days1 tmt_all (i.districtX i.dateinterviewend unableCall7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
	
	
	leebounds unableToCOVID1 tmt_all, level(90) cieffect tight() 
	local lee_lower = string(e(b)[1,1], "%15.3fc") // Lee (2009)
	local lee_upper = string(e(b)[1,2], "%15.3fc")
	local lee_bounds = "[`lee_lower'; `lee_upper']"	
	local im_lower = string(e(cilower), "%15.3fc") // Imbens-Manski (2004)
	local im_upper = string(e(ciupper), "%15.3fc")
	local im_bounds = "[`im_lower'; `im_upper']"
	
reg unableToCOVID1 tmt_all, r cluster(districtX)
sum unableToCOVID1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_2.tex", keep(c.tmt_all) addtext(District FE, No, Date FE, No, Controls, None, Mean of dep. variable, `control_mean', Lee 2009 Attrition Bounds, `lee_bounds', Imbens-Manski 2004 CS, `im_bounds', p-value: Romano-Wolf Correction, `rw_unableToCOVID1') append tex(frag) label nocons
pdslasso unableToCOVID1 tmt_all (i.districtX i.dateinterviewend unableToCOVID female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum unableToCOVID1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_2.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, PD LASSO, Mean of dep. variable, `control_mean') append tex(frag) label nocons
*dyna fig
pdslasso unableToCOVID1 c.tmt_all#c.round1 c.tmt_all#c.round2 (i.districtX i.dateinterviewend unableToCOVID female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt_all#c.round1 c.tmt_all#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(45) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt_all#c.round1="Endline (round 1): Assignment" c.tmt_all#c.round2="Endline (round 2): Assignment") title("Survey-level: unable to communicate or call due to COVID19 0-1", size(med))
gr export "${replication_dir}/Output/Figures/figure_a6_2.eps", replace // meta_unableToCOVID
	
*robust-indivi-level clustering?
pdslasso unableToCOVID1 tmt_all (i.districtX i.dateinterviewend unableToCOVID female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
	
	
	leebounds digitborrow1 tmt_all, level(90) cieffect tight() 
	local lee_lower = string(e(b)[1,1], "%15.3fc") // Lee (2009)
	local lee_upper = string(e(b)[1,2], "%15.3fc")
	local lee_bounds = "[`lee_lower'; `lee_upper']"	
	local im_lower = string(e(cilower), "%15.3fc") // Imbens-Manski (2004)
	local im_upper = string(e(ciupper), "%15.3fc")
	local im_bounds = "[`im_lower'; `im_upper']"
	
reg digitborrow1 tmt_all, r cluster(districtX)
sum digitborrow1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_2.tex", keep(c.tmt_all) addtext(District FE, No, Date FE, No, Controls, None, Mean of dep. variable, `control_mean', Lee 2009 Attrition Bounds, `lee_bounds', Imbens-Manski 2004 CS, `im_bounds', p-value: Romano-Wolf Correction, `rw_digitborrow1') append tex(frag) label nocons
pdslasso digitborrow1 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum digitborrow1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_2.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, PD LASSO, Mean of dep. variable, `control_mean') append tex(frag) label nocons
*dyna fig
pdslasso digitborrow1 c.tmt_all#c.round1 c.tmt_all#c.round2 (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt_all#c.round1 c.tmt_all#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(45) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt_all#c.round1="Endline (round 1): Assignment" c.tmt_all#c.round2="Endline (round 2): Assignment") title("Survey-level: seek or borrow mobile credit 0-1")
gr export "${replication_dir}/Output/Figures/figure_a6_3.eps", replace // meta_digitborrow

*robust-indivi-level clustering?
pdslasso digitborrow1 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
	

	leebounds digitloan1 tmt_all, level(90) cieffect tight() 
	local lee_lower = string(e(b)[1,1], "%15.3fc") // Lee (2009)
	local lee_upper = string(e(b)[1,2], "%15.3fc")
	local lee_bounds = "[`lee_lower'; `lee_upper']"	
	local im_lower = string(e(cilower), "%15.3fc") // Imbens-Manski (2004)
	local im_upper = string(e(ciupper), "%15.3fc")
	local im_bounds = "[`im_lower'; `im_upper']"

reg digitloan1 tmt_all, r cluster(districtX)
sum digitloan1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_2.tex", keep(c.tmt_all) addtext(District FE, No, Date FE, No, Controls, None, Mean of dep. variable, `control_mean', Lee 2009 Attrition Bounds, `lee_bounds', Imbens-Manski 2004 CS, `im_bounds', p-value: Romano-Wolf Correction, `rw_digitloan1') append tex(frag) label nocons
pdslasso digitloan1 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum digitloan1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_2.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, PD LASSO, Mean of dep. variable, `control_mean') append title("Mitigation of communication constraints - unsaturated") tex(frag) label nocons
*dyna fig
pdslasso digitloan1 c.tmt_all#c.round1 c.tmt_all#c.round2 (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt_all#c.round1 c.tmt_all#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(45) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt_all#c.round1="Endline (round 1): Assignment" c.tmt_all#c.round2="Endline (round 2): Assignment") title("Survey-level: seek digital loan 0-1")
gr export "${replication_dir}/Output/Figures/figure_a6_4.eps", replace // meta_digitloan
	
*robust-indivi-level clustering?
pdslasso digitloan1 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
	