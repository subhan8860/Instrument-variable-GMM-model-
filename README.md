*=============================================================================
* RESEARCH STUDY: Financial Impact of ESG Decoupling (Greenwashing)
* 
* This analysis examines how discrepancies between firms' environmental
* disclosures (ESG scores) and their actual emission performance affect
* financial outcomes, with consideration of R&D intensity as a moderator.
* 
* Methodology: Panel data analysis with instrumental variables (GMM)
* Sample: Firm-year observations with ESG and emissions data
* Period: [Specify years if available, e.g., 2016-2024]
* Data Sources: S&P Global, Bloomberg, Refinitiv Eikon
*=============================================================================

*---------------------------------------------------------------------------
* SECTION 1: DATA PREPARATION AND PANEL STRUCTURE
*---------------------------------------------------------------------------

* Encode firm names to create numeric identifiers
encode name, gen(id)

* Declare panel data structure: firm-level data over multiple years
xtset id years

*---------------------------------------------------------------------------
* SECTION 2: CONSTRUCTION OF KEY VARIABLES
*---------------------------------------------------------------------------

* Green Authenticity Gap (GAG) - Measures ESG decoupling/greenwashing

* GAGE: Employee-based greenwashing gap 
* Difference between emission intensity per employee (actual performance) 
* and ESG disclosure score (claimed performance)
* Higher values indicate worse greenwashing (larger performance-disclosure gap)
gen gage = ei_e - esg_ds

* GAGS: Sales-based greenwashing gap
* Difference between emission intensity per sales (actual performance)
* and ESG disclosure score (claimed performance)
gen gags = ei_s - esg_ds

* Interpretation of GAG variables:
* Positive values: Underperformance (emissions higher than ESG claims suggest)
* Negative values: Overperformance (emissions lower than ESG claims suggest)
* Zero: Perfect alignment between disclosure and performance

*---------------------------------------------------------------------------
* SECTION 3: DESCRIPTIVE STATISTICS AND CORRELATIONS
*---------------------------------------------------------------------------

//Descriptive Statistics 
* Generate summary statistics for all key variables
sum roa roe tobinsq gags gage rd_i ta td revenue fa cur_mkt_cap no_emply 

* Variables description:
* roa: Return on Assets (profitability metric)
* roe: Return on Equity (profitability metric)
* tobinsq: Tobin's Q (market valuation metric)
* rd_i: R&D Intensity (R&D expenditure scaled by assets or sales)
* ta: Total Assets (size control)
* td: Total Debt (leverage control)
* revenue: Total Revenue (size/scale control)
* fa: Fixed Assets (capital intensity control)
* cur_mkt_cap: Current Market Capitalization (size/market value)
* no_emply: Number of Employees (size/labor intensity control)

//Correlation Matrix
* Examine bivariate relationships between variables
correlate roa roe tobinsq gags gage rd_i ta td revenue fa cur_mkt_cap no_emply 

* Purpose: Check for potential multicollinearity issues before regression
* High correlations (>0.8) may indicate multicollinearity problems

*---------------------------------------------------------------------------
* SECTION 4: MAIN REGRESSION ANALYSES - TABLE 2
*---------------------------------------------------------------------------

* ESTIMATION FOR ROA (RETURN ON ASSETS)

* Model 1: GAGE (employee-based greenwashing) effect on ROA
* Instrumental Variable approach using GMM
* Instruments: First and second lags of GAGE
* Rationale: Past greenwashing behavior affects current financial performance
* but current financial performance shouldn't affect past greenwashing
ivreg2 roa rd_i ta td revenue fa cur_mkt_cap no_emply (gage=L(1/2).gage), gmm2s first r

* Model 2: GAGS (sales-based greenwashing) effect on ROA
* Same IV approach with different greenwashing measure
ivreg2 roa rd_i ta td revenue fa cur_mkt_cap no_emply (gags=L(1/2).gags), gmm2s first r

* ESTIMATION FOR ROE (RETURN ON EQUITY)

* Model 3: GAGE effect on ROE
ivreg2 roe rd_i ta td revenue fa cur_mkt_cap no_emply (gage=L(1/2).gage), gmm2s first r

* Model 4: GAGS effect on ROE
ivreg2 roe rd_i ta td revenue fa cur_mkt_cap no_emply (gags=L(1/2).gags), gmm2s first r

*---------------------------------------------------------------------------
* SECTION 5: ROBUSTNESS CHECKS - TABLE 3
*---------------------------------------------------------------------------

* Re-estimate panel structure (ensuring correct setup)
xtset id year

* Model 5: GAGE effect on Tobin's Q (market-based measure)
ivreg2 tobinsq rd_i ta td revenue fa cur_mkt_cap no_emply (gage=L(1/2).gage), gmm2s first r

* Model 6: GAGS effect on Tobin's Q
ivreg2 tobinsq rd_i ta td revenue fa cur_mkt_cap no_emply (gags=L(1/2).gags), gmm2s first r

*---------------------------------------------------------------------------
* SECTION 6: ADDITIONAL ROBUSTNESS TESTS - TABLE 3 CONTINUED
*---------------------------------------------------------------------------

* OLS regression for comparison and diagnostics
reg tobinsq gags rd_i ta td revenue fa cur_mkt_cap no_emply

* Multicollinearity test using Variance Inflation Factors (VIF)
* VIF > 10 indicates problematic multicollinearity
estat vif

* HETEROSKEDASTICITY TESTS FOR GAGE MODELS

* Breusch-Pagan test for heteroskedasticity
* Tests if error variance depends on independent variables
qui reg tobinsq gage rd_i ta td revenue fa cur_mkt_cap no_emply
estat hettest, iid

* White's test for heteroskedasticity (more general form)
qui reg tobinsq gage rd_i ta td revenue fa cur_mkt_cap no_emply
estat imtest, white

* Generalized Least Squares (GLS) estimation accounting for panel heteroskedasticity
xtgls tobinsq gage rd_i ta td revenue fa cur_mkt_cap no_emply, panels(het) igls

* HETEROSKEDASTICITY TESTS FOR GAGS MODELS
qui reg tobinsq gags rd_i ta td revenue fa cur_mkt_cap no_emply
estat hettest, iid

qui reg tobinsq gags rd_i ta td revenue fa cur_mkt_cap no_emply
estat imtest, white

xtgls tobinsq gags rd_i ta td revenue fa cur_mkt_cap no_emply, panels(het) igls

*---------------------------------------------------------------------------
* SECTION 7: HETEROGENEITY TESTS - TABLE 5
*---------------------------------------------------------------------------

* Sub-sample analysis: Below Average Revenue firms

* Model 7: GAGE effect for below-average revenue firms
ivreg2 tobinsq rd_i ta td revenue fa cur_mkt_cap no_emply (gage=L(1/2).gage), gmm2s first r, if group=="Below Average"

* Model 8: GAGS effect for below-average revenue firms
ivreg2 tobinsq rd_i ta td revenue fa cur_mkt_cap no_emply (gags=L(1/2).gags), gmm2s first r, if group=="Below Average"

* Sub-sample analysis: Above Average Revenue firms

* Model 9: GAGE effect on ROE for above-average revenue firms
ivreg2 roe rd_i ta td revenue fa cur_mkt_cap no_emply (gage=L(1/2).gage), gmm2s first r, if group=="Above Average"

* Model 10: GAGS effect on ROE for above-average revenue firms
ivreg2 roe rd_i ta td revenue fa cur_mkt_cap no_emply (gags=L(1/2).gags), gmm2s first r, if group=="Above Average"

*---------------------------------------------------------------------------
* SECTION 8: MODERATING EFFECTS - TABLE 5 (CONTINUED)
*---------------------------------------------------------------------------

* Create interaction terms to test R&D intensity as moderator

* Interaction: Greenwashing gap × R&D intensity
* Tests whether R&D investment mitigates negative effects of greenwashing
gen gagerd_i = gage * rd_i  // GAGE × R&D interaction
gen gagsrd_i = gags * rd_i  // GAGS × R&D interaction

* Model 11: Moderating effect of R&D on GAGE-ROE relationship
ivreg2 roe rd_i ta td revenue fa cur_mkt_cap no_emply gagerd_i (gage=L(1/2).gage), gmm2s first r

* Model 12: Moderating effect of R&D on GAGS-ROE relationship
ivreg2 roe rd_i ta td revenue fa cur_mkt_cap no_emply gagsrd_i (gags=L(1/2).gags), gmm2s first r
