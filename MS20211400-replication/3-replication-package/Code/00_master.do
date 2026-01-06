*-------------------------------------------------------------------------------
/*	
	This .do file is the master script for the replication of Annan and Archibong (2023)
	
	
*	Author: Yazen Kashlan
*	Date created: 5/24/2025
*	Last edited: June 3, 2025
*/	 
*-------------------------------------------------------------------------------

** Initialize parameters
clear all
set more off
timer clear
timer on 1
version 14 // to address rwolf issue across replications. Issue was byso commands
set seed 090725 

** initialize directory 
if c(username) == "yazenkashlan" {
	** Replication globals
	global project_dir "/Users/yazenkashlan/Dropbox (Personal)/covid19 paper"
	global sample_dir "${project_dir}/covid19 paper/DATA/COVID ZERO STEP/Stata"
	global replication_dir "/Users/yazenkashlan/Documents/GitHub/Annan-and-Archibong-2021/MS20211400-replication/3-replication-package"
}

** Programs
do "${replication_dir}/Code/00_programs.do"

** clean data
do "${replication_dir}/Code/00_outcomes_clean.do"
do "${replication_dir}/Code/00_outcomes_merge.do"

** Run analysis
do "${replication_dir}/Code/01_fig_1.do"
do "${replication_dir}/Code/01_fig_A3-A5.do"
do "${replication_dir}/Code/01_fig_A10.do"
do "${replication_dir}/Code/01_table_1.do"
do "${replication_dir}/Code/01_table_2_v2.do"
do "${replication_dir}/Code/01_table_3.do"
do "${replication_dir}/Code/01_table_4.do"
do "${replication_dir}/Code/01_table_5_v2.do"
do "${replication_dir}/Code/01_table_6.do"
do "${replication_dir}/Code/01_table_7.do"
do "${replication_dir}/Code/01_table_8.do"
do "${replication_dir}/Code/01_table_A3.do"
do "${replication_dir}/Code/01_table_A4-A5.do"
do "${replication_dir}/Code/01_table_A6-A9.do"

timer off 1
timer list 1

