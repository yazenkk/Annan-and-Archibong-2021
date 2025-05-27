/*
Table A3
*/


***********************************
use "${replication_dir}/Data/03_clean/end1_end2.dta", replace	


*Validity and balanced-yes? redo again to verify
********************************************************
********************************************************
tab i11 if end==1, miss
sum  female0 akan0 married0 ageYrs0 jhs0 hhsize0 selfEmploy0 informal0 incomegrp0 motherTogether noReligion spouseTogether ageMarried if end==1
sum pov_likelihood if end==1
sum awareofCOVID0 Trust previouslock self_hseWork0 bd30 if end==1
sum needToCOVID unableCall7days unableToCOVID unableTrans7days bd10 bd20 bd30 ct1a0 ct1b0 ct2a0 ct2b0 if end==1
sum totExp7days threatenPartner hitPartner logk10 severe_distress tiredCOVID m110 m120 m130 m140 if end==1

