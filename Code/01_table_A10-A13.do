/*
Tables A10-A13
*/


***********************************
use "${replication_dir}/Data/03_clean/end1_end2.dta", replace	
cd "${replication_dir}/Output/Tables"

** bring this step in although it's also used to generate Fig A10
bys caseidx: gen xdif=totExp7days1[_n]-totExp7days1[_n-1]
bys caseidx: gen xgrowth=(xdif/totExp7days1[_n])*100
tab regionX
tab regionX, nolab
gen  previouslock =(regionX==3 | regionX==6)
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
// rwolf totExp7days1 c1 c2 e1 e2 e3 e4 e5, indepvar(tmt_all pov_likelihood jointPov) seed(124)
// rwolf threatenPartner1 hitPartner1 logk101 severe_distress1, indepvar(tmt_all jointPov) seed(124) //not estimable for all 3
//
// rwolf totExp7days1 c1 c2 e1 e2 e3 e4 e5, indepvar(tmt_all informal0 jointInf) seed(124)
// rwolf threatenPartner1 hitPartner1 logk101 severe_distress1, indepvar(tmt_all informal0 jointInf) seed(124)
//
// rwolf totExp7days1 c1 c2 e1 e2 e3 e4 e5, indepvar(tmt_all jointFem female0) seed(124)
// rwolf threatenPartner1 hitPartner1 logk101 severe_distress1, indepvar(tmt_all female0 jointFem) seed(124)
//
// rwolf totExp7days1 c1 c2 e1 e2 e3 e4 e5, indepvar(tmt_all previouslock jointLoc) seed(124)
// rwolf threatenPartner1 hitPartner1 logk101 severe_distress1, indepvar(tmt_all jointLoc) seed(124) //not estimable for all 3
/*(ii) SEparate?
rwolf unableCall7days1 unableToCOVID1 digitborrow1 digitloan1, indepvar(tmt01 tmt02) seed(124) //fam 1 (fist stage outcomes)
rwolf totExp7days1 c1 c2 e1 e2 e3 e4 e5, indepvar(tmt01 tmt02) seed(124) //fam 2 (second stage real impact outcomes - consumption)
rwolf threatenPartner1 hitPartner1 logk101 severe_distress1, indepvar(tmt01 tmt02) seed(124) //fam 3 (second stage real impact outcomes - mental health)
*/

**Reviewer #4 -- asking for more heterogeneity?
**(0) baseline mhealth0?
xtile logk10_quartile=logk10,n(4)
xtile threatenPartner_quart=threatenPartner,n(4)
xtile hitPartner_quart=hitPartner,n(4)
*use a/b median to avoid running out of empty cells in quartiles
sum k10, d
gen k10_high=(k10> r(p50))
sum threatenPartner, d
gen threatenPartner_high=(threatenPartner> r(p50))
sum hitPartner, d
gen hitPartner_high=(hitPartner> r(p50))
pdslasso totExp7days1 c.tmt_all##c.k10_high (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
pdslasso threatenPartner1 c.tmt_all##c.k10_high (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
pdslasso hitPartner1 c.tmt_all##c.k10_high (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
pdslasso logk101 c.tmt_all##c.k10_high (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
pdslasso severe_distress1 c.tmt_all##c.k10_high (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso	

	*baseline dv=threatened0?
pdslasso totExp7days1 c.tmt_all##c.threatenPartner_high (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
pdslasso threatenPartner1 c.tmt_all##c.threatenPartner_high (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
pdslasso hitPartner1 c.tmt_all##c.threatenPartner_high (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
pdslasso logk101 c.tmt_all##c.threatenPartner_high (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
pdslasso severe_distress1 c.tmt_all##c.threatenPartner_high (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso	
	
	*baseline dv=hit partner0?
pdslasso totExp7days1 c.tmt_all##c.hitPartner_high (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
pdslasso threatenPartner1 c.tmt_all##c.hitPartner_high (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
pdslasso hitPartner1 c.tmt_all##c.hitPartner_high (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
pdslasso logk101 c.tmt_all##c.hitPartner_high (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
pdslasso severe_distress1 c.tmt_all##c.hitPartner_high (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso	
	
	
	
	
** Table A10
**(1)poverty? evidence: the modest DV reduction is sig more on the very poor (similarly for mental health but ns)
pdslasso totExp7days1 c.tmt_all##c.pov_likelihood (i.districtX i.dateinterviewend totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum totExp7days1 if tmt_all==0
outreg2 using "metaEffects_Xpoverty.tex", keep(c.tmt_all c.pov_likelihood c.tmt_all#c.pov_likelihood) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') replace

pdslasso threatenPartner1 c.tmt_all##c.pov_likelihood (i.districtX i.dateinterviewend threatenPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum threatenPartner1 if tmt_all==0
outreg2 using "metaEffects_Xpoverty.tex", keep(c.tmt_all c.pov_likelihood c.tmt_all#c.pov_likelihood) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

pdslasso hitPartner1 c.tmt_all##c.pov_likelihood (i.districtX i.dateinterviewend hitPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum hitPartner1 if tmt_all==0
outreg2 using "metaEffects_Xpoverty.tex", keep(c.tmt_all c.pov_likelihood c.tmt_all#c.pov_likelihood) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

pdslasso logk101 c.tmt_all##c.pov_likelihood (i.districtX i.dateinterviewend logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum logk101 if tmt_all==0
outreg2 using "metaEffects_Xpoverty.tex", keep(c.tmt_all c.pov_likelihood c.tmt_all#c.pov_likelihood) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

pdslasso severe_distress1 c.tmt_all##c.pov_likelihood (i.districtX i.dateinterviewend severe_distress female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum severe_distress if tmt_all==0
outreg2 using "metaEffects_Xpoverty.tex", keep(c.tmt_all c.pov_likelihood c.tmt_all#c.pov_likelihood) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append


** Table A11
**(2)informal0? evidence: those in informal sector experienced large/better-sig mental health effects
pdslasso totExp7days1 c.tmt_all##c.informal0 (i.districtX i.dateinterviewend totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum totExp7days1 if tmt_all==0
outreg2 using "metaEffects_Xinformal.tex", keep(c.tmt_all c.informal0 c.tmt_all#c.informal0) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') replace

pdslasso threatenPartner1 c.tmt_all##c.informal0 (i.districtX i.dateinterviewend threatenPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0  incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum threatenPartner1 if tmt_all==0
outreg2 using "metaEffects_Xinformal.tex", keep(c.tmt_all c.informal0 c.tmt_all#c.informal0) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

pdslasso hitPartner1 c.tmt_all##c.informal0 (i.districtX i.dateinterviewend hitPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0  incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum hitPartner1 if tmt_all==0
outreg2 using "metaEffects_Xinformal.tex", keep(c.tmt_all c.informal0 c.tmt_all#c.informal0) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

pdslasso logk101 c.tmt_all##c.informal0 (i.districtX i.dateinterviewend logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0  incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum logk101 if tmt_all==0
outreg2 using "metaEffects_Xinformal.tex", keep(c.tmt_all c.informal0 c.tmt_all#c.informal0) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

pdslasso severe_distress1 c.tmt_all##c.pov_likelihood (i.districtX i.dateinterviewend severe_distress female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0  incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum severe_distress if tmt_all==0
outreg2 using "metaEffects_Xinformal.tex", keep(c.tmt_all c.informal0 c.tmt_all#c.informal0) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

	
	
** Table A12
**(3)female/gender? evidence: females experienced "slightly" (ns, but) better mental health effects
pdslasso totExp7days1 c.tmt_all##c.female0 (i.districtX i.dateinterviewend totExp7days akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum totExp7days1 if tmt_all==0
outreg2 using "metaEffects_Xfemale.tex", keep(c.tmt_all c.female0 c.tmt_all#c.female0) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') replace

pdslasso threatenPartner1 c.tmt_all##c.female0 (i.districtX i.dateinterviewend threatenPartner akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum threatenPartner1 if tmt_all==0
outreg2 using "metaEffects_Xfemale.tex", keep(c.tmt_all c.female0 c.tmt_all#c.female0) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

pdslasso hitPartner1 c.tmt_all##c.female0 (i.districtX i.dateinterviewend hitPartner akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum hitPartner1 if tmt_all==0
outreg2 using "metaEffects_Xfemale.tex", keep(c.tmt_all c.female0 c.tmt_all#c.female0) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

pdslasso logk101 c.tmt_all##c.female0 (i.districtX i.dateinterviewend logk10 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum logk101 if tmt_all==0
outreg2 using "metaEffects_Xfemale.tex", keep(c.tmt_all c.female0 c.tmt_all#c.female0) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

pdslasso severe_distress1 c.tmt_all##c.female0 (i.districtX i.dateinterviewend severe_distress akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum severe_distress if tmt_all==0
outreg2 using "metaEffects_Xfemale.tex", keep(c.tmt_all c.female0 c.tmt_all#c.female0) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append


** Table A13
**(4)region: never-lock vs no previously-lock = so might still be battling (direct) econ ? evidence: eager to re-allocate their budgets to more consumption (utilities and durables, as expected)
pdslasso totExp7days1 c.tmt_all##c.previouslock (i.districtX i.dateinterviewend totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum totExp7days1 if tmt_all==0
outreg2 using "metaEffects_Xlockeddown.tex", keep(c.tmt_all c.previouslock c.tmt_all#c.previouslock) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') replace

pdslasso threatenPartner1 c.tmt_all##c.previouslock (i.districtX i.dateinterviewend threatenPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum threatenPartner1 if tmt_all==0
outreg2 using "metaEffects_Xlockeddown.tex", keep(c.tmt_all c.previouslock c.tmt_all#c.previouslock) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

pdslasso hitPartner1 c.tmt_all##c.previouslock (i.districtX i.dateinterviewend hitPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum hitPartner1 if tmt_all==0
outreg2 using "metaEffects_Xlockeddown.tex", keep(c.tmt_all c.previouslock c.tmt_all#c.previouslock) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

pdslasso logk101 c.tmt_all##c.previouslock (i.districtX i.dateinterviewend logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum logk101 if tmt_all==0
outreg2 using "metaEffects_Xlockeddown.tex", keep(c.tmt_all c.previouslock c.tmt_all#c.previouslock) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

pdslasso severe_distress1 c.tmt_all##c.previouslock (i.districtX i.dateinterviewend severe_distress female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum severe_distress if tmt_all==0
outreg2 using "metaEffects_Xlockeddown.tex", keep(c.tmt_all c.previouslock c.tmt_all#c.previouslock) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append



	
	
**self employed? evidence: none
pdslasso totExp7days1 c.tmt_all##c.selfEmploy0 (i.districtX i.dateinterviewend totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(districtX) ///
    rlasso
pdslasso threatenPartner1 c.tmt_all##c.selfEmploy0 (i.districtX i.dateinterviewend threatenPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(districtX) ///
    rlasso
pdslasso hitPartner1 c.tmt_all##c.selfEmploy0 (i.districtX i.dateinterviewend hitPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(districtX) ///
    rlasso
pdslasso logk101 c.tmt_all##c.selfEmploy0 (i.districtX i.dateinterviewend logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(districtX) ///
    rlasso
pdslasso severe_distress1 c.tmt_all##c.selfEmploy0 (i.districtX i.dateinterviewend severe_distress female0 akan0 married0 ageYrs0 jhs0 hhsize0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(districtX) ///
    rlasso
	
**self: does housework? evidence: none
pdslasso totExp7days1 c.tmt_all##c.self_hseWork0 (i.districtX i.dateinterviewend totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(districtX) ///
    rlasso
pdslasso threatenPartner1 c.tmt_all##c.self_hseWork0 (i.districtX i.dateinterviewend threatenPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(districtX) ///
    rlasso
pdslasso hitPartner1 c.tmt_all##c.self_hseWork0 (i.districtX i.dateinterviewend hitPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(districtX) ///
    rlasso
pdslasso logk101 c.tmt_all##c.self_hseWork0 (i.districtX i.dateinterviewend logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(districtX) ///
    rlasso
pdslasso severe_distress1 c.tmt_all##c.self_hseWork0 (i.districtX i.dateinterviewend severe_distress female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(districtX) ///
    rlasso

	
	