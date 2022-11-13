library(tidyverse)
library(ggplot2)
library(dplyr)
#library(readr)
library(lubridate)
library(ggridges)

#https://data.cityofnewyork.us/Public-Safety/NYPD-Complaint-Data-Current-Year-To-Date-/5uac-w243
#https://towardsdatascience.com/analysis-of-nyc-reported-crime-data-using-pandas-821753cd7e22
#https://www.kaggle.com/code/spoons/nyc-crime-complaints-guided-eda-with-shiny-app

#Some PDF Notes On Open Data Site:
## Information is accurate as of the date it was queried from the system of record, but should be considered a close approximation of current records, due to complaint revisions and updates.
## The Report Date represents the date the incident was actually reported to the NYPD. This dataset is released based on the date the incident was reported, not necessarily when it occurred. Some crimes may have occurred years before they were reported (except for murder)
## To further protect victim identities, rape and sex crime offenses have been located as occurring at the police station house within the precinct of occurrence
## Investigation reports have been excluded to better ensure relevance and reduce extraneous material. These represent complaint reports taken that do not indicate or imply that any criminal activity has occurred; for example, a natural death of an elderly person in a nursing home or a report of lost property that has not been stolen.
## Some mala prohibita offenses do not require a complaint report and may not be represented accurately, or at all, in this dataset. (ex some drug, tresspassing, prostitution)

df_raw <- read_csv('C:/Users/Devan/Downloads/NYPD_Complaint_Data_Current__Year_To_Date_.csv')
View(df_raw)


df_working <- df_raw %>% 
  rename( #renaming key fields for ease of use
          Precinct      = ADDR_PCT_CD   #precinct code
         ,Borough       = BORO_NM   
         ,From_Date     = CMPLNT_FR_DT  
         ,From_Time     = CMPLNT_FR_TM
         ,To_Date       = CMPLNT_TO_DT
         ,To_Time       = CMPLNT_TO_TM
         ,Report_Date   = RPT_DT
         ,Jurisdiction  = JURIS_DESC    #PD, Fire, etc
         ,Level_of_Offense = LAW_CAT_CD
         ,Offense       = OFNS_DESC
         ,Park          = PARKS_NM
         ,Premise       = PREM_TYP_DESC
         #other key fields but dont need to rename
           #SUSP_AGE_GROUP	
           #SUSP_RACE	
           #SUSP_SEX
           #VIC_AGE_GROUP	
           #VIC_RACE	
           #VIC_SEX         #(D=Business/Organization,E=PSNY/People of the State of New York (aka the government), F=Female,M=Male, L is Unknown but probably law enforcement)
           #Latitude	      #approximate, also just PD precint address in some cases
           #Longitude
         
  ) %>%
    mutate(
         #get a flag for outside vs inside
         Inside_Outside = case_when ( LOC_OF_OCCUR_DESC %in% c("FRONT OF" , "OPPOSITE OF" , "REAR OF") ~ "OUTSIDE"
                                     ,TRUE ~ LOC_OF_OCCUR_DESC)
         #use from date and report date if null. If to_date then just use from date and we can argue it averages out since new reports will start as other end
         ,Incident_Date_raw = case_when (is.null(From_Date) ~ Report_Date
                                     ,TRUE  ~ From_Date
                                    )
         #flag if estimated (ie from date is null or to date is populated)
         ,Incident_Date_Estimated_Flag = case_when ( is.null(From_Date) ~ 'Y'
                                                     ,!is.null(To_Date) ~ 'Y'
                                                     ,TRUE ~ 'N'
                                                   )
         #if victim was a person (not a business/govt)
         ,VIC_Individual_Flag = case_when (VIC_SEX %in% c("M","F","L") ~ 'Y'
                                           ,TRUE ~ 'N'
                                          )
  ) 

df_working <- df_working %>% 
        mutate(
              #creating date and time together for lubridate
              ,Incident_Date = as.Date(Incident_Date_raw, format = '%m/%d/%Y')
              ,Incident_Datetime = as.POSIXct(paste(Incident_Date_raw,From_Time), format = '%m/%d/%Y %H:%M:%S')
              ,Complaint_Count = 1     #maybe want to add like a intensity value or something?
              ) %>%
        mutate(
              Incident_HourTime = hour(Incident_Datetime) + minute(Incident_Datetime)/60
              ) %>%
  select(  
        CMPLNT_NUM
        ,Complaint_Count
        #Location Info
          ,Precinct     
          ,Borough   
          ,Park         
          ,Premise      
          ,Latitude	   
          ,Longitude
          ,Inside_Outside
        #Time Info
          ,Incident_Date
          ,Incident_Datetime
          ,Incident_HourTime
          ,Incident_Date_Estimated_Flag
            #,From_Date    
            #,From_Time    
            #,To_Date      
            #,To_Time      
            #,Report_Date  
        #Offense Info
        ,Offense      
        ,Level_of_Offense
        ,Jurisdiction 
        ,SUSP_AGE_GROUP
        ,SUSP_RACE	
        ,SUSP_SEX
        ,VIC_Individual_Flag
        ,VIC_AGE_GROUP
        ,VIC_RACE	
        ,VIC_SEX     
)

View(df_working)

df_working_time <- df_working %>% 
  filter(year(Incident_Date) >= 2022) %>%
  mutate(
    Incident_Month = month(Incident_Date)
    ,Incident_DayOfWeek = wday(Incident_Date, label = TRUE, abbr = TRUE)
    )  %>%
  #group_by(Incident_Date)  %>%
  group_by(Incident_Month)  %>%
  #group_by(Incident_DayOfWeek)  %>%
  summarize(Complaint_Count = n() )

#df_working_time

ggplot(df_working_time, aes(x=Incident_Date, y=Complaint_Count )) + geom_line()
ggplot(df_working_time, aes(x=Incident_Month, y=Complaint_Count )) + geom_line() #mostly in summer
ggplot(df_working, aes(x=wday(Incident_Date, label = TRUE, abbr = TRUE))) + geom_bar()  #mostly on Fri or Wed surprisingly

ggplot(df_working, aes(x = Incident_HourTime, y=wday(Incident_Date, label = TRUE, abbr = TRUE) )) +
  geom_density_ridges()  #peaks around 6pm maybe, need to filter things tho
  #spike at noon - maybe data qualtiy

ggplot(df_working, aes(x = Incident_HourTime, y=VIC_SEX )) +
  geom_density_ridges()  #D compared to rest?




########################## extra
df_working$Incident_Datetime
hour(df_working$Incident_Datetime)

as.Date(df_working$Incident_Date, format = '%m/%d/%Y')
as.Date(paste(df_working$Incident_Date,df_working$From_Time), format = '%m/%d/%Y %H:%M:%S')






