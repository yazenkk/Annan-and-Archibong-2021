/*
De-identify
*/

use "${replication_dir}/Data/01_raw/ZeroScoreData_26_09_p1.dta", clear
ds q1a1 q1a2 head_name addresss phone_number region_name interviewer_name 
foreach var of varlist `r(varlist)' {
	dis "`var' is string"
	qui replace `var' = "PII" if `var' != ""
}

ds q5 q61 q68
foreach var of varlist `r(varlist)' {
	qui replace `var' = .p if `var' != .
}

** save data
save "${replication_dir}/Data/01_raw/ZeroScoreData_26_09_p1.dta", replace


use "${replication_dir}/Data/01_raw/select1396Final_sample.dta", clear
ds headnX address phone phoneStar  headn memname
foreach var of varlist `r(varlist)' {
	dis "`var' is string"
	qui replace `var' = "PII" if `var' != ""
}

ds eacode tel1 tel2 tel3
foreach var of varlist `r(varlist)' {
	qui replace `var' = .p if `var' != .
}
** save data
save "${replication_dir}/Data/01_raw/select1396Final_sample.dta", replace



use "${replication_dir}/Data/01_raw/round4_data_14.12.dta", clear
ds callern name_of_respondent phone_number_of_respondent
foreach var of varlist `r(varlist)' {
	dis "`var' is string"
	qui replace `var' = "PII" if `var' != ""
}
ds caller_phone_number
foreach var of varlist `r(varlist)' {
	qui replace `var' = .p if `var' != .
}

** save data
save "${replication_dir}/Data/01_raw/round4_data_14.12.dta", replace


use "${replication_dir}/Data/01_raw/round3_data_21.11.dta", clear
ds callern name_of_respondent phone_number_of_respondent
foreach var of varlist `r(varlist)' {
	dis "`var' is string"
	qui replace `var' = "PII" if `var' != ""
}
ds caller_phone_number
foreach var of varlist `r(varlist)' {
	qui replace `var' = .p if `var' != .
}
** save data
save "${replication_dir}/Data/01_raw/round3_data_21.11.dta", replace


use "${replication_dir}/Data/01_raw/impact10.102020Final.dta", clear
ds callern name_of_respondent phone_number_of_respondent
foreach var of varlist `r(varlist)' {
	dis "`var' is string"
	qui replace `var' = "PII" if `var' != ""
}
ds caller_phone_number
foreach var of varlist `r(varlist)' {
	qui replace `var' = .p if `var' != .
}
** save data
save "${replication_dir}/Data/01_raw/impact10.102020Final.dta", replace


use "${replication_dir}/Data/01_raw/impact_covid_roundFINAL.dta", clear
ds callern name_of_respondent phone_number_of_respondent
foreach var of varlist `r(varlist)' {
	dis "`var' is string"
	qui replace `var' = "PII" if `var' != ""
}
ds caller_phone_number
foreach var of varlist `r(varlist)' {
	qui replace `var' = .p if `var' != .
}

** save data
save "${replication_dir}/Data/01_raw/impact_covid_roundFINAL.dta", replace
