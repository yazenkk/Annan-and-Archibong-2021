

***********************************
use "${replication_dir}/Data/03_clean/end1_end2.dta", replace

	
	
	
cd "${replication_dir}/Output"

	
**Comment: MHT Correction - The Romano-Wolf Multiple Hypothesis Correction
**Calculates Romano-Wolf stepdown adjusted p-values, which control the FWER and allows for dependence among p-values by bootstrap resampling
*NOTE:  The Romano-Wolf correction (asymptotically) controls the familywise error rate (FWER), that is, the probability of rejecting at least one true null hypothesis in a family of hypotheses under test (Clarke et al. 2020)
*(i) MEta?
// rwolf unableCall7days1 unableToCOVID1 digitborrow1 digitloan1, indepvar(tmt_all) seed(124) reps(499) //fam 1 (fist stage outcomes)
// rwolf totExp7days1 c1 c2 e1 e2 e3 e4 e5, indepvar(tmt_all) seed(124) reps(499) //fam 2 (second stage real impact outcomes)
// rwolf threatenPartner1 hitPartner1 logk101 severe_distress1, indepvar(tmt_all) seed(124) //fam 3 (second stage real impact outcomes)
// *(ii) SEparate?
// rwolf unableCall7days1 unableToCOVID1 digitborrow1 digitloan1, indepvar(tmt01 tmt02) seed(124) //fam 1 (fist stage outcomes)
// rwolf totExp7days1 c1 c2 e1 e2 e3 e4 e5, indepvar(tmt01 tmt02) seed(124) //fam 2 (second stage real impact outcomes - consumption)
// rwolf threatenPartner1 hitPartner1 logk101 severe_distress1, indepvar(tmt01 tmt02) seed(124) //fam 3 (second stage real impact outcomes - mental health)



** Table A7
**meta Effects
**mitigate "unexpected" comm probl?
	leebounds unableCall7days1 tmt_all, level(90) cieffect tight() 
reg unableCall7days1 tmt_all, r cluster(districtX)
sum unableCall7days1 if tmt_all==0
outreg2 using "metaEffects_mitigate.tex", keep(c.tmt_all) addtext(District FE, No, Date FE, No, Controls, None, Mean of dep. variable, `r(mean)') replace
pdslasso unableCall7days1 tmt_all (i.districtX i.dateinterviewend unableCall7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum unableCall7days1 if tmt_all==0
outreg2 using "metaEffects_mitigate.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append
*dyna fig
pdslasso unableCall7days1 c.tmt_all#c.round1 c.tmt_all#c.round2 (i.districtX i.dateinterviewend unableCall7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt_all#c.round1 c.tmt_all#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(45) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt_all#c.round1="Endline (round 1): Assignment" c.tmt_all#c.round2="Endline (round 2): Assignment") title("Survey-level: unable to communicate or call in past 7 days 0-1", size(med))
gr export "meta_unableCall7days.eps", replace

*robust-indivi-level clustering?
pdslasso unableCall7days1 tmt_all (i.districtX i.dateinterviewend unableCall7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
	
	
	leebounds unableToCOVID1 tmt_all, level(90) cieffect tight() 
reg unableToCOVID1 tmt_all, r cluster(districtX)
sum unableToCOVID1 if tmt_all==0
outreg2 using "metaEffects_mitigate.tex", keep(c.tmt_all) addtext(District FE, No, Date FE, No, Controls, None, Mean of dep. variable, `r(mean)') append
pdslasso unableToCOVID1 tmt_all (i.districtX i.dateinterviewend unableToCOVID female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum unableToCOVID1 if tmt_all==0
outreg2 using "metaEffects_mitigate.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append
*dyna fig
pdslasso unableToCOVID1 c.tmt_all#c.round1 c.tmt_all#c.round2 (i.districtX i.dateinterviewend unableToCOVID female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt_all#c.round1 c.tmt_all#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(45) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt_all#c.round1="Endline (round 1): Assignment" c.tmt_all#c.round2="Endline (round 2): Assignment") title("Survey-level: unable to communicate or call due to COVID19 0-1", size(med))
gr export "meta_unableToCOVID.eps", replace
	
*robust-indivi-level clustering?
pdslasso unableToCOVID1 tmt_all (i.districtX i.dateinterviewend unableToCOVID female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
	
	
	leebounds digitborrow1 tmt_all, level(90) cieffect tight() 
reg digitborrow1 tmt_all, r cluster(districtX)
sum digitborrow1 if tmt_all==0
outreg2 using "metaEffects_mitigate.tex", keep(c.tmt_all) addtext(District FE, No, Date FE, No, Controls, None, Mean of dep. variable, `r(mean)') append
pdslasso digitborrow1 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum digitborrow1 if tmt_all==0
outreg2 using "metaEffects_mitigate.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append
*dyna fig
pdslasso digitborrow1 c.tmt_all#c.round1 c.tmt_all#c.round2 (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt_all#c.round1 c.tmt_all#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(45) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt_all#c.round1="Endline (round 1): Assignment" c.tmt_all#c.round2="Endline (round 2): Assignment") title("Survey-level: seek or borrow mobile credit 0-1")
gr export "meta_digitborrow.eps", replace

*robust-indivi-level clustering?
pdslasso digitborrow1 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
	

	leebounds digitloan1 tmt_all, level(90) cieffect tight() 
reg digitloan1 tmt_all, r cluster(districtX)
sum digitloan1 if tmt_all==0
outreg2 using "metaEffects_mitigate.tex", keep(c.tmt_all) addtext(District FE, No, Date FE, No, Controls, None, Mean of dep. variable, `r(mean)') append
pdslasso digitloan1 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum digitloan1 if tmt_all==0
outreg2 using "metaEffects_mitigate.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append title("Mitigation of communication constraints - unsaturated")
*dyna fig
pdslasso digitloan1 c.tmt_all#c.round1 c.tmt_all#c.round2 (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt_all#c.round1 c.tmt_all#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(45) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt_all#c.round1="Endline (round 1): Assignment" c.tmt_all#c.round2="Endline (round 2): Assignment") title("Survey-level: seek digital loan 0-1")
gr export "meta_digitloan.eps", replace
	
*robust-indivi-level clustering?
pdslasso digitloan1 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
	
	
	
**expenditure Shifts [resource reallocation effect]?
	leebounds totExp7days1 tmt_all, level(90) cieffect tight() 
pdslasso totExp7days1 tmt_all (i.districtX i.dateinterviewend totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum totExp7days1 if tmt_all==0
outreg2 using "metaEffects_consume.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') replace

	leebounds c1 tmt_all, level(90) cieffect tight() 
pdslasso c1 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum c1 if tmt_all==0
outreg2 using "metaEffects_consume.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

	leebounds c2 tmt_all, level(90) cieffect tight() 
pdslasso c2 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum c2 if tmt_all==0
outreg2 using "metaEffects_consume.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

	leebounds e1 tmt_all, level(90) cieffect tight() 
pdslasso e1 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum e1 if tmt_all==0
outreg2 using "metaEffects_consume.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

	leebounds e2 tmt_all, level(90) cieffect tight() 
pdslasso e2 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum e2 if tmt_all==0
outreg2 using "metaEffects_consume.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

	leebounds e3 tmt_all, level(90) cieffect tight() 
pdslasso e3 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum e3 if tmt_all==0
outreg2 using "metaEffects_consume.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

	leebounds e4 tmt_all, level(90) cieffect tight() 
pdslasso e4 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum e4 if tmt_all==0
outreg2 using "metaEffects_consume.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

	leebounds e5 tmt_all, level(90) cieffect tight() 
pdslasso e5 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(districtX) ///
    rlasso
sum e5 if tmt_all==0
outreg2 using "metaEffects_consume.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append title(" of communication credit on consumption expenditure - unsaturated")

*dyna fig
pdslasso totExp7days1 c.tmt_all#c.round1 c.tmt_all#c.round2 (i.districtX i.dateinterviewend totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt_all#c.round1 c.tmt_all#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(45) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt_all#c.round1="Endline (round 1): Assignment" c.tmt_all#c.round2="Endline (round 2): Assignment") title("Survey-level: consumption expenses (GHS)")
gr export "meta_totExp7days.eps", replace
	
	
**dV
	leebounds threatenPartner1 tmt_all, level(90) cieffect tight() 
pdslasso threatenPartner1 tmt_all (i.districtX i.dateinterviewend threatenPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum threatenPartner1 if tmt_all==0
outreg2 using "metaEffects_dv_mhealth.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') replace
*dyna fig
pdslasso threatenPartner1 c.tmt_all#c.round1 c.tmt_all#c.round2 (i.districtX i.dateinterviewend threatenPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt_all#c.round1 c.tmt_all#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(45) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt_all#c.round1="Endline (round 1): Assignment" c.tmt_all#c.round2="Endline (round 2): Assignment") title("Survey-level: threatened partner 1-4")
gr export "meta_threatenPartner.eps", replace

*robust-indivi-level clustering?
pdslasso threatenPartner1 tmt_all (i.districtX i.dateinterviewend threatenPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
	
	

	leebounds hitPartner1 tmt_all, level(90) cieffect tight() 
pdslasso hitPartner1 tmt_all (i.districtX i.dateinterviewend hitPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum hitPartner1 if tmt_all==0 
outreg2 using "metaEffects_dv_mhealth.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append
*dyna fig
pdslasso hitPartner1 c.tmt_all#c.round1 c.tmt_all#c.round2 (i.districtX i.dateinterviewend hitPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt_all#c.round1 c.tmt_all#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(45) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt_all#c.round1="Endline (round 1): Assignment" c.tmt_all#c.round2="Endline (round 2): Assignment") title("Survey-level: hit partner 1-4")
gr export "meta_hitPartner.eps", replace
	
*robust-indivi-level clustering?
pdslasso hitPartner1 tmt_all (i.districtX i.dateinterviewend hitPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso	

	
**mH
	leebounds logk101 tmt_all, level(90) cieffect tight() 
pdslasso logk101 tmt_all (i.districtX i.dateinterviewend logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum logk101 if tmt_all==0
outreg2 using "metaEffects_dv_mhealth.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append
*dyna fig
pdslasso logk101 c.tmt_all#c.round1 c.tmt_all#c.round2 (i.districtX i.dateinterviewend logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt_all#c.round1 c.tmt_all#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(45) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt_all#c.round1="Endline (round 1): Assignment" c.tmt_all#c.round2="Endline (round 2): Assignment") title("Survey-level: logK10")
gr export "meta_logk10.eps", replace

*robust-indivi-level clustering?
pdslasso logk101 tmt_all (i.districtX i.dateinterviewend logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso	

	leebounds severe_distress1 tmt_all, level(90) cieffect tight() 	
pdslasso severe_distress1 tmt_all (i.districtX i.dateinterviewend severe_distress female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0) , ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum severe_distress if tmt_all==0
outreg2 using "metaEffects_dv_mhealth.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append title(" of communication credit on domestic voilence and mental meaalth - unsaturated")

*dyna fig
pdslasso severe_distress1 c.tmt_all#c.round1 c.tmt_all#c.round2 (i.districtX i.dateinterviewend severe_distress female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt_all#c.round1 c.tmt_all#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(45) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt_all#c.round1="Endline (round 1): Assignment" c.tmt_all#c.round2="Endline (round 2): Assignment") title("Survey-level: severe distress 0-1")
gr export "meta_severe_distress.eps", replace

*robust-indivi-level clustering?
pdslasso severe_distress1 tmt_all (i.districtX i.dateinterviewend severe_distress female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso	
	
**Reviewer #4, request to report DV+MH results for w/out LASSO spec - MANUALLY ADD
reg threatenPartner1 tmt_all, r cluster(districtX)
reg hitPartner1 tmt_all, r cluster(districtX)
reg logk101 tmt_all, r cluster(districtX)
reg severe_distress1 tmt_all, r cluster(districtX)

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



	
**separate Effects
**mitigate "unexpected" comm probl?
	leebounds unableCall7days1 tmt01, level(90) cieffect tight() 	
	leebounds unableCall7days1 tmt02, level(90) cieffect tight() 	
pdslasso unableCall7days1 tmt01 tmt02 (i.districtX i.dateinterviewend unableCall7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum unableCall7days1 if tmt_all==0
test tmt01 tmt02
outreg2 using "sepEffects_mitigate.tex", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, XX, p-value-jointtest, `r(p)') replace

*dyna fig
pdslasso unableCall7days1 c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2 (i.districtX i.dateinterviewend unableCall7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(60) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt01#c.round1="Endline (round 1): lumpsum" c.tmt02#c.round1="Endline (round 1): Installments" c.tmt01#c.round2="Endline (round 2): lumpsum" c.tmt02#c.round2="Endline (round 2): Installments") title("Survey-level: unable to communicate or call in past 7 days 0-1", size(med))
gr export "sep_unableCall7days.eps", replace
	
	
	leebounds unableToCOVID1 tmt01, level(90) cieffect tight() 	
	leebounds unableToCOVID1 tmt02, level(90) cieffect tight() 	
pdslasso unableToCOVID1 tmt01 tmt02 (i.districtX i.dateinterviewend unableToCOVID female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum unableToCOVID1 if tmt_all==0
test tmt01 tmt02
outreg2 using "sepEffects_mitigate.tex", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, XX, p-value-jointtest, `r(p)') append

*dyna fig
pdslasso unableToCOVID1 c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2  (i.districtX i.dateinterviewend unableToCOVID female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2 ) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(60) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt01#c.round1="Endline (round 1): lumpsum" c.tmt02#c.round1="Endline (round 1): Installments" c.tmt01#c.round2="Endline (round 2): lumpsum" c.tmt02#c.round2="Endline (round 2): Installments") title("Survey-level: unable to communicate or call due to COVID19 0-1", size(med))
gr export "sep_unableToCOVID.eps", replace
	
	
	leebounds digitborrow1 tmt01, level(90) cieffect tight() 	
	leebounds digitborrow1 tmt02, level(90) cieffect tight() 	
pdslasso digitborrow1 tmt01 tmt02 (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum digitborrow1 if tmt_all==0
test tmt01 tmt02
outreg2 using "sepEffects_mitigate.tex", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, XX, p-value-jointtest, `r(p)') append

*dyna fig
pdslasso digitborrow1 c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2  (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(60) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt01#c.round1="Endline (round 1): lumpsum" c.tmt02#c.round1="Endline (round 1): Installments" c.tmt01#c.round2="Endline (round 2): lumpsum" c.tmt02#c.round2="Endline (round 2): Installments") title("Survey-level: seek or borrow mobile credit 0-1")
gr export "sep_digitborrow.eps", replace
	
	leebounds digitloan1 tmt01, level(90) cieffect tight() 	
	leebounds digitloan1 tmt02, level(90) cieffect tight() 	
pdslasso digitloan1 tmt01 tmt02 (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum digitloan1 if tmt_all==0
test tmt01 tmt02
outreg2 using "sepEffects_mitigate.tex", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, XX, p-value-jointtest, `r(p)') append title("Mitigation of communication constraints - saturated")

*dyna fig
pdslasso digitloan1 c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2 (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(60) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt01#c.round1="Endline (round 1): lumpsum" c.tmt02#c.round1="Endline (round 1): Installments" c.tmt01#c.round2="Endline (round 2): lumpsum" c.tmt02#c.round2="Endline (round 2): Installments") title("Survey-level: seek digital loan 0-1")
gr export "sep_digitloan.eps", replace
	
	
	leebounds totExp7days1 tmt01, level(90) cieffect tight() 	
	leebounds totExp7days1 tmt02, level(90) cieffect tight() 	
**expenditure Shifts [resource reallocation effect]?
pdslasso totExp7days1 tmt01 tmt02 (i.districtX i.dateinterviewend totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum totExp7days1 if tmt_all==0
test tmt01 tmt02
outreg2 using "sepEffects_wellbeing_econ_mh.tex", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, XX, p-value-jointtest, `r(p)') replace

*dyna fig
pdslasso totExp7days1 c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2 (i.districtX i.dateinterviewend totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(60) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt01#c.round1="Endline (round 1): lumpsum" c.tmt02#c.round1="Endline (round 1): Installments" c.tmt01#c.round2="Endline (round 2): lumpsum" c.tmt02#c.round2="Endline (round 2): Installments") title("Survey-level: consumption expenses (GHS)")
gr export "sep_totExp7days.eps", replace
	

**dV
	leebounds threatenPartner1 tmt01, level(90) cieffect tight() 	
	leebounds threatenPartner1 tmt02, level(90) cieffect tight() 	
pdslasso threatenPartner1 tmt01 tmt02 (i.districtX i.dateinterviewend threatenPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum threatenPartner1 if tmt_all==0
test tmt01 tmt02
outreg2 using "sepEffects_wellbeing_econ_mh.tex", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, XX, p-value-jointtest, `r(p)') append

*dyna fig
pdslasso threatenPartner1 c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2 (i.districtX i.dateinterviewend threatenPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(60) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt01#c.round1="Endline (round 1): lumpsum" c.tmt02#c.round1="Endline (round 1): Installments" c.tmt01#c.round2="Endline (round 2): lumpsum" c.tmt02#c.round2="Endline (round 2): Installments") title("Survey-level: threatened partner 1-4")
gr export "sep_threatenPartner.eps", replace
	

	leebounds hitPartner1 tmt01, level(90) cieffect tight() 	
	leebounds hitPartner1 tmt02, level(90) cieffect tight() 	
pdslasso hitPartner1 tmt01 tmt02 (i.districtX i.dateinterviewend hitPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum hitPartner1 if tmt_all==0
test tmt01 tmt02
outreg2 using "sepEffects_wellbeing_econ_mh.tex", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, XX, p-value-jointtest, `r(p)') append

*dyna fig
pdslasso hitPartner1 c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2 (i.districtX i.dateinterviewend hitPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(60) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt01#c.round1="Endline (round 1): lumpsum" c.tmt02#c.round1="Endline (round 1): Installments" c.tmt01#c.round2="Endline (round 2): lumpsum" c.tmt02#c.round2="Endline (round 2): Installments") title("Survey-level: hit partner 1-4")
gr export "sep_hitPartner.eps", replace
	
	
	
**mH
	leebounds logk101 tmt01, level(90) cieffect tight() 	
	leebounds logk101 tmt02, level(90) cieffect tight() 	
pdslasso logk101 c.tmt01 c.tmt02 (i.districtX i.dateinterviewend logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum logk101 if tmt_all==0
test tmt01 tmt02
outreg2 using "sepEffects_wellbeing_econ_mh.tex", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, XX, p-value-jointtest, `r(p)') append

*dyna fig
pdslasso logk101 c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2 (i.districtX i.dateinterviewend logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(60) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt01#c.round1="Endline (round 1): lumpsum" c.tmt02#c.round1="Endline (round 1): Installments" c.tmt01#c.round2="Endline (round 2): lumpsum" c.tmt02#c.round2="Endline (round 2): Installments") title("Survey-level: logK10")
gr export "sep_logk10.eps", replace
	
	leebounds severe_distress1 tmt01, level(90) cieffect tight() 	
	leebounds severe_distress1 tmt02, level(90) cieffect tight() 	
pdslasso severe_distress1 c.tmt01 c.tmt02 (i.districtX i.dateinterviewend i.severe_distress female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum severe_distress1 if tmt_all==0
sum severe_distress if tmt_all==0
test tmt01 tmt02
outreg2 using "sepEffects_wellbeing_econ_mh.tex", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, XX, p-value-jointtest, `r(p)') append title(" of communication credit on wellbeing - saturated")

*dyna fig
pdslasso severe_distress1 c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2  (i.districtX i.dateinterviewend severe_distress female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(60) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt01#c.round1="Endline (round 1): lumpsum" c.tmt02#c.round1="Endline (round 1): Installments" c.tmt01#c.round2="Endline (round 2): lumpsum" c.tmt02#c.round2="Endline (round 2): Installments") title("Survey-level: severe distress 0-1")
gr export "sep_severe_distress.eps", replace
	
	
	
	
	
	

	
**Heterogeneity: ?
**Comment: MHT Correction - The Romano-Wolf Multiple Hypothesis Correction
*(i) MEta?
*rwolf unableCall7days1 unableToCOVID1 digitborrow1 digitloan1, indepvar(tmt_all) seed(124) //fam 1 (fist stage outcomes)
gen jointPov = tmt_all*pov_likelihood
gen jointInf = tmt_all*informal0
gen jointFem = tmt_all*female0
gen jointLoc = tmt_all*previouslock
rwolf totExp7days1 c1 c2 e1 e2 e3 e4 e5, indepvar(tmt_all pov_likelihood jointPov) seed(124)
rwolf threatenPartner1 hitPartner1 logk101 severe_distress1, indepvar(tmt_all jointPov) seed(124) //not estimable for all 3

rwolf totExp7days1 c1 c2 e1 e2 e3 e4 e5, indepvar(tmt_all informal0 jointInf) seed(124)
rwolf threatenPartner1 hitPartner1 logk101 severe_distress1, indepvar(tmt_all informal0 jointInf) seed(124)

rwolf totExp7days1 c1 c2 e1 e2 e3 e4 e5, indepvar(tmt_all jointFem female0) seed(124)
rwolf threatenPartner1 hitPartner1 logk101 severe_distress1, indepvar(tmt_all female0 jointFem) seed(124)

rwolf totExp7days1 c1 c2 e1 e2 e3 e4 e5, indepvar(tmt_all previouslock jointLoc) seed(124)
rwolf threatenPartner1 hitPartner1 logk101 severe_distress1, indepvar(tmt_all jointLoc) seed(124) //not estimable for all 3
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



**(4)region: never-lock vs no previously-lock = so might still be battling (direct) econ ? evidence: eager to re-allocate their budgets to more consumption (utilities and durables, as expected)
tab regionX
tab regionX, nolab
gen  previouslock =(regionX==3 | regionX==6)
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

	
	
	
	

*Validity and balanced-yes? redo again to verify
********************************************************
********************************************************
tab i11 if end==1, miss
gen Trust = (trustgovtCOVIDNos0>=3) if !missing(trustgovtCOVIDNos0)
sum  female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 motherTogether noReligion spouseTogether ageMarried if end==1
sum pov_likelihood if end==1
sum awareofCOVID0 Trust previouslock self_hseWork0 bd30 if end==1
sum needToCOVID unableCall7days unableToCOVID unableTrans7days bd10 bd20 bd30 ct1a0 ct1b0 ct2a0 ct2b0 if end==1
sum totExp7days threatenPartner hitPartner logk10 severe_distress tiredCOVID m110 m120 m130 m140 if end==1


*x-s (from main step 1)
reg female0 tmt01 tmt02 if round==3, r cluster(districtX)
reg akan0 tmt01 tmt02 if round ==3, r cluster(districtX)
reg married0 tmt01 tmt02 if round ==3, r cluster(districtX)
reg jhs0 tmt01 tmt02 if round ==3, r cluster(districtX)
reg hhsize0 tmt01 tmt02 if round ==3, r cluster(districtX)
reg selfEmploy0 tmt01 tmt02 if round ==3, r cluster(districtX)
reg informal0 tmt01 tmt02 if round ==3, r cluster(districtX)
reg incomegrp0 tmt01 tmt02 if round ==3, r cluster(districtX)
reg self_hseWork0 tmt01 tmt02 if round ==3, r cluster(districtX)  
reg previouslock tmt01 tmt02 if round ==3, r cluster(districtX)  
reg awareofCOVID0 tmt01 tmt02 if round ==3, r cluster(districtX)  
reg trustgovtCOVIDNos0 tmt01 tmt02 if round ==3, r cluster(districtX)  

**more x-s (from step 0)
reg pov_likelihood tmt01 tmt02 if round ==3, r cluster(districtX) 
reg motherTogether tmt01 tmt02 if round ==3, r cluster(districtX) 
reg noReligion tmt01 tmt02 if round ==3, r cluster(districtX) 
reg spouseTogether tmt01 tmt02 if round ==3, r cluster(districtX) 
reg ageMarried tmt01 tmt02 if round ==3, r cluster(districtX)
reg tmt_all female0 akan0 married0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 self_hseWork0 previouslock awareofCOVID0 trustgovtCOVIDNos0 pov_likelihood motherTogether noReligion spouseTogether ageMarried, cluster(districtX)
probit tmt_all female0 akan0 married0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 self_hseWork0 previouslock awareofCOVID0 trustgovtCOVIDNos0 pov_likelihood motherTogether noReligion spouseTogether ageMarried, cluster(districtX)


*y0-best correlates
reg unableCall7days tmt01 tmt02 if round==3, r cluster(districtX)
reg unableToCOVID tmt01 tmt02 if round==3, r cluster(districtX)
reg totExp7days tmt01 tmt02 if round==3, r cluster(districtX)
reg c1 tmt01 tmt02 if round==3, r cluster(districtX)
reg c2 tmt01 tmt02 if round==3, r cluster(districtX)
reg e1 tmt01 tmt02 if round==3, r cluster(districtX)
reg e2 tmt01 tmt02 if round==3, r cluster(districtX)
reg e3 tmt01 tmt02 if round==3, r cluster(districtX)
reg e4 tmt01 tmt02 if round==3, r cluster(districtX)
reg e5 tmt01 tmt02 if round==3, r cluster(districtX)
reg threatenPartner tmt01 tmt02 if round==3, r cluster(districtX)
reg hitPartner tmt01 tmt02 if round==3, r cluster(districtX)
reg logk10 tmt01 tmt02 if round==3, r cluster(districtX)
reg severe_distress tmt01 tmt02 if round==3, r cluster(districtX)
reg tiredCOVID tmt01 tmt02 if round==3, r cluster(districtX)

reg m110 tmt01 tmt02 if round==3, r cluster(districtX) //depressed? 1-5
reg m120 tmt01 tmt02 if round==3, r cluster(districtX) //relaxed? 1-5
reg m130 tmt01 tmt02 if round==3, r cluster(districtX) //life-satisfied: 1-5 scale
reg m140 tmt01 tmt02 if round==3, r cluster(districtX) //finance-satisfied:  1-5 scale



**bring in Wave 2 (for a few other controls but not in Wave 1?)
use "${data_dir}/DATA/Round_2/impact_covid_roundFINAL.dta", clear
'/impact_covid_roundFINAL.dta'
gen round=2
tab round
merge m:1 caseidx using "${data_dir}/_Francis_Impacts/MobileCredit40GHS_376list" //(but 1:1 for 12/6)
drop _merge
gen MobileCredit40=MobileCredit
drop MobileCredit
tab MobileCredit40 
merge m:m caseidx using "${data_dir}/_Francis_Impacts/MobileCredit20GHS_371list_Wave1"  //(but 1:m for 12/6)
drop _merge
gen MobileCredit20=MobileCredit
drop MobileCredit
tab MobileCredit20

gen MobileCredit = MobileCredit40 
replace MobileCredit = MobileCredit20 if !missing(MobileCredit20)

*keep if interviewn_result==1
bys caseidx: keep if _n==1
gen tmt_all= !missing(MobileCredit) 
gen tmt01= (MobileCredit=="40GHS") 
gen tmt02= (MobileCredit=="20GHS") 
gen tmt_all2= (MobileCredit=="40GHS" | MobileCredit=="20GHS") 
gen tmt= 0
replace tmt=1 if tmt01==1
replace tmt=2 if tmt02==1
sum tmt_all tmt_all2 tmt01 tmt02 tmt

*add dsitrrictX
merge m:m caseidx using "${data_dir}/_Francis_Impacts/TrtList00" //bring in round 1 = base & X's

**balance?
gen digitborrow0=(bd1==1) if !missing(bd1) 
gen digitloan0=(bd2==1) if !missing(bd1) 
gen relocated0=(bd3==1) if !missing(bd1) 

sum digitborrow0 digitloan0 relocated0 
reg digitborrow0 tmt01 tmt02, r cluster(districtX) // borrowed airtime?
reg digitloan0 tmt01 tmt02, r cluster(districtX) // seek or borrowed digital loan?
reg relocated0 tmt01 tmt02, r cluster(districtX) // has related?


