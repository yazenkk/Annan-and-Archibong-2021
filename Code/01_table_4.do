/*
Table 4
Figure A7, graph 1
*/


***********************************
use "${replication_dir}/Data/03_clean/end1_end2.dta", replace	


	
** Table A8 (metaEffects_consume)
**expenditure Shifts [resource reallocation effect]?
	leebounds totExp7days1 tmt_all, level(90) cieffect tight() 
pdslasso totExp7days1 tmt_all (i.districtX i.dateinterviewend totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum totExp7days1 if tmt_all==0
outreg2 using "${replication_dir}/Output/Tables/table_4.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') replace

	leebounds c1 tmt_all, level(90) cieffect tight() 
pdslasso c1 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum c1 if tmt_all==0
outreg2 using "${replication_dir}/Output/Tables/table_4.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

	leebounds c2 tmt_all, level(90) cieffect tight() 
pdslasso c2 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum c2 if tmt_all==0
outreg2 using "${replication_dir}/Output/Tables/table_4.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

	leebounds e1 tmt_all, level(90) cieffect tight() 
pdslasso e1 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum e1 if tmt_all==0
outreg2 using "${replication_dir}/Output/Tables/table_4.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

	leebounds e2 tmt_all, level(90) cieffect tight() 
pdslasso e2 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum e2 if tmt_all==0
outreg2 using "${replication_dir}/Output/Tables/table_4.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

	leebounds e3 tmt_all, level(90) cieffect tight() 
pdslasso e3 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum e3 if tmt_all==0
outreg2 using "${replication_dir}/Output/Tables/table_4.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

	leebounds e4 tmt_all, level(90) cieffect tight() 
pdslasso e4 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
sum e4 if tmt_all==0
outreg2 using "${replication_dir}/Output/Tables/table_4.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append

	leebounds e5 tmt_all, level(90) cieffect tight() 
pdslasso e5 tmt_all (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(districtX) ///
    rlasso
sum e5 if tmt_all==0
outreg2 using "${replication_dir}/Output/Tables/table_4.tex", keep(c.tmt_all) addtext(District FE, Yes, Date FE, Yes, Controls, Post-Double LASSO, Mean of dep. variable, `r(mean)') append title(" of communication credit on consumption expenditure - unsaturated")

*dyna fig
pdslasso totExp7days1 c.tmt_all#c.round1 c.tmt_all#c.round2 (i.districtX i.dateinterviewend totExp7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
coefplot, keep(c.tmt_all#c.round1 c.tmt_all#c.round2) yline(0, lcolor(black) lw(thin) lp(dash)) vertical xlab(, angle(45) labsize(medium)) level(90) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid) ///
coeflabels(c.tmt_all#c.round1="Endline (round 1): Assignment" c.tmt_all#c.round2="Endline (round 2): Assignment") title("Survey-level: consumption expenses (GHS)")
gr export "${replication_dir}/Output/Figures/figure_a7_1.eps", replace // meta_totExp7days
	
