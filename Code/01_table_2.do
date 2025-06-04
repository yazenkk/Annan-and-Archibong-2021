/*
Table 2 and Figure A9
*/
set graphics off
***********************************
use "${replication_dir}/Data/03_clean/end1_end2.dta", replace	

	
** Table 2
	leebounds totExp7days1 tmt01, level(90) cieffect tight() 	
	leebounds totExp7days1 tmt02, level(90) cieffect tight() 	
**expenditure Shifts [resource reallocation effect]?
pdslasso totExp7days1 tmt01 tmt02 (i.districtX i.dateinterviewend totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum totExp7days1 if tmt_all==0
test tmt01 tmt02
outreg2 using "${replication_dir}/Output/Tables/table_2.tex", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, XX, p-value-jointtest, `r(p)') replace
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
	leebounds threatenPartner1 tmt02, level(90) cieffect tight() 	
pdslasso threatenPartner1 tmt01 tmt02 (i.districtX i.dateinterviewend threatenPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum threatenPartner1 if tmt_all==0
test tmt01 tmt02
outreg2 using "${replication_dir}/Output/Tables/table_2.tex", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, XX, p-value-jointtest, `r(p)') append

*dyna fig
pdslasso threatenPartner1 c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2 (i.districtX i.dateinterviewend threatenPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(60) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt01#c.round1="Endline (round 1): lumpsum" c.tmt02#c.round1="Endline (round 1): Installments" c.tmt01#c.round2="Endline (round 2): lumpsum" c.tmt02#c.round2="Endline (round 2): Installments") title("Survey-level: threatened partner 1-4")
gr export "${replication_dir}/Output/Figures/figure_a9_2.eps", replace // sep_threatenPartner
	

	leebounds hitPartner1 tmt01, level(90) cieffect tight() 	
	leebounds hitPartner1 tmt02, level(90) cieffect tight() 	
pdslasso hitPartner1 tmt01 tmt02 (i.districtX i.dateinterviewend hitPartner female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum hitPartner1 if tmt_all==0
test tmt01 tmt02
outreg2 using "${replication_dir}/Output/Tables/table_2.tex", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, XX, p-value-jointtest, `r(p)') append

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
	leebounds logk101 tmt02, level(90) cieffect tight() 	
pdslasso logk101 c.tmt01 c.tmt02 (i.districtX i.dateinterviewend logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum logk101 if tmt_all==0
test tmt01 tmt02
outreg2 using "${replication_dir}/Output/Tables/table_2.tex", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, XX, p-value-jointtest, `r(p)') append

*dyna fig
pdslasso logk101 c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2 (i.districtX i.dateinterviewend logk10 female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(60) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt01#c.round1="Endline (round 1): lumpsum" c.tmt02#c.round1="Endline (round 1): Installments" c.tmt01#c.round2="Endline (round 2): lumpsum" c.tmt02#c.round2="Endline (round 2): Installments") title("Survey-level: logK10")
gr export "${replication_dir}/Output/Figures/figure_a9_4.eps", replace // sep_logk10
	
	leebounds severe_distress1 tmt01, level(90) cieffect tight() 	
	leebounds severe_distress1 tmt02, level(90) cieffect tight() 	
pdslasso severe_distress1 c.tmt01 c.tmt02 (i.districtX i.dateinterviewend i.severe_distress female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum severe_distress1 if tmt_all==0
sum severe_distress if tmt_all==0
test tmt01 tmt02
outreg2 using "${replication_dir}/Output/Tables/table_2.tex", keep(tmt01 tmt02) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, XX, p-value-jointtest, `r(p)') append title(" of communication credit on wellbeing - saturated")

*dyna fig
pdslasso severe_distress1 c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2  (i.districtX i.dateinterviewend severe_distress female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt01#c.round1 c.tmt02#c.round1 c.tmt01#c.round2 c.tmt02#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(60) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt01#c.round1="Endline (round 1): lumpsum" c.tmt02#c.round1="Endline (round 1): Installments" c.tmt01#c.round2="Endline (round 2): lumpsum" c.tmt02#c.round2="Endline (round 2): Installments") title("Survey-level: severe distress 0-1")
gr export "${replication_dir}/Output/Figures/figure_a9_5.eps", replace // sep_severe_distress
	
	
