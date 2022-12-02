--- 
  title: "NYC Crime"
author: "Group 32: Abhiram Gaddam, Faizan Dogar, Devan Samant"
date: "`r Sys.Date()`"
site: bookdown::bookdown_site
---
  
  # Introduction
  
  
  
  # Outline/Work/Notes
  Introduction - "Explain why you chose this topic, and the questions you are interested in studying. Provide context for readers who are not familiar with the topic."

Data
copy proposal wording back into data section
--Focus: Just around Upper Manhattan (if enough data)

Profiling
Describe any issues / problems with the data, either known or that you discover.
NULL values - 
  Binning for dates
Potential date mismatch of when crime happened vs when crime was reported
Recreate some basic statistics about the data we have using bar charts or whatever
Google to see how others used dataset
https://towardsdatascience.com/analysis-of-nyc-reported-crime-data-using-pandas-821753cd7e22
https://www.kaggle.com/datasets/adamschroeder/crimes-new-york-city
https://jingjing-ge.medium.com/analysis-of-crime-data-in-new-york-city-in-2020-e6a65edf4429
https://www.kaggle.com/code/spoons/nyc-crime-complaints-guided-eda-with-shiny-app


Data Cleaning
need a metric count of crimes
derived field of the distance from morningside park center to the rows coordinate (ie. radius nearby --need another package)
  derived field about the severity or relcassify crime - (ex parking tickets). To reduce distinct number down to something managble.
  derive day of week from the datetime field
  date cleanups using data dictionary and maybe some assumptions so that we have a more accurate point in time (just use start) 
  

Results / Graph Ideas
  Univariate/Multivariate Categorical Ideas:
      crime frequency vs gender/age group/borough --maybe bar charts or mosaics
      
  Continuous Variable Ideas:
    (Interactive) changing radius from (morningside) park to see impact on crime rate density (frequency/area of radius). Take snapshots at like .25mi, .5mi, .75 etc as x-axis and plot density on y
    Time series (over months/days of week)  - look at changes over time/seasonality
      (interactive) - control time lapse of heatmap of NYC or something
    Time (during the day) - 
  
  Map: 
  
  Ideas:
    compare NYU vs Columbia
    Compare walking vs subway (using premise)
    
  
# Tasks
1. Get coordinates data for a specific location and use that calculate the distance from each complaint --Faizan
2. We need to assign categories to crimes --Abhi
3. Look into how best to use the time variables for various time series analyses
4. General exploration of data (via online viz or R) / take notes on missing value cleanup/interesting findings --All


# Next Steps Note 2022-11-13
Agree on Data Prep Steps
Derived Fields
  - a few for time series (Devan)
      - day night
      - was time estimated or not
  - crime category (Abhi)
  - distance from XYZ location - Columbia, NYU?, tbd (Faizan)
  - Aggregate Field for Premise (3-4 values, simple to use) - like street/park/inside/subway?
    - Combines inside/outside and premise and anythign else nee(incl. something for subway)
  - "Relevant Crime for EDAV"
      - victim is an individual and crime type is relevant or some aggregate of the two
        --Abhi to look at percentages and determine how to filter. May need to recategorize and/or use the victim sex field
  - (Other flags as needed)
      --
Missing Value Analysis - Need to satisfy requirement for project
  - Describe any missing values in fields 
      For date (Devan) - Look at difference between date reported and date of incident if anything interesting 
      
      For crime type (Abhi) - There are 5 values with missing "OFNS_DESC". Since they have valid PD_CD and PD_DESC, we can impute these values from other columns with the same PD_CD
      two values are for obscenity - 594 PD_CD. categorized as sex crimes
      one values for crime pos weap - 797 PD_CD. categorized as dangerous weapons 
      one value for "place false bomb" - 648 PD_CD. No other examples of this crime. Ignore?
      one value for "noise" -  872 PD_CD. No other examples of this crime. Ignore?
      
      Placeholder for anything else 
  
Data Filtration Justification (missing and not relevant)
  Date - We only have crimes that took place (as defined by derived field above) in 1/1/2022 onward (this should remove 5%) (Devan)
  Crime Type - Use the derived field from above 
  Location? - Tentative, only look within 3.2km of Columbia (per derived field above)
  
  
Guiding Questions to keep in mind 
  What is the safest route back home, - interactive component?
  Is cutting through the park bad? - 
  what is a dangerous time to be out? 
  Is there a difference by gender/race/age for safety?
  
Analyses
  Demographics - 3+ (mosaic, ) --tbd to see what is interesting (All)
  Time -  3 graphs (line graph, ridge plot, bar chart/split?)
  Location - 2 graphs (map, crime density at different radiaii, routes to uptown?)
      -how to represent overlapping lat/long points differently? Color (Faizan)
  --------
  Interactive - TBD, depends on complexity - Maybe user will enter address and then it will show a map that is shown around columbia and that location and basically plots heat map but allows user to add filters to make more specific and change the heatmap (ex change time or day or gender)



## Planning Notes
--To delete
```{r}
#What Graphs Do We Want?

#Data Prep Graphs
#1) Missing data patterns by row (using redav library or mi library) --heatmap


#Demographic Related Chart
#1) Bar Chart - CRIME_CAT by VIC Gender and/or SUSPECT Gender
#2) Mosaic Plot - TBD (CRIME CAT, VIC Gender, and Premise, +)
#3) Count by Premise (or use as a cut)
#--see ideas below

#Time Series Charts
#1) Line Chart - Overall 2022 Trend by Count
#2) Bar Chart - CRIME CAT by Day of Week
#3) Density Plot - Count by Time of Day (maybe with facets)
#4) (TBD more CRIME CAT by Time or Premise by Time of Day/Park)
#5) Look at box plot by time of day?

#Maps & Distance Info
#1) Counts By Borough (bar chart) (consider faceting by another dimension that looks good)
#2) Map of count in Columbia Area
#3) Line Graph of Density At Diff Points (x is distance from CU and y is total counts)
#4) Heat Map/Choropleth - Count by Precinct Code (may require addl data? --look into if feasible)

#Other Potential
#x) Parallel Coordinates Plot - not enough continuous vars
#x) Stacked Bar Chart?
#x) Scatter Plot (of Distance from CU vs Time of Day?)
#x) Cleveland Dot Plot - TBD

```







    
