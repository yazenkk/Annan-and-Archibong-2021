/*
Table A3 summary stats
Wave 1 data and some wave 2
*/


***********************************
use "${replication_dir}/Data/03_clean/end1_end2.dta", replace	


*Validity and balanced-yes? redo again to verify
********************************************************
********************************************************

label var female0 "Female 0-1"
label var akan0 "Akan ethnic 0-1"
label var married0 "Married 0-1"
label var jhs0 "Attained Junior High School (JHS) 0-1"
label var hhsize0 "Household size (number)"
label var selfEmploy0 "Self-employed 0-1"
label var informal0 "Operates in informal sector 0-1"
label var incomegrp0 "Personal income (1 to 5 scale) (monthly)"
label var motherTogether "Staying together with mother 0-1 (Wave 0)"
label var noReligion "Has no religion 0-1 (Wave 0)"
label var spouseTogether "Staying together with spouse 0-1 (Wave 0)"
label var ageMarried "Age at marriage (Years) (Wave 0)"

label var pov_likelihood "Poverty rate (\%) (Schreiner 2005) (Wave 0)"

label var awareofCOVID0 "Aware of COVID-19 0-1"
label var Trust "Trust Government's estimates about COVID-19 0-1"
label var previouslock "In previously lockdown region 0-1"
label var self_hseWork0 "Self does housework during pandemic 0-1"
label var relocated0 "Has relocated / moved in past 7 days 0-1 (Wave 2)"  

label var needToCOVID "Need to connect increased due to pandemic 0-1"
label var unableCall7days "Unable to call in past 7 days 0-1"
label var unableToCOVID "Unable to call due to COVID-19 0-1"
label var unableTrans7days "Unable to make airtime transfers in past 7 days 0-1"
label var digitborrow0 "Borrow airtime 0-1 (Wave 2)"
label var digitloan0 "Seek digital loan 0-1 (Wave 2)"

label var totExp7days "Total Expenditure (GHS) (weekly)"
label var threatenPartner "Threatened Partner (1 = never to 4 = very often)"
label var hitPartner "Hit Partner (1 = never to 4 = very often)"
label var logk10 "log K10"
label var severe_distress "Severe Distress 0-1"
label var tiredCOVID "I'm tired (mentally, emotionally, or socially) of COVID-19 0-1"
label var m110 "I'm depressed (1 = disagree to 5 = agree)"
label var m120 "I'm relaxed (1 = disagree to 5 = agree)"
label var m130 "I'm satisfied with life, all else equal (1 = disagree to 5 = agree)"
label var m140 "I'm satisfied with finances, all else equal (1 = disagree to 5 = agree)"

local demographics 	female0 akan0 married0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 motherTogether noReligion spouseTogether ageMarried 
local poverty 		pov_likelihood
local pandemic 		awareofCOVID0 Trust previouslock self_hseWork0 relocated0
local comm 			needToCOVID unableCall7days unableToCOVID unableTrans7days digitborrow0 digitloan0
local wellbeing 	totExp7days threatenPartner hitPartner logk10 severe_distress tiredCOVID m110 m120 m130 m140
local master_list 	demographics poverty pandemic comm wellbeing

foreach list in `master_list' {
	foreach var in ``list'' {
		qui sum `var' if end == 1
		local mu_`var' = string(`r(mean)', "%12.3fc")
		local sd_`var' = string(`r(sd)',   "%12.3fc")
		local n_`var'  = string(`r(N)',    "%12.0fc")
		local lab_`var' : variable label `var'
	}
}


** print table A3
cap file close fh 
file open fh using "${replication_dir}/Output/Tables/Table_A3_Summary_stats.tex", replace write
	file write fh "\begin{ThreePartTable}" _n
	file write fh "\begin{table}[tbp]\centering"_n
	file write fh "\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"_n
	file write fh "\caption{Attrition}"_n
	file write fh "\begin{tabular}{lccc}"_n
	file write fh "\hline"_n
	file write fh "Variable & Mean & SD & N \\"_n
	file write fh "\hline\hline"_n
	foreach list in `master_list' {
		if "`list'" == "demographics" file write fh "\textbf{Demographic Characteristics} & & & \\ "_n
		if "`list'" == "poverty" file write fh "\textbf{Poverty} & & & \\ "_n
		if "`list'" == "pandemic" file write fh "\textbf{Pandemic Basics} & & & \\ "_n
		if "`list'" == "comm" file write fh "\textbf{Key Communication Constraints} & & & \\ "_n
		if "`list'" == "wellbeing" file write fh "\textbf{Well-being Measures} & & & \\ "_n
		foreach var in ``list'' {
			file write fh "`lab_`var'' & `mu_`var'' & `sd_`var'' & `n_`var'' \\ "_n
		}
	}
	file write fh "\hline\hline"_n
	file write fh "\end{tabular}"_n
	file write fh "\end{table}"_n
file close fh 











