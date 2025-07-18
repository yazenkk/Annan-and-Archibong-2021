/*
Tables A4-A5: balance tests
*/


pause on

** -----------------------------------------------------------------------------
** wave two balance tests

**bring in Wave 2 (for a few other controls but not in Wave 1?)
use "${replication_dir}/Data/01_raw/impact_covid_roundFINAL.dta", clear
gen round=2
tab round
merge m:1 caseidx using "${replication_dir}/Data/01_raw/MobileCredit40GHS_376list" //(but 1:1 for 12/6)
drop _merge
gen MobileCredit40=MobileCredit
drop MobileCredit
tab MobileCredit40 
merge m:m caseidx using "${replication_dir}/Data/01_raw/MobileCredit20GHS_371list_Wave1"  //(but 1:m for 12/6)
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

* add districtX and other demographics
merge m:m caseidx using "${replication_dir}/Data/01_raw/TrtList00" // bring in round 1 = base & X's

**balance?
gen digitborrow0=(bd1==1) if !missing(bd1)
gen digitloan0=(bd2==1) if !missing(bd1)
gen relocated0=(bd3==1) if !missing(bd1)

local lab_digitborrow0 "Borrow airtime 0-1 (Wave 2)"
local lab_digitloan0 "Seek digital loan 0-1 (Wave 2)"
local lab_relocated0 "Has relocated / moved in past 7days 0-1 (Wave 2)"


local wave2_vars digitborrow0 digitloan0 relocated0

** regress
foreach y in `wave2_vars' {
	
	qui reg `y' tmt01 tmt02, r cluster(districtX)
	mat M = r(table)
	
	** constant
	loc b_`y'_0  = string(M[rownumb(M, "b"), 	  colnumb(M, "_cons")], "%15.3fc")
	loc se_`y'_0 = string(M[rownumb(M, "se"),     colnumb(M, "_cons")], "%12.3fc")
	loc p_`y'_0  = string(M[rownumb(M, "pvalue"), colnumb(M, "_cons")], "%12.3fc")
	loc star_`y'_0=cond(`p_`y'_0'<=.01,"***",cond(`p_`y'_0'<=.05,"**",cond(`p_`y'_0'<=.1,"*","")))		
	** tmt01
	loc b_`y'_1  = string(M[1,1], "%15.3fc")
	loc se_`y'_1 = string(M[2,1], "%12.3fc")
	loc p_`y'_1  = string(M[4,1], "%12.3fc")
	loc star_`y'_1=cond(`p_`y'_1'<=.01,"***",cond(`p_`y'_1'<=.05,"**",cond(`p_`y'_1'<=.1,"*","")))				
	** tmt02
	loc b_`y'_2  = string(M[1,2], "%15.3fc")
	loc se_`y'_2 = string(M[2,2], "%12.3fc")
	loc p_`y'_2  = string(M[4,2], "%12.3fc")
	loc star_`y'_2=cond(`p_`y'_2'<=.01,"***",cond(`p_`y'_2'<=.05,"**",cond(`p_`y'_2'<=.1,"*","")))		
}

	
** -----------------------------------------------------------------------------
** prepare final treatment variable
use "${replication_dir}/Data/03_clean/end1_end2.dta", clear
keep caseidx tmt01 tmt02 round
isid caseidx round
reshape wide tmt0*, i(caseidx) j(round)
assert tmt013 == tmt014
assert tmt023 == tmt024
drop tmt*4
rename tmt*3 tmt*
isid caseidx
tempfile treatment
save	`treatment'


** import round 1 and 2 data
use "${replication_dir}/Data/02_intermediate/round1_round2", clear
keep if round == 1
keep if interviewn_result==1
bys caseidx: keep if _n==1  //only subjects + dropouts
merge 1:1 caseidx using `treatment', gen(_mtmt)

** Communication Measures (Wave 1)
local comm unableCall7days ///
			unableToCOVID ///
			digitborrow0 /// Borrow airtime 0-1 (Wave 2)
			digitloan0 // Seek digital loan 0-1 (Wave 2)
			
** Well-being Measures (Wave 1)
local wellbeing totExp7days ///
				c1 ///
				c2 ///
				e1 ///
				e2 ///
				e3 ///
				e4 ///
				e5 ///
				threatenPartner ///
				hitPartner ///
				logk10 ///
				severe_distress ///
				tiredCOVID

** Corroborative Mental Health Measures (Wave 1)
local mentalh m110 m120 m130 m140

* Baseline controls
local demographics  female0 ///
					akan0 ///
					married0 ///
					jhs0 ///
					hhsize0 ///
					selfEmploy0 ///
					informal0 ///
					incomegrp0 ///
					self_hseWork0 ///
					previouslock ///
					awareofCOVID0 ///
					Trust ///
					relocated0 
					

local morecontrols  pov_likelihood ///
					motherTogether ///
					noReligion ///
					spouseTogether ///
					ageMarried

local table_a4 comm wellbeing mentalh 
local table_a5 demographics morecontrols

**joint tests (exclude y-s)
// reg Trt female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 pov_likelihood motherTogether noReligion female spouseTogether ageMarried if (Trt==0 | Trt==1) //ctr vs trt1
// reg Trt female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 pov_likelihood motherTogether noReligion female spouseTogether ageMarried if (Trt==0 | Trt==2) //ctr vs trt2
// probit Trt female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 pov_likelihood motherTogether noReligion female spouseTogether ageMarried if (Trt==0 | Trt==1) 
// probit Trt female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 pov_likelihood motherTogether noReligion female spouseTogether ageMarried if (Trt==0 | Trt==2)
// mprobit Trt female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 pov_likelihood motherTogether noReligion female spouseTogether ageMarried

** label variables
local lab_female0 "Female 0-1"
local lab_akan0 "Akan ethnic 0-1"
local lab_married0 "Married 0-1"
local lab_jhs0 "Attained Junior High School (JHS) 0-1"
local lab_hhsize0 "Household size (number)"
local lab_selfEmploy0 "Self-employed 0-1"
local lab_informal0 "Operates in informal sector 0-1"
local lab_incomegrp0 "Personal income (1 to 5 scale) (monthly)"
local lab_motherTogether "Staying together with mother 0-1 (Wave 0)"
local lab_noReligion "Has no religion 0-1 (Wave 0)"
local lab_spouseTogether "Staying together with spouse 0-1 (Wave 0)"
local lab_ageMarried "Age at marriage (Years) (Wave 0)"

local lab_pov_likelihood "Poverty rate (\%) (Schreiner 2005) (Wave 0)"

local lab_self_hseWork0 "Self does housework during pandemic 0-1"
local lab_previouslock "In previously lockdown region 0-1"
local lab_awareofCOVID0 "Aware of COVID-19 0-1"
local lab_Trust "Trust Government's estimates about COVID-19 0-1"

local lab_needToCOVID "Need to connect increased due to pandemic 0-1"
local lab_unableCall7days "Unable to call in past 7 days 0-1"
local lab_unableToCOVID "Unable to call due to COVID-19 0-1"
local lab_unableTrans7days "Unable to make airtime transfers in past 7 days 0-1"

local lab_totExp7days "Total Expenditure (GHS) (weekly)"
local lab_c1		  "Food expenses inside home (GHS)"
local lab_c2		  "Food expenses outside home (GHS)"
local lab_e1		  "Utilities expenses (GHS)"
local lab_e2		  "Personal care expenses (GHS)"
local lab_e3		  "Education expenses (GHS)"
local lab_e4		  "Health expenses (GHS)"
local lab_e5		  "Durables expenses (GHS)"

local lab_threatenPartner "Threatened Partner (1 = never to 4 = very often)"
local lab_hitPartner "Hit Partner (1 = never to 4 = very often)"
local lab_logk10 "log K10"
local lab_severe_distress "Severe Distress 0-1"
local lab_tiredCOVID "I'm tired (mentally, emotionally, or socially) of COVID-19 0-1"
local lab_m110 "I'm depressed (1 = disagree to 5 = agree)"
local lab_m120 "I'm relaxed (1 = disagree to 5 = agree)"
local lab_m130 "I'm satisfied with life, all else equal (1 = disagree to 5 = agree)"
local lab_m140 "I'm satisfied with finances, all else equal (1 = disagree to 5 = agree)"

** run regression: balance test
foreach table in table_a4 table_a5 {
	foreach list in ``table'' {
		foreach y in ``list'' {
			
			** regress only wave 0 and 1 vars
			if !("`y'" == "digitborrow0" | "`y'" == "digitloan0" | "`y'" == "relocated0") {
				dis "`list' - `y'"
				reg `y' tmt01 tmt02, r cluster(districtX)
	// 			if "`y'" == "c1" pause
				mat M = r(table)
	// 			mat list M
	// 			pause
				** constant
				loc b_`y'_0  = string(M[rownumb(M, "b"), 	  colnumb(M, "_cons")], "%15.3fc")
				loc se_`y'_0 = string(M[rownumb(M, "se"),     colnumb(M, "_cons")], "%12.3fc")
				loc p_`y'_0  = string(M[rownumb(M, "pvalue"), colnumb(M, "_cons")], "%12.3fc")
				loc star_`y'_0=cond(`p_`y'_0'<=.01,"***",cond(`p_`y'_0'<=.05,"**",cond(`p_`y'_0'<=.1,"*","")))		
				** tmt01
				loc b_`y'_1  = string(M[1,1], "%15.3fc")
				loc se_`y'_1 = string(M[2,1], "%12.3fc")
				loc p_`y'_1  = string(M[4,1], "%12.3fc")
				loc star_`y'_1=cond(`p_`y'_1'<=.01,"***",cond(`p_`y'_1'<=.05,"**",cond(`p_`y'_1'<=.1,"*","")))				
				** tmt02
				loc b_`y'_2  = string(M[1,2], "%15.3fc")
				loc se_`y'_2 = string(M[2,2], "%12.3fc")
				loc p_`y'_2  = string(M[4,2], "%12.3fc")
				loc star_`y'_2=cond(`p_`y'_2'<=.01,"***",cond(`p_`y'_2'<=.05,"**",cond(`p_`y'_2'<=.1,"*","")))		
			}
		}
	}

	** print table
	cap file close fh 
	file open fh using "${replication_dir}/Output/Tables/`table'.tex", replace write
		file write fh "\begin{tabular}{lccc}"_n
		file write fh "\hline"_n
		file write fh " Variable & Constant & Lumpsum & Installments \\ [0.1em] " _n
		file write fh "\hline\hline"_n

		foreach list in ``table'' {
			if "`list'" == "comm" 		  file write fh "\textbf{Communication Measures (Wave 1)} & & & \\ "_n
			if "`list'" == "wellbeing" 	  file write fh "\textbf{ll-being Measures (Wave 1)} & & & \\ "_n
			if "`list'" == "mentalh" 	  file write fh "\textbf{Corroborative Mental Health Measures (Wave 1)} & & & \\ "_n
			if "`list'" == "demographics" file write fh "\textbf{Baseline Controls (Wave 1)} & & & \\ "_n
			if "`list'" == "morecontrols" file write fh "\textbf{More Baseline Controls (Wave 0)} & & & \\ "_n
			
			foreach y in ``list'' {
				file write fh " `lab_`y'' & `b_`y'_0'`star_`y'_0' & `b_`y'_1'`star_`y'_1' & `b_`y'_2'`star_`y'_2' \\ [0.1em] " _n
				file write fh " 		  &      (`se_`y'_0')     &      (`se_`y'_1')     &      (`se_`y'_2')     \\ [0.1em] " _n
			}
		}
		
		file write fh "\hline\hline"_n
		file write fh "\end{tabular}"_n
	file close fh 
}





