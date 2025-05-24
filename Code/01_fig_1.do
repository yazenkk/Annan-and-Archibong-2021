/*
Figure 1
*/

**Data Collection- Plot Data Days - round 0, 1, 2, 3, 4
********************************************************
********************************************************
use "${data_dir}/DATA/Round_1/impact10.102020Final.dta", clear
gen round =1
** add-round 2
append using "${data_dir}/DATA/Round_2/impact_covid_roundFINAL.dta"
replace round=2 if missing(round)
tab round
** add-round 3
append using "${data_dir}/DATA/Round_3/round3_data_21.11.dta"
replace round=3 if missing(round)
tab round
** add-round 4
append using "${data_dir}/DATA/Round_4/round4_data_19.12.dta"
replace round=4 if missing(round)
tab round
*keep if interviewn_result==1

append using "${sample_dir}/ZeroScoreData_26_09_p1.dta"
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
*local levels 29sep2020 10oct2020 20oct2020 29oct2020 01nov2020 11nov2020 29nov2020
*scatter yobs edates, sort msymbol(Oh) color(blue) , xla(`levels', valuelabel angle(70) labsize(vsmall)) ytitle("Number of subjects") xtitle("Date of phone survey")
hist edates, ///
 xline(`=d(27oct2020)' `=d(29oct2020)', lp(dash)) text(350 `=d(28oct2020)' "Intervention I", orient(vert)) ///
 xline(`=d(24nov2020)' `=d(26nov2020)', lp(dash)) text(350 `=d(25nov2020)' "Intervention II", orient(vert)) ///
 text(383 `=d(18sep2020)' "Data:  " "step 0" 185 `=d(04oct2020)' "Data  " "wave I" 255 `=d(23oct2020)' "Data  " "wave II" 185 `=d(06nov2020)' "Data  " "wave III" 185 `=d(05dec2020)' "Data " "wave IV") ///
 text(20 `=d(19sep2020)' "N=1,993" 20 `=d(04oct2020)' "n=1,131" 20 `=d(24oct2020)' "N=1,1043" 20 `=d(06nov2020)' "N=1,048" 20 `=d(03dec2020)' "N=0997", size(small) color(blue)) ///
 frequency discrete  xla(`=d(13sep2020)' `=d(25sep2020)' `=d(29sep2020)' `=d(10oct2020)' `=d(20oct2020)' `=d(29oct2020)' `=d(01nov2020)' `=d(11nov2020)' `=d(28nov2020)' `=d(09dec2020)', valuelabel angle(50) labsize(small)) ytitle("Number of subjects") xtitle("Date of phone survey") fcolor(green) lcolor(black) ///
 title("") graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid)
 *frequency discrete  xla(#10, valuelabel angle(50) labsize(vsmall)) ytitle("Number of subjects") xtitle("Date of phone survey") fcolor(green) lcolor(black) ///
 *title("")
 *frequency discrete  xla(`levels', valuelabel angle(50) labsize(vsmall)) ytitle("Number of subjects") xtitle("Date of phone survey") fcolor(green) lcolor(black) ///
 *title("")
*gr export "${data_dir}/_Francis_Impacts/paper/results/datacollection.eps", replace
gr export "${data_dir}/_Francis_Impacts/paper/results/datacollectionr.eps", replace

/* no round 0
levelsof edates, local(levels)
*local levels 29sep2020 10oct2020 20oct2020 29oct2020 01nov2020 11nov2020 29nov2020
*scatter yobs edates, sort msymbol(Oh) color(blue) , xla(`levels', valuelabel angle(70) labsize(vsmall)) ytitle("Number of subjects") xtitle("Date of phone survey")
hist edates, xline(`=d(27oct2020)' `=d(29oct2020)', lp(dash)) text(220 `=d(28oct2020)' "Intervention I", orient(vert)) ///
 xline(`=d(24nov2020)' `=d(26nov2020)', lp(dash)) text(220 `=d(25nov2020)' "Intervention II", orient(vert)) ///
 text(175 `=d(04oct2020)' "Data  " "wave I" 245 `=d(23oct2020)' "Data  " "wave II" 175 `=d(06nov2020)' "Data  " "wave III" 170 `=d(30nov2020)' "Data  " "wave IV") ///
 frequency discrete  xla(`levels', valuelabel angle(65) labsize(vsmall)) ytitle("Number of subjects") xtitle("Date of phone survey") fcolor(green) lcolor(black) ///
 title("Data Collection")
*/
 
 
 

 

 
 
 
