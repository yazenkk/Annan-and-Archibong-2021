/*
Table 5 and reviewer comments 4-5
Figure A7, graphs 2-5
*/


***********************************
use "${replication_dir}/Data/03_clean/end1_end2.dta", replace	


**Comment: MHT Correction - The Romano-Wolf Multiple Hypothesis Correction
// local y_list1 unableCall7days1 unableToCOVID1 digitborrow1 digitloan1
// local y_list2 totExp7days1 c1 c2 e1 e2 e3 e4 e5
local y_list3 threatenPartner1 hitPartner1 logk101 severe_distress1
local t_list1 tmt_all
// local t_list2 tmt01 tmt02
 
foreach y_list in y_list3 { // y_list1 y_list2
	foreach t_list in t_list1 { // t_list2
	
		** more reps for some tests
		local reps_option "reps(499)"
		
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
	
reg threatenPartner1 tmt_all, r cluster(districtX)
sum threatenPartner1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_5.tex", keep(c.tmt_all) ///
	addtext(District FE, No, Date FE, No, Controls, None, ///
	Mean of dep. variable, `control_mean', ///
	Lee 2009 Attrition Bounds, `lee_bounds', ///
	Imbens-Manski 2004 CS, `im_bounds', ///
	p-value: Romano-Wolf Correction, `rw_threatenPartner1') ///
	replace
	
pdslasso threatenPartner1 tmt_all (i.districtX i.dateinterviewend threatenPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum threatenPartner1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_5.tex", keep(c.tmt_all) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, ///
	Mean of dep. variable, `control_mean') ///
	append title(" of communication credit on domestic voilence and mental meaalth - unsaturated")
	
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
	
reg hitPartner1 tmt_all, r cluster(districtX)
sum hitPartner1 if tmt_all==0 
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_5.tex", keep(c.tmt_all) ///
	addtext(District FE, No, Date FE, No, Controls, None, ///
	Mean of dep. variable, `control_mean', ///
	Lee 2009 Attrition Bounds, `lee_bounds', ///
	Imbens-Manski 2004 CS, `im_bounds', ///
	p-value: Romano-Wolf Correction, `rw_hitPartner1') ///
	append
	
pdslasso hitPartner1 tmt_all (i.districtX i.dateinterviewend hitPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum hitPartner1 if tmt_all==0 
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_5.tex", keep(c.tmt_all) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, ///
	Mean of dep. variable, `control_mean') ///
	append
	
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
	
reg logk101 tmt_all, r cluster(districtX)
sum logk101 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_5.tex", keep(c.tmt_all) ///
	addtext(District FE, No, Date FE, No, Controls, None, ///
	Mean of dep. variable, `control_mean', ///
	Lee 2009 Attrition Bounds, `lee_bounds', ///
	Imbens-Manski 2004 CS, `im_bounds', ///
	p-value: Romano-Wolf Correction, `rw_logk101') ///
	append
	
pdslasso logk101 tmt_all (i.districtX i.dateinterviewend logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum logk101 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_5.tex", keep(c.tmt_all) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, ///
	Mean of dep. variable, `control_mean') ///
	append
	
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
	
reg severe_distress1 tmt_all, r cluster(districtX)
sum severe_distress1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_5.tex", keep(c.tmt_all) ///
	addtext(District FE, No, Date FE, No, Controls, None, ///
	Mean of dep. variable, `control_mean', ///
	Lee 2009 Attrition Bounds, `lee_bounds', ///
	Imbens-Manski 2004 CS, `im_bounds', ///
	p-value: Romano-Wolf Correction, `rw_severe_distress1') ///
	append
	
pdslasso severe_distress1 tmt_all (i.districtX i.dateinterviewend severe_distress female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0) , ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum severe_distress1 if tmt_all==0
local control_mean = string(`r(mean)', "%15.3fc")
outreg2 using "${replication_dir}/Output/Tables/table_5.tex", keep(c.tmt_all) ///
	addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, ///
	Mean of dep. variable, `control_mean') ///
	append

*dyna fig
pdslasso severe_distress1 c.tmt_all#c.round1 c.tmt_all#c.round2 (i.districtX i.dateinterviewend severe_distress female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt_all#c.round1 c.tmt_all#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(45) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt_all#c.round1="Endline (round 1): Assignment" c.tmt_all#c.round2="Endline (round 2): Assignment") title("Survey-level: severe distress 0-1")
gr export "${replication_dir}/Output/Figures/figure_a7_5.eps", replace // meta_severe_distress

*robust-indivi-level clustering?
pdslasso severe_distress1 tmt_all (i.districtX i.dateinterviewend severe_distress female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso	
	
**Reviewer #4 (robustness of log consump) + #3 (robustness of util/durables consump):
*Try log (consumption), log(e1, e5), results still there?
*try drop outliers -- To account for outliers, 
**we trimmed the utilities/durables consumption data at both the 1% and 5% levels, still sig
**however, when we take log of utilities/durables consumption, the results are insignificance
**we conclude that, the bseline effects on utilities/durables consumption are inconclusive
gen logtotExp7days1 = log(totExp7days1) 
gen loge1 = log(e1) //utilities
sum e1, d
gen trim1pctE1=e1 if e1>=r(p1) & e1<=r(p99)
gen trim5pctE1=e1 if e1>=r(p5) & e1<=r(p95)
gen loge5 = log(e5) //durables
sum e5, d
gen trim1pctE5=e5 if e5>=r(p1) & e5<=r(p99)
gen trim5pctE5=e5 if e5>=r(p5) & e5<=r(p95)


reg totExp7days1 tmt_all, r cluster(districtX) //not sig
reg logtotExp7days1 tmt_all, r cluster(districtX) //not sig
reg e1 tmt_all, r cluster(districtX) //sig
reg loge1 tmt_all, r cluster(districtX) //not sig
reg trim1pctE1 tmt_all, r cluster(districtX) //sig
reg trim5pctE1 tmt_all, r cluster(districtX) //sig

reg e5 tmt_all, r cluster(districtX) //sig
reg loge5 tmt_all, r cluster(districtX) //not sig
reg trim1pctE5 tmt_all, r cluster(districtX) //sig
reg trim5pctE5 tmt_all, r cluster(districtX) //sig

**Reviewer #1: baseline differences in DV/hit rates
*baseline?
bys female0: sum threatenPartner hitPartner
*hit: 1.19/4(m) vs 1.16/4(f) but insignificant (p-val=0.464)
ttest hitPartner, by(female0)
*endline?
bys female0: sum threatenPartner1 hitPartner1
*hit: 1.15/4(m) vs 1.09/4(f) but (in) sig at 13% (pval=1.124)
ttest hitPartner1, by(female0)

bys female0: sum k101
ttest k101, by(female0)


**Reviewer #$: hetero wrt baseline mh quartiles?
xtile quartMH = k10, nq(4)
pdslasso logk101 c.tmt_all#c.round1 c.tmt_all#c.round2 (i.districtX i.dateinterviewend logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt_all#c.round1 c.tmt_all#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(45) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt_all#c.round1="Endline (round 1): Assignment" c.tmt_all#c.round2="Endline (round 2): Assignment") title("Survey-level: logK10")

