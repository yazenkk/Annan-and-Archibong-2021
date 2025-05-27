/*
Table 1 and Figure A8
*/

***********************************
use "${replication_dir}/Data/03_clean/end1_end2.dta", replace	


* Table 1
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
outreg2 using "${replication_dir}/Output/Tables/sepEffects_mitigate.tex", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, XX, p-value-jointtest, `r(p)') replace

*dyna fig
pdslasso unableCall7days1 c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2 (i.districtX i.dateinterviewend unableCall7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(60) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt01#c.round1="Endline (round 1): lumpsum" c.tmt02#c.round1="Endline (round 1): Installments" c.tmt01#c.round2="Endline (round 2): lumpsum" c.tmt02#c.round2="Endline (round 2): Installments") title("Survey-level: unable to communicate or call in past 7 days 0-1", size(med))
gr export "${replication_dir}/Output/Figures/sep_unableCall7days.eps", replace
	
	
	leebounds unableToCOVID1 tmt01, level(90) cieffect tight() 	
	leebounds unableToCOVID1 tmt02, level(90) cieffect tight() 	
pdslasso unableToCOVID1 tmt01 tmt02 (i.districtX i.dateinterviewend unableToCOVID female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum unableToCOVID1 if tmt_all==0
test tmt01 tmt02
outreg2 using "${replication_dir}/Output/Tables/sepEffects_mitigate.tex", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, XX, p-value-jointtest, `r(p)') append

*dyna fig
pdslasso unableToCOVID1 c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2  (i.districtX i.dateinterviewend unableToCOVID female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2 ) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(60) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt01#c.round1="Endline (round 1): lumpsum" c.tmt02#c.round1="Endline (round 1): Installments" c.tmt01#c.round2="Endline (round 2): lumpsum" c.tmt02#c.round2="Endline (round 2): Installments") title("Survey-level: unable to communicate or call due to COVID19 0-1", size(med))
gr export "${replication_dir}/Output/Figures/sep_unableToCOVID.eps", replace
	
	
	leebounds digitborrow1 tmt01, level(90) cieffect tight() 	
	leebounds digitborrow1 tmt02, level(90) cieffect tight() 	
pdslasso digitborrow1 tmt01 tmt02 (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum digitborrow1 if tmt_all==0
test tmt01 tmt02
outreg2 using "${replication_dir}/Output/Tables/sepEffects_mitigate.tex", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, XX, p-value-jointtest, `r(p)') append

*dyna fig
pdslasso digitborrow1 c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2  (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(60) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt01#c.round1="Endline (round 1): lumpsum" c.tmt02#c.round1="Endline (round 1): Installments" c.tmt01#c.round2="Endline (round 2): lumpsum" c.tmt02#c.round2="Endline (round 2): Installments") title("Survey-level: seek or borrow mobile credit 0-1")
gr export "${replication_dir}/Output/Figures/sep_digitborrow.eps", replace
	
	leebounds digitloan1 tmt01, level(90) cieffect tight() 	
	leebounds digitloan1 tmt02, level(90) cieffect tight() 	
pdslasso digitloan1 tmt01 tmt02 (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum digitloan1 if tmt_all==0
test tmt01 tmt02
outreg2 using "${replication_dir}/Output/Tables/sepEffects_mitigate.tex", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, XX, p-value-jointtest, `r(p)') append title("Mitigation of communication constraints - saturated")

*dyna fig
pdslasso digitloan1 c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2 (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(60) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt01#c.round1="Endline (round 1): lumpsum" c.tmt02#c.round1="Endline (round 1): Installments" c.tmt01#c.round2="Endline (round 2): lumpsum" c.tmt02#c.round2="Endline (round 2): Installments") title("Survey-level: seek digital loan 0-1")
gr export "${replication_dir}/Output/Figures/sep_digitloan.eps", replace
	

