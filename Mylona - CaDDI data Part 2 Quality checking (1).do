********************************************************************************************************************************
********************************************** CaDDI Data: Time use & Wellbeing ************************************************
******************************************************** Mylona, (&?) **********************************************************
********************************************************** CTUR/WWCW ***********************************************************
********************************************************************************************************************************

********************************************************************************************************************************
******** Use the Part 1 Do file to open and sort the data, and create variables required for part of this Do file   ************
****************** Only use the command 'keep slot==1' when you finish recoding of ALL variables *******************************
********************************************************************************************************************************

********************************************************************************************************************************
*************************************************** Diary quality indicators ***************************************************
********************************************************************************************************************************

********************************************************************************************************************************
**************************************** >5 episode changes (in primary activity) **********************************************
********************************************************************************************************************************

* This code creates a binary indicator of whether a participant had 5 or more changes in primary activity
gen epi=episodes
recode epi (1/5=0) (6/144=1)
label variable epi "Episode changes"
label define epix 0 "1-5 episode changes" 1 "6-144 episode changes"
label values epi epix

********************************************************************************************************************************
*********************************************** Eating/drinking (secondary activity) *******************************************
********************************************************************************************************************************

* This code creates a binary indicator of whether a participant had reported eating/drinking as a secondary activity
by mainid diaryord, sort: egen eatingll = total(sec == 104)
gen eating001=eatingll
recode eating001 (1/144=1) (0=0)
label variable eating001 "Eating/drinking Secondary"
gen eatingsec=eatingll*10

********************************************************************************************************************************
************************************************* Reporting no secondary activity ***********************************************
********************************************************************************************************************************

* This code creates a binary variable set to 1 if particiants report no secondary activity, or zero else
by mainid diaryord, sort: egen nosec = total(sec == 138)
gen nosec01=nosec
recode nosec01 (144=1) (1/143=0)
label variable nosec01 "No secondary activity reported"
label define nosec01x 0 "Secondary activity reported" 1 "No secondary activity reported"
label values nosec01 nosec01x 


********************************************************************************************************************************
***************************************************** Diary quality: Exclusions ************************************************
********************************************************************************************************************************

* This code creates a series of indicators based on different scenarios that indicate the quality of the data at the level of an individuals' diary

* Scenario A: > 5 episode changes 
by mainid diaryord epi, sort: egen qualitya = total(epi == 1)
gen qualitya01=qualitya
recode qualitya01 (1/144=1) (0=0)
label variable qualitya01 "Quality A"
label define qualitya01x 0 "Poor" 1 "Good"
label values qualitya01 qualitya01x 

* Scenario B: > 5 episode changes and sleep/rest/personal care 
by mainid diaryord epi personal01, sort: egen qualityb = total(epi == 1 & personal01 == 1)
gen qualityb01=qualityb
recode qualityb01 (1/144=1) (0=0)
label variable qualityb01 "Quality B"
label define qualityb01x 0 "Poor" 1 "Good"
label values qualityb01 qualityb01x 

* Scenario C: > 5 episode changes and sleep/rest/personal care and eating/drinking (primary or secondary) 
by mainid diaryord epi personal01 eating01, sort: egen qualityc = total(epi == 1 & personal01 == 1 & [eating01 == 1 | eating001 == 1] )
gen qualityc01=qualityc 
recode qualityc01 (1/144=1) (0=0)
label variable qualityc01 "Quality C"
label define qualityc01x 0 "Poor" 1 "Good"
label values qualityc01 qualityc01x 
* by mainid diaryord epi personal01 eating01, sort: egen qualityl = total(epi == 1 & personal01 == 1 & eating01 == 1 )

* Scenario D. > 5 episode changes and sleep/rest/personal care and eating/drinking (primary or secondary) and at least one activity on the secondary activity category
by mainid diaryord epi personal01 eating01 nosec01, sort: egen qualityd = total(epi == 1 & personal01 == 1 & [eating01 == 1 | eating001 == 1] & nosec01==0)
gen qualityd01=qualityd 
recode qualityd01 (1/144=1) (0=0)
label variable qualityd01 "Quality D"
label define qualityd01x 0 "Poor" 1 "Good"
label values qualityd01 qualityd01x 

* Scenario E: > 5 episode changes and sleep/rest/personal care and eating/drinking (primary or secondary) and at least one activity on the secondary activity category and at least one change in location
by mainid diaryord epi personal01 eating01 nosec01 episodesloc, sort: egen qualitye = total(epi == 1 & personal01 == 1 & [eating01 == 1 | eating001 == 1] & nosec01==0 & episodesloc >= 1)
gen qualitye01=qualitye
recode qualitye01 (1/144=1) (0=0)
label variable qualitye01 "Quality E"
label define qualitye01x 0 "Poor" 1 "Good"
label values qualitye01 qualitye01x 

* Scenario F: > 5 episode changes and sleep/rest/personal care and eating/drinking (primary or secondary) and at least one activity on the secondary activity category and at least one change in location and at least one change in co-presence of others
by mainid diaryord epi personal01 eating01 nosec01 episodesloc episodeswho, sort: egen qualityf = total(epi == 1 & personal01 == 1 & [eating01 == 1 | eating001 == 1] & nosec01==0 & episodesloc >= 1 & episodeswho >=1)
gen qualityf01=qualityf
recode qualityf01 (1/144=1) (0=0)
label variable qualityf01 "Quality F"
label define qualityf01x 0 "Poor" 1 "Good"
label values qualityf01 qualityf01x 











