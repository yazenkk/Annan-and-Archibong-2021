

clear all
set more off
// timer clear
// timer on 1
version 14 // to address rwolf issue across replications
set seed 090725 


** clean data
qui {
	do "${replication_dir}/Code/00_outcomes_clean.do"
	do "${replication_dir}/Code/00_outcomes_merge.do"
}
version 14 // to address rwolf issue across replications
use "${replication_dir}/Data/03_clean/end1_end2.dta", clear	
rwolf totExp7days1 c1 c2 e1 e2 e3 e4 e5, indepvar(tmt_all) seed(124) reps(499)


** clean data
qui {
	do "${replication_dir}/Code/00_outcomes_clean.do"
	do "${replication_dir}/Code/00_outcomes_merge.do"
}
rwolf totExp7days1 c1 c2 e1 e2 e3 e4 e5, indepvar(tmt_all) seed(124) reps(499)
e


// Cleaning still hurts the rwolf replication. Why? Duplicates not the issue?

use "${replication_dir}/Data/03_clean/end1_end2.dta", clear	
cf _all using "${replication_dir}/Data/03_clean/end1_end2_2.dta",
isid caseidx round
rename * *y
rename (caseidxy roundy) (caseidx round)
merge 1:1 caseidx round using "${replication_dir}/Data/03_clean/end1_end2_2.dta", gen(_mtest)


// Resolved. bys caseid (round). sort was only on ID variable, not ID+round
