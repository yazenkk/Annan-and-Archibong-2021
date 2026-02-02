/*
Table 5 and reviewer comments 4-5
Figure A7, graphs 2-5
*/

eststo clear
set seed $project_seed

***********************************
use "${replication_dir}/Data/03_clean/end1_end2.dta", clear	


**Comment: MHT Correction - The Romano-Wolf Multiple Hypothesis Correction
// local y_list1 unableCall7days1 unableToCOVID1 digitborrow1 digitloan1
// local y_list2 totExp7days1 c1 c2 e1 e2 e3 e4 e5
local y_list3 threatenPartner1 hitPartner1 logk101 severe_distress1
local t_list1 tmt_all
// local t_list2 tmt01 tmt02
 
foreach y_list in y_list3 { // y_list1 y_list2
	foreach t_list in t_list1 { // t_list2
	
		** more reps for some tests
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


** Table A9 (metaEffects_dv_mhealth)
**dV
	leebounds threatenPartner1 tmt_all, level(90) cieffect tight() 
	local lee_lower = string(e(b)[1,1], "%15.3fc") // Lee (2009)
	local lee_upper = string(e(b)[1,2], "%15.3fc")
	local lee_bounds = "[`lee_lower'; `lee_upper']"	
	local im_lower = string(e(cilower), "%15.3fc") // Imbens-Manski (2004)
	local im_upper = string(e(ciupper), "%15.3fc")
	local im_bounds = "[`im_lower'; `im_upper']"
	
eststo: reg threatenPartner1 tmt_all, r cluster(districtX)
sum threatenPartner1 if tmt_all==0
estadd local control_mean = string(`r(mean)', "%15.3fc"), replace
estadd local district_FE "No", replace
estadd local survey_FE   "No", replace
estadd local controls    "None", replace
estadd local rw_stat `rw_threatenPartner1', replace
estadd local lee_bounds `lee_bounds', replace
estadd local im_bounds `im_bounds', replace
	
eststo: pdslasso threatenPartner1 tmt_all (i.districtX i.dateinterviewend threatenPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum threatenPartner1 if tmt_all==0
estadd local control_mean = string(`r(mean)', "%15.3fc"), replace
estadd local district_FE "Yes", replace
estadd local survey_FE   "Yes", replace
estadd local controls    "PD Lasso", replace
estadd local rw_stat "", replace
estadd local lee_bounds "", replace
estadd local im_bounds "", replace
	
*dyna fig
pdslasso threatenPartner1 c.tmt_all#c.round1 c.tmt_all#c.round2 (i.districtX i.dateinterviewend threatenPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt_all#c.round1 c.tmt_all#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(45) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt_all#c.round1="Endline (round 1): Assignment" c.tmt_all#c.round2="Endline (round 2): Assignment") title("Survey-level: threatened partner 1-4")
gr export "${replication_dir}/Output/Figures/figure_a7_2.eps", replace // meta_threatenPartner

*robust-indivi-level clustering?
pdslasso threatenPartner1 tmt_all (i.districtX i.dateinterviewend threatenPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
	
	
	leebounds hitPartner1 tmt_all, level(90) cieffect tight() 
	local lee_lower = string(e(b)[1,1], "%15.3fc") // Lee (2009)
	local lee_upper = string(e(b)[1,2], "%15.3fc")
	local lee_bounds = "[`lee_lower'; `lee_upper']"	
	local im_lower = string(e(cilower), "%15.3fc") // Imbens-Manski (2004)
	local im_upper = string(e(ciupper), "%15.3fc")
	local im_bounds = "[`im_lower'; `im_upper']"
	
eststo: reg hitPartner1 tmt_all, r cluster(districtX)
sum hitPartner1 if tmt_all==0 
estadd local control_mean = string(`r(mean)', "%15.3fc"), replace
estadd local district_FE "No", replace
estadd local survey_FE   "No", replace
estadd local controls    "None", replace
estadd local rw_stat `rw_hitPartner1', replace
estadd local lee_bounds `lee_bounds', replace
estadd local im_bounds `im_bounds', replace
	
eststo: pdslasso hitPartner1 tmt_all (i.districtX i.dateinterviewend hitPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum hitPartner1 if tmt_all==0 
estadd local control_mean = string(`r(mean)', "%15.3fc"), replace
estadd local district_FE "Yes", replace
estadd local survey_FE   "Yes", replace
estadd local controls    "PD Lasso", replace
estadd local rw_stat "", replace
estadd local lee_bounds "", replace
estadd local im_bounds "", replace
	
*dyna fig
pdslasso hitPartner1 c.tmt_all#c.round1 c.tmt_all#c.round2 (i.districtX i.dateinterviewend hitPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt_all#c.round1 c.tmt_all#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(45) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt_all#c.round1="Endline (round 1): Assignment" c.tmt_all#c.round2="Endline (round 2): Assignment") title("Survey-level: hit partner 1-4")
gr export "${replication_dir}/Output/Figures/figure_a7_3.eps", replace // meta_hitPartner
	
*robust-indivi-level clustering?
pdslasso hitPartner1 tmt_all (i.districtX i.dateinterviewend hitPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso	

	
**mH
	leebounds logk101 tmt_all, level(90) cieffect tight() 
	local lee_lower = string(e(b)[1,1], "%15.3fc") // Lee (2009)
	local lee_upper = string(e(b)[1,2], "%15.3fc")
	local lee_bounds = "[`lee_lower'; `lee_upper']"	
	local im_lower = string(e(cilower), "%15.3fc") // Imbens-Manski (2004)
	local im_upper = string(e(ciupper), "%15.3fc")
	local im_bounds = "[`im_lower'; `im_upper']"
	
eststo: reg logk101 tmt_all, r cluster(districtX)
sum logk101 if tmt_all==0
estadd local control_mean = string(`r(mean)', "%15.3fc"), replace
estadd local district_FE "No", replace
estadd local survey_FE   "No", replace
estadd local controls    "None", replace
estadd local rw_stat `rw_logk101', replace
estadd local lee_bounds `lee_bounds', replace
estadd local im_bounds `im_bounds', replace
	
eststo: pdslasso logk101 tmt_all (i.districtX i.dateinterviewend logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum logk101 if tmt_all==0
estadd local control_mean = string(`r(mean)', "%15.3fc"), replace
estadd local district_FE "Yes", replace
estadd local survey_FE   "Yes", replace
estadd local controls    "PD Lasso", replace
estadd local rw_stat "", replace
estadd local lee_bounds "", replace
estadd local im_bounds "", replace
	
*dyna fig
pdslasso logk101 c.tmt_all#c.round1 c.tmt_all#c.round2 (i.districtX i.dateinterviewend logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt_all#c.round1 c.tmt_all#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(45) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt_all#c.round1="Endline (round 1): Assignment" c.tmt_all#c.round2="Endline (round 2): Assignment") title("Survey-level: logK10")
gr export "${replication_dir}/Output/Figures/figure_a7_4.eps", replace // meta_logk10

*robust-indivi-level clustering?
pdslasso logk101 tmt_all (i.districtX i.dateinterviewend logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso	

	leebounds severe_distress1 tmt_all, level(90) cieffect tight() 	
	local lee_lower = string(e(b)[1,1], "%15.3fc") // Lee (2009)
	local lee_upper = string(e(b)[1,2], "%15.3fc")
	local lee_bounds = "[`lee_lower'; `lee_upper']"	
	local im_lower = string(e(cilower), "%15.3fc") // Imbens-Manski (2004)
	local im_upper = string(e(ciupper), "%15.3fc")
	local im_bounds = "[`im_lower'; `im_upper']"
	
eststo: reg severe_distress1 tmt_all, r cluster(districtX)
sum severe_distress1 if tmt_all==0
estadd local control_mean = string(`r(mean)', "%15.3fc"), replace
estadd local district_FE "No", replace
estadd local survey_FE   "No", replace
estadd local controls    "None", replace
estadd local rw_stat `rw_severe_distress1', replace
estadd local lee_bounds `lee_bounds', replace
estadd local im_bounds `im_bounds', replace
	
eststo: pdslasso severe_distress1 tmt_all (i.districtX i.dateinterviewend severe_distress female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0) , ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum severe_distress1 if tmt_all==0
estadd local control_mean = string(`r(mean)', "%15.3fc"), replace
estadd local district_FE "Yes", replace
estadd local survey_FE   "Yes", replace
estadd local controls    "PD Lasso", replace
estadd local rw_stat "", replace
estadd local lee_bounds "", replace
estadd local im_bounds "", replace

*dyna fig
pdslasso severe_distress1 c.tmt_all#c.round1 c.tmt_all#c.round2 (i.districtX i.dateinterviewend severe_distress female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt_all#c.round1 c.tmt_all#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(45) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt_all#c.round1="Endline (round 1): Assignment" c.tmt_all#c.round2="Endline (round 2): Assignment") title("Survey-level: severe distress 0-1")
gr export "${replication_dir}/Output/Figures/figure_a7_5.eps", replace // meta_severe_distress


esttab using "${replication_dir}/Output/Tables/table_5_esttab.tex", ///
	keep(tmt_all) 										///
	style(tex)											///
	nogaps												///
	nobaselevels 										///
	noconstant											///
	label            									///
	varwidth(50)										///
	wrap 												///
	nomtitles /// mlabels(`mylabels')					///
	mgroups("Threatened Partner 1-4" "Hit Partner 1-4" 	///
			"log K10" "Severe Distress 0-1", 			///
			pattern(1 0 1 0 1 0 1 0)  					///
			prefix(\multicolumn{@span}{c}{) 			///
			suffix(}) span							  	///
			erepeat(\cmidrule(lr){@span})) 				///
	cells (b(fmt(3) star) se(fmt(3) par)) 				///
	stats(N 											///
		  district_FE									///
		  survey_FE 									///
		  controls  									///
		  control_mean 									///
		  lee_bounds 									///
		  im_bounds 									///
		  rw_stat, 									 	///
		  fmt(%9.0f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f) ///
		  labels("Observations"					 		///
				 "District FE" ///
				 "Survey Date FE" ///
				 "Controls" 	  ///
				 "Mean of dep. variable (control)" ///
				 "Lee 2009 Attrition Bounds" ///
				 "Imbens-Manski 2004" ///
				 "p-value: Romano-Wolf Correction" )) ///
	replace

