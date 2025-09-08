/*
Generate csv format of all datasets.

*/

local files : dir "${replication_dir}/Data/01_raw" files "*.dta"
foreach file in `files' {
	dis "`file'"
	use "${replication_dir}/Data/01_raw/`file'", clear
	export delimited using "${replication_dir}/Data/01_raw/csv_copy/`file'.csv", replace
}
