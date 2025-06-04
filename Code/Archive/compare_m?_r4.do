use "/Users/yazenkashlan/Dropbox (Personal)/covid19 paper/IMPACT_COVID19 DATA/DATA/Round_4/round4_data_19.12.dta", clear
keep if interviewn_result  == 1
isid caseidx 
keep caseidx m*
rename m* n*
tempfile r4_1912
save	`r4_1912'
use "/Users/yazenkashlan/Dropbox (Personal)/covid19 paper/IMPACT_COVID19 DATA/DATA/Round_4/round4_data_14.12.dta", clear
keep if interviewn_result  == 1
isid caseidx 
keep caseidx m*
// cf _all using `r4_1912'
merge 1:1 caseidx using `r4_1912'
order caseidx m1 n1 m2 n2 m3 n3
sort m1 m2 m3 
