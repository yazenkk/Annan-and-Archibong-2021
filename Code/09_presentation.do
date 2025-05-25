/*
Presentation
*/

use "${replication_dir}/Data/clean/end1_end2.dta", replace


**presentation?
*I show separate effects
*I mention - effects larger + lasting for Installment credit
gen Lumpsum =tmt01
gen Installment = tmt02

**mitigation of unmitigated mobile calls/connections
pdslasso unableCall7days1 Lumpsum Installment (i.districtX i.dateinterviewend unableCall7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
estimates store unableCall7days1_meta
pdslasso unableToCOVID1 Lumpsum Installment (i.districtX i.dateinterviewend unableToCOVID female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
estimates store unableToCOVID1_meta
pdslasso digitborrow1 Lumpsum Installment (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
estimates store digitborrow1_meta
pdslasso digitloan1 Lumpsum Installment (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
estimates store digitloan1_meta


**plot individually and stack
coefplot ///
(unableCall7days1_meta, aseq(unable to call past 7days: 0-1) ///
\ unableToCOVID1_meta, aseq(unable to call due COVID19: 0-1) ///
\ digitborrow1_meta, aseq(seek / borrow SOS airtime: 0-1) ///
\ digitloan1_meta, aseq(seek digital loan: 0-1)), ///
keep(Lumpsum Installment) swapnames ///
level(90) xline(0, lp(dash) lw(vthin) lc(black)) ///
mlabel format(%9.02f) mlabposition(12) mlabgap(*4.5) mlabsize(tiny) ciopts(lwidth(*2) lcolor(*.6))
*coeflabels(tmt01="Trt program: lumpsum" tmt02="Trt program: installment")
gr export present_Mitigate.eps, replace


**real effects: outcomes
pdslasso totExp7days1 Lumpsum Installment (i.districtX i.dateinterviewend unableCall7days female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
estimates store totExp7days1_meta
pdslasso threatenPartner1 Lumpsum Installment  (i.districtX i.dateinterviewend unableToCOVID female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
estimates store threatenPartner1_meta
pdslasso hitPartner1 Lumpsum Installment  (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
estimates store hitPartner1_meta
pdslasso logk101 Lumpsum Installment  (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
estimates store logk101_meta
pdslasso severe_distress1 Lumpsum Installment  (i.districtX i.dateinterviewend female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0), ///
    partial(i.districtX) ///
    cluster(caseidx) ///
    rlasso
estimates store severe_distress1_meta

**plot individually and stack
coefplot ///
(totExp7days1_meta, aseq(total expenditure: GHS) ///
\ threatenPartner1_meta, aseq(threatened partner: 1-4) ///
\ hitPartner1_meta, aseq(Hit Partner: 1-4) ///
\ logk101_meta, aseq(log [K10]) ///
\ severe_distress1_meta, aseq(severe distress: 0-1)), ///
keep(Lumpsum Installment) swapnames ///
level(90) xline(0, lp(dash) lw(vthin) lc(black)) ///
mlabel format(%9.02f) mlabposition(12) mlabgap(*4.5) mlabsize(tiny) ciopts(lwidth(*25) lcolor(*.6))
coeflabels(tmt01="Trt program: lumpsum" tmt02="Trt program: installment")
*gr export ${data_dir}/_Francis_Impacts/paper/results/_metateffects_outcomes.eps, replace

	coefplot ///
	(threatenPartner1_meta, aseq(threatened partner: 1-4) ///
	\ hitPartner1_meta, aseq(Hit Partner: 1-4) ///
	\ logk101_meta, aseq(log [K10]) ///
	\ severe_distress1_meta, aseq(severe distress: 0-1)), ///
	keep(Lumpsum Installment) swapnames ///
	level(90) xline(0, lp(dash) lw(vthin) lc(black)) ///
	mlabel format(%9.02f) mlabposition(12) mlabgap(*4.5) mlabsize(tiny) ciopts(lwidth(*2) lcolor(*.6))
	*coeflabels(tmt01="Trt program: lumpsum" tmt02="Trt program: installment")
	gr export present_Outcomes.eps, replace


