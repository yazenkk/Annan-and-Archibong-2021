/*
Figure 1
*/

set graphics off

**Data Collection- Plot Data Days - round 0, 1, 2, 3, 4
********************************************************
********************************************************
use "${replication_dir}/Data/01_raw/impact10.102020Final.dta", clear
gen round =1
** add-round 2
append using "${replication_dir}/Data/01_raw/impact_covid_roundFINAL.dta"
replace round=2 if missing(round)
tab round
** add-round 3
append using "${replication_dir}/Data/01_raw/round3_data_21.11.dta"
replace round=3 if missing(round)
tab round
** add-round 4
append using "${replication_dir}/Data/01_raw/round4_data_14.12.dta"
replace round=4 if missing(round)
tab round

append using "${replication_dir}/Data/01_raw/ZeroScoreData_26_09_p1.dta"
replace round=0 if missing(round)
tab round
replace date_of_interview=12092020 if (date_of_interview==1609 | date_of_interview==1709 | date_of_interview==1809 | date_of_interview==2009 | date_of_interview==2109 | date_of_interview==2209 | date_of_interview==1609202)
replace dateinterviewend = date_of_interview if round==0

keep if (interviewn_result==1 | q2==1)
tab round

gen long dates = dateinterviewend //lost precision >7 digits?
tostring dates, replace format(%08.0f)
replace dates = "0" + dates if length(dates) == 7
order dateinterviewend dates
gen edates = date(dates,"DMY")
format edates %td


levelsof edates, local(levels)
hist edates, ///
 xline(`=d(27oct2020)' `=d(29oct2020)', lp(dash)) text(350 `=d(28oct2020)' "Intervention I", orient(vert)) ///
 xline(`=d(24nov2020)' `=d(26nov2020)', lp(dash)) text(350 `=d(25nov2020)' "Intervention II", orient(vert)) ///
 text(383 `=d(18sep2020)' "Data:  " "step 0" 185 `=d(04oct2020)' "Data  " "wave I" 255 `=d(23oct2020)' "Data  " "wave II" 185 `=d(06nov2020)' "Data  " "wave III" 185 `=d(05dec2020)' "Data " "wave IV") ///
 text(20 `=d(19sep2020)' "N=1,993" 20 `=d(04oct2020)' "n=1,131" 20 `=d(24oct2020)' "N=1,1043" 20 `=d(06nov2020)' "N=1,048" 20 `=d(03dec2020)' "N=0997", size(small) color(blue)) ///
 frequency discrete  xla(`=d(13sep2020)' `=d(25sep2020)' `=d(29sep2020)' `=d(10oct2020)' `=d(20oct2020)' `=d(29oct2020)' `=d(01nov2020)' `=d(11nov2020)' `=d(28nov2020)' `=d(09dec2020)', valuelabel angle(50) labsize(small)) ytitle("Number of subjects") xtitle("Date of phone survey") fcolor(green) lcolor(black) ///
 title("") graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid)
gr export "${replication_dir}/Output/Figures/figure_1.eps", replace // datacollectionr

