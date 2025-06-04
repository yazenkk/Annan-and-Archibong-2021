/*
Figure A10
*/

***********************************
clear all
use "${replication_dir}/Data/03_clean/end1_end2.dta", replace

** Figure A10
*3. social networks #2-risk sharing: cc improves or ejunivates perishing informal insurance arrangs? 
* we measure: c.consumption taking adv of our indiv panel on consumption?
*see: https://www.jstor.org/stable/2937654?seq=16 

/*
cdfplot xgrowth if (xgrowth>-650 & xgrowth<100), ///
  xline(-23.6, lp(dash) lw(vthin)) text(0.97 -100 "Shock: Median [-24%]", size(vsmall)) ///
  xline(-10.3, lp(solid) lw(vthin)) text(0.05 80 "No shock: Median [-10%]", size(vsmall)) ///
  by(previouslock) opt1(lc() lp(solid dash)) ///
  xtitle("Percent consumption growth") ytitle("Cumulative Probability") legend(pos(7) row(1) stack label(1 "No lockdown shock") label(2 "Lockdown shock"))
*/
cdfplot xgrowth if (xgrowth>-300 & xgrowth<100), ///
  by(previouslock) opt1(lc() lp(solid dash)) ///
  xtitle("Percent consumption growth") ytitle("Cumulative Probability") legend(pos(7) row(1) stack label(1 "Outside lockdown") label(2 "Inside lockdown (negative consumption shock)") size(small) region(lcolor(none))) ///
  graphregion(color(white)) plotregion(fcolor(white)) ylab(, nogrid)
gr export "${replication_dir}/Output/Figures/ejconsumpgrowthShock_graph.eps", replace
ksmirnov xgrowth if (xgrowth>-300 & xgrowth<100), by(previouslock) exact //p-val=0.020
*Title: "Distribution of consumption growth among individuals located outside and inside lockdown areas
*Note: Figure plots the distribution (CDF) of consumption growth per week at endline for the different subsamples (lockdown areas vs non-lockdown areas). Observations are at the individual level. Median (mean) percent consumption growth is -13% (-45%) for individuals in lockdown areas and -8% (-27%) for those in non-lockdown areas. From a Kolmogorov–Smirnov (KS) test for the equality of distributions, p-value equal 0.020 (for equality test, we trimmed the individual consumption growth outcome at the 5% level). Equality tests reject the null that the distributional pairs are equal.

