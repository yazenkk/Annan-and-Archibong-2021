/*
Table 1: Attrition
*/



** Analyze Baseline
use "${replication_dir}/Data/01_raw/impact10.102020Final.dta", clear
keep if interviewn_result==1
bys caseidx: keep if _n==1  //only subjects + dropouts
merge 1:m caseidx using "${replication_dir}/Data/02_intermediate/MobileCredit_attrition" //just 1 repeat in Aftrition file so do m:m
*bys caseidx: keep if _n==1  //only subjects + dropouts
tab _merge //0 no reachable
gen dropouts = (_merge==2)
gen ins=(dropouts==0)
tabstat ins, stat(mean sd n) by(MobileCredit_attrition) //get means and sd
*tabstat dropouts, stat(mean sd n) by(MobileCredit_attrition)
levelsof MobileCredit_attrition, local(levs)
foreach lev in `levs' {
	
	** treatments
	qui sum ins if MobileCredit_attrition == "`lev'"
	local mean_`lev'_w1 = string(`r(mean)'*100, "%12.0fc") + "\%"
	local sd_`lev'_w1 = string(`r(sd)'*100, "%12.0fc") + "\%"	
	qui count if ins == 1 & MobileCredit_attrition == "`lev'"
	local n_`lev'_w1 `r(N)'

	dis "`lev'"
	dis "`mean_`lev'_w1'"
	dis "`sd_`lev'_w1'"
	dis "`n_`lev'_w1'"
	
	** total
	qui sum ins 
	local mean_w1 = string(`r(mean)'*100, "%12.0fc") + "\%"
	local sd_w1 = string(`r(sd)'*100, "%12.0fc") + "\%"	
	qui count if ins == 1 
	local n_w1 `r(N)'
	
	** attrition
	sum dropouts 
	local mean_atrt_w1 = string(`r(mean)'*100, "%12.0fc") + "\%"
	local sd_atrt_w1 = string(`r(sd)'*100, "%12.0fc") + "\%"	
	count if dropouts == 1
	local n_atrt_w1 `r(N)'
}

*base 2
use "${replication_dir}/Data/01_raw/impact_covid_roundFINAL.dta", clear
keep if interviewn_result==1
bys caseidx: keep if _n==1  //only subjects + dropouts
*drop _merge
merge 1:m caseidx using "${replication_dir}/Data/02_intermediate/MobileCredit_attrition" //just 1 repeat in Aftrition file so do m:m
*bys caseidx: keep if _n==1  //only subjects + dropouts
tab _merge //88 no reachable
gen dropouts = (_merge==2)
tab MobileCredit_attrition if dropouts==0
gen ins=(dropouts==0)
tabstat ins, stat(mean sd n) by(MobileCredit_attrition) //get means and sd
*tabstat dropouts, stat(mean sd n) by(MobileCredit_attrition)
levelsof MobileCredit_attrition, local(levs)
foreach lev in `levs' {
	
	** treatments
	qui sum ins if MobileCredit_attrition == "`lev'"
	local mean_`lev'_w2 = string(`r(mean)'*100, "%12.0fc") + "\%"
	local sd_`lev'_w2 = string(`r(sd)'*100, "%12.0fc") + "\%"	
	qui count if ins == 1 & MobileCredit_attrition == "`lev'"
	local n_`lev'_w2 `r(N)'

	dis "`lev'"
	dis "`mean_`lev'_w2'"
	dis "`sd_`lev'_w2'"
	dis "`n_`lev'_w2'"
	
	** total
	qui sum ins 
	local mean_w2 = string(`r(mean)'*100, "%12.0fc") + "\%"
	local sd_w2 = string(`r(sd)'*100, "%12.0fc") + "\%"	
	qui count if ins == 1 
	local n_w2 `r(N)'
	
	** attrition
	sum dropouts 
	local mean_atrt_w2 = string(`r(mean)'*100, "%12.0fc") + "\%"
	local sd_atrt_w2 = string(`r(sd)'*100, "%12.0fc") + "\%"	
	count if dropouts == 1
	local n_atrt_w2 `r(N)'
}


** Analyze Endline
*end 1
use  "${replication_dir}/Data/02_intermediate/End1_MobileCredit_attrition", clear

levelsof MobileCredit_attrition, local(levs)
foreach lev in `levs' {
	
	** treatments
	qui sum ins if MobileCredit_attrition == "`lev'"
	local mean_`lev'_w3 = string(`r(mean)'*100, "%12.0fc") + "\%"
	local sd_`lev'_w3 = string(`r(sd)'*100, "%12.0fc") + "\%"	
	qui count if ins == 1 & MobileCredit_attrition == "`lev'"
	local n_`lev'_w3 `r(N)'

	dis "`lev'"
	dis "`mean_`lev'_w3'"
	dis "`sd_`lev'_w3'"
	dis "`n_`lev'_w3'"
	
	** total
	qui sum ins 
	local mean_w3 = string(`r(mean)'*100, "%12.0fc") + "\%"
	local sd_w3 = string(`r(sd)'*100, "%12.0fc") + "\%"	
	qui count if ins == 1 
	local n_w3 `r(N)'
	
	** attrition
	sum dropouts 
	local mean_atrt_w3 = string(`r(mean)'*100, "%12.0fc") + "\%"
	local sd_atrt_w3 = string(`r(sd)'*100, "%12.0fc") + "\%"	
	count if dropouts == 1
	local n_atrt_w3 `r(N)'
}


*end 2
use "${replication_dir}/Data/02_intermediate/End2_MobileCredit_attrition", clear

levelsof MobileCredit_attrition, local(levs)
foreach lev in `levs' {
	
	** treatments
	qui sum ins if MobileCredit_attrition == "`lev'"
	local mean_`lev'_w4 = string(`r(mean)'*100, "%12.0fc") + "\%"
	local sd_`lev'_w4 = string(`r(sd)'*100, "%12.0fc") + "\%"	
	qui count if ins == 1 & MobileCredit_attrition == "`lev'"
	local n_`lev'_w4 `r(N)'

	dis "`lev'"
	dis "`mean_`lev'_w4'"
	dis "`sd_`lev'_w4'"
	dis "`n_`lev'_w4'"
	
	** total
	qui sum ins 
	local mean_w4 = string(`r(mean)'*100, "%12.0fc") + "\%"
	local sd_w4 = string(`r(sd)'*100, "%12.0fc") + "\%"	
	qui count if ins == 1
	local n_w4 `r(N)'
	
	** attrition
	sum dropouts 
	local mean_atrt_w4 = string(`r(mean)'*100, "%12.0fc") + "\%"
	local sd_atrt_w4 = string(`r(sd)'*100, "%12.0fc") + "\%"	
	count if dropouts == 1
	local n_atrt_w4 `r(N)'
}


** Step 0
use "${replication_dir}/Data/01_raw/ZeroScoreData_26_09_p1", clear
count if q2 == 1
local fullcount = string(`r(N)', "%12.0fc")

**overall rate differential?
use "${replication_dir}/Data/02_intermediate/End1_MobileCredit_attrition", clear
append using "${replication_dir}/Data/02_intermediate/End2_MobileCredit_attrition"
tab MobileCredit_attrition, gen(TMT)
reg dropouts TMT2 TMT3
ttest dropouts if TMT3 !=1, by(TMT2)
ttest dropouts if TMT2 !=1, by(TMT3)


** print table A6
cap file close fh 
file open fh using "${replication_dir}/Output/Tables/Table_1_Attrition.tex", replace write
	file write fh "\begin{tabular}{lccccc}"_n
	file write fh "\hline"_n
	file write fh " & Lumpsum & Installments & Control & Total & Attrition \\"_n
	file write fh "\hline\hline"_n
	file write fh "STEP 0  &  		       &		 & `fullcount' &  		\\"_n
	file write fh "*Verify phone numbers & & & & & \\ "_n
	file write fh "*Measure poverty (Schreiner 2005) & & & & & \\ "_n
	file write fh "SELECT SAMPLE (Randomized) & `n_40GHS_w1' 		&	`n_20GHS_w1' 		&	`n_0GHS_w1' 		&	`n_w1' 		& 					\\"_n
	file write fh "BASELINE I (Wave 1) 		   & `n_40GHS_w1' 		&	`n_20GHS_w1' 		&	`n_0GHS_w1' 		&	`n_w1' 		&	`n_atrt_w1' 	\\"_n
	file write fh "							   & (`mean_40GHS_w1') 	&	(`mean_20GHS_w1') 	&	(`mean_0GHS_w1') 	&	(`mean_w1') &	(`mean_atrt_w1') \\"_n
	file write fh "							   & (`sd_40GHS_w1') 	&	(`sd_20GHS_w1') 	&	(`sd_0GHS_w1') 		&	(`sd_w1') 	&	(`sd_atrt_w1') 	\\"_n
	file write fh "BASELINE II (Wave 2) 	   & `n_40GHS_w2' 		&	`n_20GHS_w2' 		&	`n_0GHS_w2' 		&	`n_w2' 		&	`n_atrt_w2' 	\\"_n
	file write fh "							   & (`mean_40GHS_w2') 	&	(`mean_20GHS_w2') 	&	(`mean_0GHS_w2') 	&	(`mean_w2') &	(`mean_atrt_w2') \\"_n
	file write fh "							   & (`sd_40GHS_w2') 	&	(`sd_20GHS_w2') 	&	(`sd_0GHS_w2') 		&	(`sd_w2') 	&	(`sd_atrt_w2') 	\\"_n
	file write fh "ENDLINE I (Follow-up wave 3) & `n_40GHS_w3' 		&	`n_20GHS_w3' 		&	`n_0GHS_w3' 		&	`n_w3' 		&	`n_atrt_w3' 	\\"_n
	file write fh "							   & (`mean_40GHS_w3') 	&	(`mean_20GHS_w3') 	&	(`mean_0GHS_w3') 	&	(`mean_w3') &	(`mean_atrt_w3') \\"_n
	file write fh "							   & (`sd_40GHS_w3') 	&	(`sd_20GHS_w3') 	&	(`sd_0GHS_w3') 		&	(`sd_w3') 	&	(`sd_atrt_w3') 	\\"_n
	file write fh "ENDLINE II (Follow-up wave 4) & `n_40GHS_w4' 		&	`n_20GHS_w4' 		&	`n_0GHS_w4' 		&	`n_w4' 		&	`n_atrt_w4' 	\\"_n
	file write fh "							   & (`mean_40GHS_w4') 	&	(`mean_20GHS_w4') 	&	(`mean_0GHS_w4') 	&	(`mean_w4') &	(`mean_atrt_w4') \\"_n
	file write fh "							   & (`sd_40GHS_w4') 	&	(`sd_20GHS_w4') 	&	(`sd_0GHS_w4') 		&	(`sd_w4') 	&	(`sd_atrt_w4') 	\\"_n
	file write fh "\hline\hline"_n
	file write fh "\end{tabular}"_n
file close fh 

