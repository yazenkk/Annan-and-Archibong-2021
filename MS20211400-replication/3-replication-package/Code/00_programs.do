/*
Programs to be used in Annan and Archibong replication
*/

local prog_list distplot /// figure_a5
				cdfplot /// figure_a10
				leebounds ///
				rwolf ///
				pdslasso ///
				rlasso ///
				coefplot ///
				estout ///	
				outreg2
				
** ssc packages
foreach pack in `prog_list' {
	capture which `pack'
	if _rc != 0 {
		dis as error "need to install `pack'"
		ssc install `pack'
	}
	else if _rc == 0 {
		dis as result "`pack' already installed"	
	}
}
