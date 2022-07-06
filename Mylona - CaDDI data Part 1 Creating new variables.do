********************************************************************************************************************************
********************************************** CaDDI Data: Time use & Wellbeing ************************************************
******************************************************** Mylona, (&?) **********************************************************
********************************************************** CTUR/WWCW ***********************************************************
********************************************************************************************************************************

********************************************************************************************************************************
*************************************************** Opening/ using the data*****************************************************
********************************************************************************************************************************

* Use the global macro to tell Stata the location of the data - fill in the remaining to specify the path where the data file is 
* This is more helpful if you have several data files in one folder
global CaDDI_folder "C:\Users\"
use "$CaDDI_folder/uk_6_wave_caddi.dta"
* Otherwise, you can tell Stata to 'use' a specific file, eg.:
use "C:\Users\Elena\Desktop\Analysis\uk_6_wave_caddi.dta" 

********************************************************************************************************************************
**************************************************** Wide to long format, saved ************************************************
********************************************************************************************************************************

* The data is currently avaibale in wide format, and you can work in both wide and long format
* Most of the times it comes down to the researcher, so for this ananlysis, we will be working in a long format 
* Another reason to work in a long format, is that there is a lot of help online when it comes to data management
* (due to similarities in format with panel data)
reshape long pri sec loc dev enj whoa whob whoc whod, i( mainid diaryord ) j(slot) 

********************************************************************************************************************************
************************************************* Sort by ID, diary order and slot *********************************************
********************************************************************************************************************************

* Sort the data, so it appears as participant ID, Diary order and Slot 
sort mainid diaryord slot


********************************************************************************************************************************
********************************************************* Weighting the data ***************************************************
********************************************************************************************************************************

* There are 3 weight variables available. The CTUR reccommends to use the 'reccommdended weight' variable.
* You can run this at the beginning of your analysis, by typing:
svyset [pweight= daywtq4]

********************************************************************************************************************************
************************************** Broad activities: New variable derived from primary activities **************************
********************************************************************************************************************************

* This code creates a variable, "Broad", which takes a different value for each broad category of activities. 
* This coarsens activity data, for example by treating "sleeping", "washing" and "resting" as the same category.
* Sleep/Personal care: Sleeping 
gen broad = 1 if (pri == 101)
* Sleep/Personal care: Resting
replace broad = 1 if (pri == 102)
* Sleep/Personal care: Washing, dressing
replace broad = 1 if (pri == 103)
* Eat/Drink: Eating or Drinking
replace broad = 2 if (pri == 104)
* housework > Preparing food, cooking etc
replace broad = 3 if (pri == 105)
* housework > Cleaning tidying housework .
replace broad = 3 if (pri == 106)
* housework > Clothes washing, mending .
replace broad =3 if (pri == 107)
* housework > Maintenance DIY, etc .
replace broad = 3 if (pri == 108)
* services > Personal services .
replace broad = 4 if (pri == 109)
* services > Shopping, bank etc incl. internet .
replace broad = 4 if (pri == 126)	
* leisure > Church, temple, synagogue, prayer.
replace broad = 5 if (pri == 110)
* leisure > Recreational courses.
replace broad = 5 if (pri == 119)
* leisure > Reading including e-books.
replace broad = 5 if (pri == 128)
* leisure > Going out to eat, drink.
replace broad = 5 if (pri == 130)
* leisure > Walking, dog walking.
replace broad = 5 if (pri == 131)
* leisure > eating or drinking in a restaurant or caf?? .
replace broad = 5 if (pri == 133)
* leisure > Cinema, theatre, sport etc.
replace broad = 5 if (pri == 135)
* leisure > Hobbies
replace broad = 5 if (pri == 136)
* travel > Travel: walking, jogging .
replace broad = 6 if (pri == 111)
* travel > Travel: cycle .
replace broad = 6 if (pri == 112)
* travel > Travel: by car.
replace broad = 6 if (pri == 113)
* travel > Travel: by bus, tram .
replace broad = 6 if (pri == 114)
* travel > Travel: by train, tube.
replace broad = 6 if (pri == 115)
* travel > Travel: other .
replace broad = 6 if (pri == 116)
* work > Paid work including at home .
replace broad = 7 if (pri == 117)
* work > Formal education .
replace broad = 7 if (pri == 118)
* work > Work or study break .
replace broad = 7 if (pri == 125)
* unpaidwork > Voluntary work for organisation.
replace broad = 8 if (pri == 120)
* unpaidwork > Caring for own child .
replace broad = 8 if (pri == 121)
* unpaidwork > Caring for other children.
replace broad = 8 if (pri == 122)
* unpaidwork > Help, caring for cores adult .
replace broad = 8 if (pri == 123)
* unpaidwork > Help, caring for no coresidents .
replace broad = 8 if (pri == 124)
* media > Watching tv, video, DVD, music .
replace broad = 9 if (pri == 127)
* media > Playing computer games .
replace broad = 9 if (pri == 132)
* media > Telephone, text, email, letters.
replace broad = 9 if (pri == 134)
* sports > Playing sports, exercise.
replace broad = 10 if (pri == 129)
* other > Write-in, not code .
replace broad = 11 if (pri == 137)
label variable broad "Broad activities"
label define broadx 1 "Sleeping/Personal care" 2 "Eating/drinking" 3 "Housework" 4 "Services" 5 "Leisure" 6 "Travelling" 7 "Paid work/Education" 8 "Unpaid work" 9 "Media" 10 "Sports" 11 "Other"
label values broad broadx
tab broad
tab pri broad 

********************************************************************************************************************************
*********************************** Broad primary activities - Duration + Dummy for participation ******************************
********************************************************************************************************************************

* This code identifies for the broad classes of primary activity
* The duration of each, and a binary indicator of whether the participant spent any time doing them

*************************************** Sleeping/Relaxing/Personal care (primary activity) *************************************
by mainid diaryord, sort: egen personall = total(pri == 101 | pri == 102 | pri == 103)
gen personal01=personall
recode personal01 (1/144=1) (0=0)
label variable personal01 "Personal care including sleeping and relaxing"
gen personal=personall*10

*********************************************** Eating/drinking (primary activity) *********************************************
by mainid diaryord, sort: egen eatingl = total(pri == 104)
gen eating01=eatingl
recode eating01 (1/144=1) (0=0)
label variable eating01 "Eating/drinking"
gen eating=eatingl*10

*************************************************** Housework (primary activity) ***********************************************
by mainid diaryord, sort: egen houseworkl = total(pri == 105 | pri == 106 | pri == 108 | pri == 109)
gen housework01=houseworkl
recode housework01 (1/144=1) (0=0)
label variable housework01 "Housework"
gen housework=houseworkl*10

*************************************************** Services (primary activity) ************************************************
by mainid diaryord, sort: egen servicesl = total(pri == 109 | pri == 126)
gen services01=servicesl
recode services01 (1/144=1) (0=0)
label variable services01 "Services"
gen services=servicesl*10

*********************************************** Leisure activities (primary activity) ******************************************
by mainid diaryord, sort: egen leisurel = total(pri == 110 | pri == 119 | pri == 128 | pri == 130 | pri == 131 | pri == 133 | pri == 135 | pri == 136)
gen leisure01=leisurel
recode leisure01 (1/144=1) (0=0)
label variable leisure01 "Leisure"
gen leisure=leisurel*10

****************************************************** Travel (primary activity) ***********************************************
by mainid diaryord, sort: egen travell = total(pri == 111 | pri == 112 | pri == 113 | pri == 114 | pri == 115 | pri == 116)
gen travel01=travell
recode travel01 (1/144=1) (0=0)
label variable travel01 "Travel"
gen travel=travell*10

******************************************************* Work (primary activity) ************************************************
by mainid diaryord, sort: egen workl = total(pri == 117 | pri == 118 | pri == 125)
gen work01=workl
recode work01 (1/144=1) (0=0)
label variable work01 "Work"
gen work=workl*10

****************************************************** Unpaid (primary activity) **********************************************
by mainid diaryord, sort: egen unpaidl = total(pri == 120 | pri == 121 | pri == 122 | pri == 123 | pri == 124)
gen unpaid01=unpaidl
recode unpaid01 (1/144=1) (0=0)
label variable unpaid01 "Unpaid"
gen unpaid=unpaidl*10

******************************************************** Media (primary activity) **********************************************
by mainid diaryord, sort: egen medial = total(pri == 127 | pri == 132 | pri == 134)
gen media01=medial
recode media01 (1/144=1) (0=0)
label variable media01 "Media"
gen media=medial*10

******************************************************** Sports (primary activity) *********************************************
by mainid diaryord, sort: egen sportsl = total(pri == 129)
gen sports01=sportsl
recode sports01 (1/144=1) (0=0)
label variable sports01 "Sports"
gen sports=sportsl*10

********************************************************* Other (primary activity) *********************************************
by mainid diaryord, sort: egen otherl = total(pri == 137)
gen other01=otherl
recode other01 (1/144=1) (0=0)
label variable other01 "Other"
gen other=otherl*10


********************************************************************************************************************************
*************************************************** Number of episode changes **************************************************
************************************** Primary activity, enjoyment, location, co-presence **************************************
********************************************************************************************************************************
	
* This code identifies the number of 'episode' changes for an individual diary
* There are four ways of identifying an episode change -  from one activity, level of enjoyment, location, or co-presence
* If a person has the same values for all of these all day, that is 0 episode changes 
* If they change once, that is 1 episode change, if they change twice, that is two - even if the change is back to the characteristic of the first episode

********************************************************************************************************************************
***************************************** Number of episode changes: Primary activity ******************************************
********************************************************************************************************************************
gen slot1 = slot
replace slot1 = slot1 +144 if(diaryord == 2)
replace slot1 = slot1 +288 if(diaryord == 3)
replace slot1 = slot1 +432 if(diaryord == 4)
xtset mainid slot1
gen change_activity = pri - l.pri
gen tag=0
replace tag = 1 if( change_activity != 0 ) & change_activity!=.
* Caluclate a variable that counts the number of changes for each participant (every 144) 
egen day1tags = total( tag ) if(slot1 <= 144), by( mainid )
egen day2tags = total( tag )if(slot1 > 144 & slot1 <=288), by( mainid )
egen day3tags = total( tag ) if(slot1 > 288 & slot1 <=432), by( mainid )
egen day4tags = total( tag )if(slot1 > 432), by( mainid )
gen episodes = day1tags
replace episodes = day2tags if(diaryord == 2)
replace episodes = day3tags if(diaryord == 3)
replace episodes = day4tags if(diaryord == 4)


********************************************************************************************************************************
***************************************** Number of episode changes: Enjoyment level *******************************************
********************************************************************************************************************************
gen slot2=slot
replace slot2 = slot2 +144 if(diaryord == 2)
replace slot2 = slot2 +288 if(diaryord == 3)
replace slot2 = slot2 +432 if(diaryord == 4)
xtset mainid slot2
gen change_enj = enj - l.enj
gen tagenj=0
replace tagenj = 1 if( change_enj != 0 ) & change_enj!=.
* Caluclate a variable that counts the number of enjoyment changes for each participant (every 144) 
egen day1tagsenj = total( tagenj ) if(slot2 <= 144), by( mainid )
egen day2tagsenj = total( tagenj )if(slot2 > 144 & slot2 <=288), by( mainid )
egen day3tagsenj = total( tagenj ) if(slot2 > 288 & slot2 <=432), by( mainid )
egen day4tagsenj = total( tagenj )if(slot2 > 432), by( mainid )
gen episodesenj = day1tagsenj
replace episodesenj = day2tagsenj if(diaryord == 2)
replace episodesenj = day3tagsenj if(diaryord == 3)
replace episodesenj = day4tagsenj if(diaryord == 4)

********************************************************************************************************************************
********************************************** Number of episode changes: Location *********************************************
********************************************************************************************************************************
gen slot3=slot
replace slot3 = slot3 +144 if(diaryord == 2)
replace slot3 = slot3 +288 if(diaryord == 3)
replace slot3 = slot3 +432 if(diaryord == 4)
xtset mainid slot3
gen change_loc = loc - l.loc
gen tagloc=0
replace tagloc = 1 if( change_loc != 0 ) & change_loc!=.
* Caluclate a variable that counts the number of location changes for each participant (every 144) 
egen day1tagsloc = total( tagloc ) if(slot3 <= 144), by( mainid )
egen day2tagsloc = total( tagloc )if(slot3 > 144 & slot2 <=288), by( mainid )
egen day3tagsloc = total( tagloc ) if(slot3 > 288 & slot2 <=432), by( mainid )
egen day4tagsloc = total( tagloc )if(slot3 > 432), by( mainid )
gen episodesloc = day1tagsloc
replace episodesloc = day2tagsloc if(diaryord == 2)
replace episodesloc = day3tagsloc if(diaryord == 3)
replace episodesloc = day4tagsloc if(diaryord == 4)

********************************************************************************************************************************
****************************************** Number of episode changes: Co-presence (person A) ***********************************
********************************************************************************************************************************
gen slot4=slot
replace slot4 = slot4 +144 if(diaryord == 2)
replace slot4 = slot4 +288 if(diaryord == 3)
replace slot4 = slot4 +432 if(diaryord == 4)
xtset mainid slot4
gen change_who = whoa - l.whoa
gen tagwho=0
replace tagwho = 1 if( change_who != 0 ) & change_who!=.
* Caluclate a variable that counts the number of location changes for each participant (every 144) 
egen day1tagswho = total( tagwho ) if(slot4 <= 144), by( mainid )
egen day2tagswho = total( tagwho )if(slot4 > 144 & slot2 <=288), by( mainid )
egen day3tagswho = total( tagwho ) if(slot4 > 288 & slot2 <=432), by( mainid )
egen day4tagswho = total( tagwho )if(slot4 > 432), by( mainid )
gen episodeswho = day1tagswho
replace episodeswho = day2tagswho if(diaryord == 2)
replace episodeswho = day3tagswho if(diaryord == 3)
replace episodeswho = day4tagswho if(diaryord == 4)

*******************************************************************************************************************************
********************************************************* Week day/ Weekend day ***********************************************
*******************************************************************************************************************************

* Whether completed on a week day or a weekend day 
by mainid dday diaryord , sort: egen weekday1 = total(dday == 1 | dday == 2 | dday == 3 | dday == 4 | dday == 5 )
gen weekday=weekday1
recode weekday (1/144=1) (0=0)
label variable weekday "Weekday/Weekend day"
label define weekdayx 0 "Weekend day" 1 "Weekday" 
label values weekday weekdayx
tab dday weekday

*******************************************************************************************************************************
******************************************** KEEPING ONE SLOT PER DIARY ENTRY *************************************************
*******************************************************************************************************************************

*This code moves the data from having one row per individual/10 minute time period, to having one row per individual. 
* Essentially reducing to one diary per participant per row * 
keep if slot == 1 












