********************************************************************************************************************************
********************************************** CaDDI Data: Time use & Wellbeing ************************************************
******************************************************** Mylona, (&?) **********************************************************
********************************************************** CTUR/WWCW ***********************************************************
********************************************************************************************************************************

********************************************************************************************************************************
******** Use the Part 1 Do file to open and sort the data, and create variables required for part of this Do file **************
****************** Only use the command 'keep slot==1' when you finish recoding of ALL variables *******************************
********************************************************************************************************************************

********************************************************************************************************************************
******************************************************* Enjoyment **************************************************************
********************************************************************************************************************************

********************************************************************************************************************************
*********************************************** Change in enjoyment levels *****************************************************
********************************************************************************************************************************

* This variable takes the value of 0 if the participant reported no change in their enjoyment throughout the day 
gen indifferent = episodesenj
recode indifferent (1/144=1) (0=0)
label variable indifferent "Indifferent"
label define indifferentx 0 "Indifferent" 1 "At least one change in enjoyment" 
label values indifferent indifferentx
tab dday indifferent

********************************************************************************************************************************
**************************** Enjoyment levels: Mean enjoyment level, per person, per day ***************************************
********************************************************************************************************************************

by mainid diaryord , sort: egen mean_enj = mean( enj )

********************************************************************************************************************************
********************************** Mean enjoyment statistics - For each broad activity *****************************************
***************************** Remember you need to run part of the code from Do File Part 1 ************************************
********************************************************************************************************************************

* mean_enj_personal
by mainid diaryord, sort: egen mean_enj_personall = mean( enj ) if broad==1
bysort mainid diaryord : egen mean_enj_personal = mean( mean_enj_personall )
* mean_enj_eating
by mainid diaryord, sort: egen mean_enj_eatingl = mean( enj ) if broad==2
bysort mainid diaryord : egen mean_enj_eating = mean( mean_enj_eatingl )
* mean_enj_housework
by mainid diaryord, sort: egen mean_enj_houseworkl = mean( enj ) if broad==3
bysort mainid diaryord : egen mean_enj_housework = mean( mean_enj_houseworkl )
* mean_enj_services
by mainid diaryord, sort: egen mean_enj_servicesl = mean( enj ) if broad==4
bysort mainid diaryord : egen mean_enj_services = mean( mean_enj_servicesl)
* mean_enj_leisure
by mainid diaryord, sort: egen mean_enj_leisurel = mean( enj ) if broad==5
bysort mainid diaryord : egen mean_enj_leisure = mean( mean_enj_leisurel)
* mean_enj_travel
by mainid diaryord, sort: egen mean_enj_travell = mean( enj ) if broad==6
bysort mainid diaryord : egen mean_enj_travel = mean( mean_enj_travell)
* mean_enj_work
by mainid diaryord, sort: egen mean_enj_workl = mean( enj ) if broad==7
bysort mainid diaryord : egen mean_enj_work  = mean( mean_enj_workl )
* mean_enj_unpaid
by mainid diaryord, sort: egen mean_enj_unpaidl = mean( enj ) if broad==8
bysort mainid diaryord : egen  mean_enj_unpaid = mean( mean_enj_unpaidl)
* mean_enj_media
by mainid diaryord, sort: egen mean_enj_medial = mean( enj ) if broad==9
bysort mainid diaryord : egen mean_enj_media  = mean( mean_enj_medial )
* mean_enj_sports
by mainid diaryord, sort: egen mean_enj_sportsl = mean( enj ) if broad==10
bysort mainid diaryord : egen mean_enj_sports = mean( mean_enj_sportsl)
* mean_enj_other
by mainid diaryord, sort: egen mean_enj_otherl = mean( enj ) if broad==11
bysort mainid diaryord : egen mean_enj_other = mean( mean_enj_otherl)

********************************************************************************************************************************
******************************************** KEEPING ONE SLOT PER DIARY ENTRY **************************************************
********************************************************************************************************************************

* This code moves the data for having one row per individual/10 minute time period, to having one row per individual 
* Essentially reducing to one diary per row 
keep if slot == 1 

********************************************************************************************************************************
******************************************************* DESCRIPTIVES ***********************************************************
********************************************************************************************************************************

* A few examples using the tabstat command to generate descriptive statistics
tabstat mean_enj, s(n mean SD semean min max) c(s) by(braod)
tabstat mean_enj, s(n mean SD semean min max) c(s) by(personal)
tabstat mean_enj, s(n mean SD semean min max) c(s) by(qualitya01), if indifferent==0









