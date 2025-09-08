/*
De-identify
*/

use "${replication_dir}/Data/00_raw_wID/ZeroScoreData_26_09_p1.dta", clear
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


use "${replication_dir}/Data/00_raw_wID/select1396Final_sample.dta", clear
ds q1a1 q1a2 headnX address phone phoneStar  headn memname head_name addresss phone_number interviewer_name
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



use "${replication_dir}/Data/00_raw_wID/round4_data_14.12.dta", clear
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


use "${replication_dir}/Data/00_raw_wID/round3_data_21.11.dta", clear
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


use "${replication_dir}/Data/00_raw_wID/impact10.102020Final.dta", clear
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


use "${replication_dir}/Data/00_raw_wID/impact_covid_roundFINAL.dta", clear
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

local list_dtas MobileCredit20GHS_371list_Wave1 MobileCredit20GHS_371list_Wave2 MobileCredit40GHS_376list
foreach dta in `list_dtas' {
	use "${replication_dir}/Data/00_raw_wID/`dta'.dta", clear
	ds PhoneNumber
	foreach var of varlist `r(varlist)' {
		dis "`var' is string"
		qui replace `var' = "PII" if `var' != ""
	}

	** save data
	save "${replication_dir}/Data/01_raw/`dta'.dta", replace
}

