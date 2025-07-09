/*
Figures A3-A5
*/



use "${replication_dir}/Data/03_clean/end1_end2.dta", clear

** Figure A3
**K10 and cons
*low (scores of 10-15, indicating little or no psychological distress)
*moderate (scores of 16-21)
*high (scores of 22-29)
*Very high/ severe (scores of 30-50)
gen k10 = exp(logk10)
hist k10 if end==1, percent xline(30, lp(dash)) xtitle("K10 score at baseline") lcolor(none) fcolor(gray) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid)
gr export "${replication_dir}/Output/Figures/figure_a3.eps", replace // subjects_k10_base
sum severe_distress if end==1 // 11.5% rate of severe distress


** Figure A4
hist totExp7days if end==1, percent xline(500, lp(dash)) xtitle("Total consumption expenditure - weekly (GHS)") lcolor(none) fcolor(gray) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid)
gr export "${replication_dir}/Output/Figures/figure_a4.eps", replace // subjects_totconsump_base
gen poor_consump = totExp7days<=500 if end==1 
sum poor_consump if end==1 // 81.7% rate of poor consumption


** Figure A5
distplot number_of_calls //no of time called b/4 picking up
hist number_of_calls, gap(10) percent xtitle("Number of phone call times before answering survey") lcolor(none) fcolor(gray) graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid)
gr export "${replication_dir}/Output/Figures/figure_a5.eps", replace // subjects_calltimeS
