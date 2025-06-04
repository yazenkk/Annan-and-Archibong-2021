/*
Table A7 and Figure A6
*/


set graphics on
***********************************
use "${replication_dir}/Data/03_clean/end1_end2.dta", replace	


	
**Comment: MHT Correction - The Romano-Wolf Multiple Hypothesis Correction
**Calculates Romano-Wolf stepdown adjusted p-values, which control the FWER and allows for dependence among p-values by bootstrap resampling
*NOTE:  The Romano-Wolf correction (asymptotically) controls the familywise error rate (FWER), that is, the probability of rejecting at least one true null hypothesis in a family of hypotheses under test (Clarke et al. 2020)
*(i) MEta?
rwolf unableCall7days1 unableToCOVID1 digitborrow1 digitloan1, indepvar(tmt_all) seed(124) reps(499) //fam 1 (fist stage outcomes)
rwolf totExp7days1 c1 c2 e1 e2 e3 e4 e5, indepvar(tmt_all) seed(124) reps(499) //fam 2 (second stage real impact outcomes)
rwolf threatenPartner1 hitPartner1 logk101 severe_distress1, indepvar(tmt_all) seed(124) //fam 3 (second stage real impact outcomes)
*(ii) SEparate?
rwolf unableCall7days1 unableToCOVID1 digitborrow1 digitloan1, indepvar(tmt01 tmt02) seed(124) //fam 1 (fist stage outcomes)
rwolf totExp7days1 c1 c2 e1 e2 e3 e4 e5, indepvar(tmt01 tmt02) seed(124) //fam 2 (second stage real impact outcomes - consumption)
rwolf threatenPartner1 hitPartner1 logk101 severe_distress1, indepvar(tmt01 tmt02) seed(124) //fam 3 (second stage real impact outcomes - mental health)



** Table A7 (metaEffects_mitigate)
**meta Effects
**mitigate "unexpected" comm probl?
	leebounds unableCall7days1 tmt_all, level(90) cieffect tight() 
reg unableCall7days1 tmt_all, r cluster(districtX)
sum unableCall7days1 if tmt_all==0
outreg2 using "${replication_dir}/Output/Tables/table_a7.tex", keep(c.tmt_all) addtext(District FE, No, Date FE, No, Controls, None, Mean of dep. variable, `r(mean)') replace
pdslasso unableCall7days1 tmt_all (i.districtX i.dateinterviewend unableCall7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum unableCall7days1 if tmt_all==0
outreg2 using "${replication_dir}/Output/Tables/table_a7.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append
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
reg unableToCOVID1 tmt_all, r cluster(districtX)
sum unableToCOVID1 if tmt_all==0
outreg2 using "${replication_dir}/Output/Tables/table_a7.tex", keep(c.tmt_all) addtext(District FE, No, Date FE, No, Controls, None, Mean of dep. variable, `r(mean)') append
pdslasso unableToCOVID1 tmt_all (i.districtX i.dateinterviewend unableToCOVID female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum unableToCOVID1 if tmt_all==0
outreg2 using "${replication_dir}/Output/Tables/table_a7.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append
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
reg digitborrow1 tmt_all, r cluster(districtX)
sum digitborrow1 if tmt_all==0
outreg2 using "${replication_dir}/Output/Tables/table_a7.tex", keep(c.tmt_all) addtext(District FE, No, Date FE, No, Controls, None, Mean of dep. variable, `r(mean)') append
pdslasso digitborrow1 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum digitborrow1 if tmt_all==0
outreg2 using "${replication_dir}/Output/Tables/table_a7.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append
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
reg digitloan1 tmt_all, r cluster(districtX)
sum digitloan1 if tmt_all==0
outreg2 using "${replication_dir}/Output/Tables/table_a7.tex", keep(c.tmt_all) addtext(District FE, No, Date FE, No, Controls, None, Mean of dep. variable, `r(mean)') append
pdslasso digitloan1 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum digitloan1 if tmt_all==0
outreg2 using "${replication_dir}/Output/Tables/table_a7.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append title("Mitigation of communication constraints - unsaturated")
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
	