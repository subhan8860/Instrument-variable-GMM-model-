encode name, gen(id)
xtset id years

*Green Authenticity Gap (GAG)
*for employee GAGE is a EIE
gen gage=ei_e-esg_ds
*for Sales GAGS is a EIS
gen gags=ei_s-esg_ds

//Descriptive Statistics 
sum roa roe tobinsq gags gage rd_i ta td revenue fa cur_mkt_cap no_emply 

//Correlation Metrix
correlate roa roe tobinsq gags gage rd_i ta td revenue fa cur_mkt_cap no_emply 


// Estimation for ROA. for Table 2
// for GAGE (EIE)
ivreg2 roa rd_i ta td revenue fa cur_mkt_cap no_emply  (gage=L(1/2).gage), gmm2s first r
// for GAGS (EIS)
ivreg2 roa rd_i ta td revenue fa cur_mkt_cap no_emply  (gags=L(1/2).gags), gmm2s first r

// Estimation for ROE for Table 2
// for GAGE (EIE)
ivreg2 roe rd_i ta td revenue fa cur_mkt_cap no_emply  (gage=L(1/2).gage), gmm2s first r
// for GAGS (EIS)
ivreg2 roe rd_i ta td revenue fa cur_mkt_cap no_emply  (gags=L(1/2).gags), gmm2s first r

//Robustness Estimation for tobinsq. for Table 3
// for GAGE (EIE)
ivreg2 tobinsq rd_i ta td revenue fa cur_mkt_cap no_emply  (gage=L(1/2).gage), gmm2s first r

// for GAGS (EIS)
ivreg2 tobinsq rd_i ta td revenue fa cur_mkt_cap no_emply  (gags=L(1/2).gags), gmm2s first r

*Table 3: Results of the robustness checks.
********************************************************************************
xtset id year

// Column (1) 
ivreg2 tobinsq rd_i ta td revenue fa cur_mkt_cap no_emply  (gage=L(1/2).gage), gmm2s first r
// Column (2)
ivreg2 tobinsq rd_i ta td revenue fa cur_mkt_cap no_emply  (gags=L(1/2).gags), gmm2s first r

reg tobinsq gags rd_i ta td revenue fa cur_mkt_cap no_emply
estat vif // Multicollinearity test

// Column (3) For GAGE (EIE)
qui reg tobinsq gage rd_i ta td revenue fa cur_mkt_cap no_emply
estat hettest,iid // Breusch-Pagan test

qui reg tobinsq gage rd_i ta td revenue fa cur_mkt_cap no_emply
estat imtest, white // white test

xtgls tobinsq gage rd_i ta td revenue fa cur_mkt_cap no_emply, panels(het) igls

// Column (4) for GAGS (EIS)
qui reg tobinsq gags rd_i ta td revenue fa cur_mkt_cap no_emply
estat hettest,iid // Breusch-Pagan test

qui reg tobinsq gags rd_i ta td revenue fa cur_mkt_cap no_emply
estat imtest, white // white test

xtgls tobinsq gags rd_i ta td revenue fa cur_mkt_cap no_emply, panels(het) igls



*Table 5: Results of the heterogeneity tests.
********************************************************************************
//coloum 1 and 2
//below average Revene 
//(GAGE-EIE)
ivreg2 tobinsq rd_i ta td revenue fa cur_mkt_cap no_emply  (gage=L(1/2).gage), gmm2s first r ,if group=="Below Average"
//(GAGS-EIS)
ivreg2 tobinsq rd_i ta td revenue fa cur_mkt_cap no_emply  (gags=L(1/2).gags), gmm2s first r ,if group=="Below Average"

//coloum 1 and 2
//above average Revenue
//(GAGE-EIE)
ivreg2 roe rd_i ta td revenue fa cur_mkt_cap no_emply  (gage=L(1/2).gage), gmm2s first r ,if group=="Above Average"
//(GAGS-EIS)
ivreg2 roe rd_i ta td revenue fa cur_mkt_cap no_emply  (gags=L(1/2).gags), gmm2s first r ,if group=="Above Average"



********************************************************************************
*Table 5: Results of the moderating effect.
********************************************************************************
//For EIE*RDI
gen gagerd_i=gage*rd_i
//For EIS*RDI
gen gagsrd_i=gags*rd_i


//coloum 1 EIE
ivreg2 roe rd_i ta td revenue fa cur_mkt_cap no_emply gagerd_i (gage=L(1/2).gage), gmm2s first r 
//coloum 2 EIS
ivreg2 roe rd_i ta td revenue fa cur_mkt_cap no_emply gagsrd_i (gags=L(1/2).gags), gmm2s first r 











