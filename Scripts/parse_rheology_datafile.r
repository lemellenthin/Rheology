# Logistics
library(tidyverse); library(readxl); library(janitor)
library(expss); library(ggplot2); library(oreo)
library(xlsx); library(nlme)

# A custom function to read in the information
# 	parses a single sheet of a single file
parse_rheology_datafile <- function(file, sheet) {

	# Read in the hz value from the top left corner of the sheet,
	#	storing that frequency value to append later
	hz <- read_excel(file, sheet=sheet, range="A1", skip=0, col_names="hz") %>%
	   mutate(hz=parse_number(hz)) %>%
	   as.numeric()

	# Read in the top three rows, which contain column info
	#	as well as the units and waveform properties of that column
	rawColumnInfo <- read_excel(file, sheet=sheet, skip=0, range=cell_rows(2:4))
 
	# Read in column units 
	#	(third row of original excel file,
	#	 second row of this file)
	columnUnits <- rawColumnInfo[2,] %>%
				as.character()
	
	# Clean up column units (remove brackets)
	cleanUnits <- gsub("\\[|\\]", "", columnUnits)

	# Get a vector of which columns are waveforms
	waveformInfo <- rawColumnInfo[1,] %>%
				 as.character()

	# Remove NAs and "NA"'s from vector of waveform values,
	waveformInfo[is.na(waveformInfo) | waveformInfo=="NA"] <- ""			 

	# Get the raw column names
	columnNamesRaw <- colnames(rawColumnInfo)

	# Remove autogenerated ellipses from redundant column names
	cleanColumnNames <- gsub("\\.\\.\\.(\\d{1}|\\d{2})", "", columnNamesRaw) 
	
	# Replace spaces with underscore
	# 	(NOTE other characters, like a dot, might still mess with
	#		column names. You can gsub those later)
	cleanColumnNames <- gsub(" ", "_", cleanColumnNames)

	# Paste the units onto the clean column names
	cleanColumnNames <- paste(cleanColumnNames, cleanUnits, sep="_")

	# Paste "Waveform" on each column name that has waveform values
	cleanColumnNames[waveformInfo=="Waveform"] <- paste(cleanColumnNames[waveformInfo=="Waveform"], "Waveform", sep="_")

	# Rename the "Point No" column to a cleaner name,
	#	after having inappopriately appended a weird unit
	cleanColumnNames[cleanColumnNames=="Point_No._NA"] <- "Point_No"

	# Read in the data file again, here to get the actual data 
	# (skip the first row, which has the hz info we saved early
	#  (and remove the subsequent two rows, which contain the 
	#	unit and header info we got early and are in the clean column names)
	dataAll <- read_excel(file, sheet=sheet, skip=1)[-c(1:2),] %>%
			mutate_if(is.character, as.double)				# mutate all CHARACTER columns into DOUBLE columns 

    # Rename the columns with our clean column names
	colnames(dataAll) <- cleanColumnNames

	# Add a HZ column that contains the frequency value,
	#	and FILL DOWN the Point Numbers, so there is a value for each row
	# (note we add the hz column, with mutate, AFTER we rename the columns
	#		with our clean column names)
	dataAll <- dataAll %>%
			mutate(hz = hz, .before=1) %>%
			fill(Point_No, .direction="down")

    # Return that full dataset
    # including both waveform and non-waveform values,
    # with a column for hz
	return(dataAll)
}

# Read in Data
#######################
# Example of reading in a single sheet from a single file,
# with the parsing function above.
# With a list of file names and sheets, you can loop through those things
aequoreaSidecut1_amp_5hz <- parse_rheology_datafile(file="./Data_Jan2021/Cnido/aequorea/10-03-2020 Aequorea sidecut1 amp sweeps.xlsx",
 												   sheet="Sheet1")
aequoreaSidecut1_amp_3hz <- parse_rheology_datafile(file="./Data_Jan2021/Cnido/aequorea/10-03-2020 Aequorea sidecut1 amp sweeps.xlsx",
                                                   sheet="Sheet2")
aequoreaSidecut1_amp_1hz <- parse_rheology_datafile(file="./Data_Jan2021/Cnido/aequorea/10-03-2020 Aequorea sidecut1 amp sweeps.xlsx",
                                                   sheet="Sheet3")
aequoreaSidecut1_amp_0.5hz <- parse_rheology_datafile(file="./Data_Jan2021/Cnido/aequorea/10-03-2020 Aequorea sidecut1 amp sweeps.xlsx",
                                                   sheet="Sheet4")
aequoreaSidecut1_amp_0.1hz <- parse_rheology_datafile(file="./Data_Jan2021/Cnido/aequorea/10-03-2020 Aequorea sidecut1 amp sweeps.xlsx",
                                                   sheet="Sheet5")
#
aequoreaSidecut2_amp_5hz <- parse_rheology_datafile(file="./Data_Jan2021/Cnido/aequorea/11-03-2020 Aequorea sidecut2 amp sweeps.xlsx",
                                                   sheet="Sheet1")
aequoreaSidecut2_amp_3hz <- parse_rheology_datafile(file="./Data_Jan2021/Cnido/aequorea/11-03-2020 Aequorea sidecut2 amp sweeps.xlsx",
                                                   sheet="Sheet2")
aequoreaSidecut2_amp_1hz <- parse_rheology_datafile(file="./Data_Jan2021/Cnido/aequorea/11-03-2020 Aequorea sidecut2 amp sweeps.xlsx",
                                                   sheet="Sheet3")
aequoreaSidecut2_amp_0.5hz <- parse_rheology_datafile(file="./Data_Jan2021/Cnido/aequorea/11-03-2020 Aequorea sidecut2 amp sweeps.xlsx",
                                                     sheet="Sheet4")
aequoreaSidecut2_amp_0.1hz <- parse_rheology_datafile(file="./Data_Jan2021/Cnido/aequorea/11-03-2020 Aequorea sidecut2 amp sweeps.xlsx",
                                                     sheet="Sheet5")
#
aequoreamiddlebell_amp_5hz <- parse_rheology_datafile(file="./Data_Jan2021/Cnido/aequorea/11-03-2020 Aequorea middlebell amp sweeps.xlsx",
                                                      sheet="Sheet1")
aequoreamiddlebell_amp_3hz <- parse_rheology_datafile(file="./Data_Jan2021/Cnido/aequorea/11-03-2020 Aequorea middlebell amp sweeps.xlsx",
                                                      sheet="Sheet2")
aequoreamiddlebell_amp_1hz <- parse_rheology_datafile(file="./Data_Jan2021/Cnido/aequorea/11-03-2020 Aequorea middlebell amp sweeps.xlsx",
                                                      sheet="Sheet3")
aequoreamiddlebell_amp_0.5hz <- parse_rheology_datafile(file="./Data_Jan2021/Cnido/aequorea/11-03-2020 Aequorea middlebell amp sweeps.xlsx",
                                                        sheet="Sheet4")
aequoreamiddlebell_amp_0.1hz <- parse_rheology_datafile(file="./Data_Jan2021/Cnido/aequorea/11-03-2020 Aequorea middlebell amp sweeps.xlsx",
                                                        sheet="Sheet5")
#
str(aequoreaSidecut_amp_5hz)
#
par(mfrow=c(2,1))
plot(aequoreamiddlebell_amp_0.1hz$Period_Time_s_Waveform, 
     aequoreamiddlebell_amp_0.1hz$`Shear_Strain_%_Waveform`)
plot(aequoreamiddlebell_amp_0.1hz$Period_Time_s_Waveform, 
     aequoreamiddlebell_amp_0.1hz$Shear_Stress_Pa_Waveform)
par(mfrow=c(2,1))
plot(aequoreamiddlebell_amp_5hz$Period_Time_s_Waveform, 
     aequoreamiddlebell_amp_5hz$`Shear_Strain_%_Waveform`)
plot(aequoreamiddlebell_amp_5hz$Period_Time_s_Waveform, 
     aequoreamiddlebell_amp_5hz$Shear_Stress_Pa_Waveform)
#
par(mfrow=c(5,2))
plot(aequoreamiddlebell_amp_5hz$Period_Time_s_Waveform, 
     aequoreamiddlebell_amp_5hz$`Shear_Strain_%_Waveform`)
plot(aequoreamiddlebell_amp_5hz$Period_Time_s_Waveform, 
     aequoreamiddlebell_amp_5hz$Shear_Stress_Pa_Waveform)
plot(aequoreamiddlebell_amp_3hz$Period_Time_s_Waveform, 
     aequoreamiddlebell_amp_3hz$`Shear_Strain_%_Waveform`)
plot(aequoreamiddlebell_amp_3hz$Period_Time_s_Waveform, 
     aequoreamiddlebell_amp_3hz$Shear_Stress_Pa_Waveform)
plot(aequoreamiddlebell_amp_1hz$Period_Time_s_Waveform, 
     aequoreamiddlebell_amp_1hz$`Shear_Strain_%_Waveform`)
plot(aequoreamiddlebell_amp_1hz$Period_Time_s_Waveform, 
     aequoreamiddlebell_amp_1hz$Shear_Stress_Pa_Waveform)
plot(aequoreamiddlebell_amp_0.5hz$Period_Time_s_Waveform, 
     aequoreamiddlebell_amp_0.5hz$`Shear_Strain_%_Waveform`)
plot(aequoreamiddlebell_amp_0.5hz$Period_Time_s_Waveform, 
     aequoreamiddlebell_amp_0.5hz$Shear_Stress_Pa_Waveform)
plot(aequoreamiddlebell_amp_0.1hz$Period_Time_s_Waveform, 
     aequoreamiddlebell_amp_0.1hz$`Shear_Strain_%_Waveform`)
plot(aequoreamiddlebell_amp_0.1hz$Period_Time_s_Waveform, 
     aequoreamiddlebell_amp_0.1hz$Shear_Stress_Pa_Waveform)
#
par(mfrow=c(5,2))
plot(aequoreaSidecut1_amp_5hz$Period_Time_s_Waveform, 
     aequoreaSidecut1_amp_5hz$`Shear_Strain_%_Waveform`)
plot(aequoreaSidecut1_amp_5hz$Period_Time_s_Waveform, 
     aequoreaSidecut1_amp_5hz$Shear_Stress_Pa_Waveform)
plot(aequoreaSidecut1_amp_3hz$Period_Time_s_Waveform, 
     aequoreaSidecut1_amp_3hz$`Shear_Strain_%_Waveform`)
plot(aequoreaSidecut1_amp_3hz$Period_Time_s_Waveform, 
     aequoreaSidecut1_amp_3hz$Shear_Stress_Pa_Waveform)
plot(aequoreaSidecut1_amp_1hz$Period_Time_s_Waveform, 
     aequoreaSidecut1_amp_1hz$`Shear_Strain_%_Waveform`)
plot(aequoreaSidecut1_amp_1hz$Period_Time_s_Waveform, 
     aequoreaSidecut1_amp_1hz$Shear_Stress_Pa_Waveform)
plot(aequoreaSidecut1_amp_0.5hz$Period_Time_s_Waveform, 
     aequoreaSidecut1_amp_0.5hz$`Shear_Strain_%_Waveform`)
plot(aequoreaSidecut1_amp_0.5hz$Period_Time_s_Waveform, 
     aequoreaSidecut1_amp_0.5hz$Shear_Stress_Pa_Waveform)
plot(aequoreaSidecut1_amp_0.1hz$Period_Time_s_Waveform, 
     aequoreaSidecut1_amp_0.1hz$`Shear_Strain_%_Waveform`)
plot(aequoreaSidecut1_amp_0.1hz$Period_Time_s_Waveform, 
     aequoreaSidecut1_amp_0.1hz$Shear_Stress_Pa_Waveform)
#######################

# split strains
#######################
#define number of data frames to split into
n <- 10

#split data frame into n equal-sized data frames
amb0.1hzsplit <- split(aequoreamiddlebell_amp_0.1hz, factor(sort(rank(row.names(aequoreamiddlebell_amp_0.1hz))%%n)))
amb0.5hzsplit <- split(aequoreamiddlebell_amp_0.5hz, factor(sort(rank(row.names(aequoreamiddlebell_amp_0.5hz))%%n)))
amb1hzsplit <- split(aequoreamiddlebell_amp_1hz, factor(sort(rank(row.names(aequoreamiddlebell_amp_1hz))%%n)))
amb3hzsplit <- split(aequoreamiddlebell_amp_3hz, factor(sort(rank(row.names(aequoreamiddlebell_amp_3hz))%%n)))
amb5hzsplit <- split(aequoreamiddlebell_amp_5hz,factor(sort(rank(row.names(aequoreamiddlebell_amp_5hz))%%n)))
#
as10.1hzsplit <- split(aequoreaSidecut1_amp_0.1hz, factor(sort(rank(row.names(aequoreaSidecut1_amp_0.1hz))%%n)))
as10.5hzsplit <- split(aequoreaSidecut1_amp_0.5hz, factor(sort(rank(row.names(aequoreaSidecut1_amp_0.5hz))%%n)))
as11hzsplit <- split(aequoreaSidecut1_amp_1hz, factor(sort(rank(row.names(aequoreaSidecut1_amp_1hz))%%n)))
as13hzsplit <- split(aequoreaSidecut1_amp_3hz, factor(sort(rank(row.names(aequoreaSidecut1_amp_3hz))%%n)))
as15hzsplit <- split(aequoreaSidecut1_amp_5hz,factor(sort(rank(row.names(aequoreaSidecut1_amp_5hz))%%n)))
#
as20.1hzsplit <- split(aequoreaSidecut2_amp_0.1hz, factor(sort(rank(row.names(aequoreaSidecut2_amp_0.1hz))%%n)))
as20.5hzsplit <- split(aequoreaSidecut2_amp_0.5hz, factor(sort(rank(row.names(aequoreaSidecut2_amp_0.5hz))%%n)))
as21hzsplit <- split(aequoreaSidecut2_amp_1hz, factor(sort(rank(row.names(aequoreaSidecut2_amp_1hz))%%n)))
as23hzsplit <- split(aequoreaSidecut2_amp_3hz, factor(sort(rank(row.names(aequoreaSidecut2_amp_3hz))%%n)))
as25hzsplit <- split(aequoreaSidecut2_amp_5hz,factor(sort(rank(row.names(aequoreaSidecut2_amp_5hz))%%n)))
#
par(mfrow=c(2,1))
plot(amb0.1hzsplit$`0`$Period_Time_s_Waveform, amb0.1hzsplit$`0`$`Shear_Strain_%_Waveform`)
plot(amb0.1hzsplit$`0`$Period_Time_s_Waveform, amb0.1hzsplit$`0`$Shear_Stress_Pa_Waveform)
#
par(mfrow=c(5,2))
plot(amb0.1hzsplit$`0`$Period_Time_s_Waveform, amb0.1hzsplit$`0`$`Shear_Strain_%_Waveform`)
plot(amb0.1hzsplit$`0`$Period_Time_s_Waveform, amb0.1hzsplit$`0`$Shear_Stress_Pa_Waveform)
plot(amb0.1hzsplit$`1`$Period_Time_s_Waveform, amb0.1hzsplit$`1`$`Shear_Strain_%_Waveform`)
plot(amb0.1hzsplit$`1`$Period_Time_s_Waveform, amb0.1hzsplit$`1`$Shear_Stress_Pa_Waveform)
plot(amb0.1hzsplit$`2`$Period_Time_s_Waveform, amb0.1hzsplit$`2`$`Shear_Strain_%_Waveform`)
plot(amb0.1hzsplit$`2`$Period_Time_s_Waveform, amb0.1hzsplit$`2`$Shear_Stress_Pa_Waveform)
plot(amb0.1hzsplit$`3`$Period_Time_s_Waveform, amb0.1hzsplit$`3`$`Shear_Strain_%_Waveform`)
plot(amb0.1hzsplit$`3`$Period_Time_s_Waveform, amb0.1hzsplit$`3`$Shear_Stress_Pa_Waveform)
plot(amb0.1hzsplit$`4`$Period_Time_s_Waveform, amb0.1hzsplit$`4`$`Shear_Strain_%_Waveform`)
plot(amb0.1hzsplit$`4`$Period_Time_s_Waveform, amb0.1hzsplit$`4`$Shear_Stress_Pa_Waveform)
par(mfrow=c(5,2))
plot(amb0.1hzsplit$`5`$Period_Time_s_Waveform, amb0.1hzsplit$`5`$`Shear_Strain_%_Waveform`)
plot(amb0.1hzsplit$`5`$Period_Time_s_Waveform, amb0.1hzsplit$`5`$Shear_Stress_Pa_Waveform)
plot(amb0.1hzsplit$`6`$Period_Time_s_Waveform, amb0.1hzsplit$`6`$`Shear_Strain_%_Waveform`)
plot(amb0.1hzsplit$`6`$Period_Time_s_Waveform, amb0.1hzsplit$`6`$Shear_Stress_Pa_Waveform)
plot(amb0.1hzsplit$`7`$Period_Time_s_Waveform, amb0.1hzsplit$`7`$`Shear_Strain_%_Waveform`)
plot(amb0.1hzsplit$`7`$Period_Time_s_Waveform, amb0.1hzsplit$`7`$Shear_Stress_Pa_Waveform)
plot(amb0.1hzsplit$`8`$Period_Time_s_Waveform, amb0.1hzsplit$`8`$`Shear_Strain_%_Waveform`)
plot(amb0.1hzsplit$`8`$Period_Time_s_Waveform, amb0.1hzsplit$`8`$Shear_Stress_Pa_Waveform)
plot(amb0.1hzsplit$`9`$Period_Time_s_Waveform, amb0.1hzsplit$`9`$`Shear_Strain_%_Waveform`)
plot(amb0.1hzsplit$`9`$Period_Time_s_Waveform, amb0.1hzsplit$`9`$Shear_Stress_Pa_Waveform)
#
#
par(mfrow=c(5,2))
plot(as10.1hzsplit$`0`$Period_Time_s_Waveform, as10.1hzsplit$`0`$`Shear_Strain_%_Waveform`)
plot(as10.1hzsplit$`0`$Period_Time_s_Waveform, as10.1hzsplit$`0`$Shear_Stress_Pa_Waveform)
plot(as10.1hzsplit$`1`$Period_Time_s_Waveform, as10.1hzsplit$`1`$`Shear_Strain_%_Waveform`)
plot(as10.1hzsplit$`1`$Period_Time_s_Waveform, as10.1hzsplit$`1`$Shear_Stress_Pa_Waveform)
plot(as10.1hzsplit$`2`$Period_Time_s_Waveform, as10.1hzsplit$`2`$`Shear_Strain_%_Waveform`)
plot(as10.1hzsplit$`2`$Period_Time_s_Waveform, as10.1hzsplit$`2`$Shear_Stress_Pa_Waveform)
plot(as10.1hzsplit$`3`$Period_Time_s_Waveform, as10.1hzsplit$`3`$`Shear_Strain_%_Waveform`)
plot(as10.1hzsplit$`3`$Period_Time_s_Waveform, as10.1hzsplit$`3`$Shear_Stress_Pa_Waveform)
plot(as10.1hzsplit$`4`$Period_Time_s_Waveform, as10.1hzsplit$`4`$`Shear_Strain_%_Waveform`)
plot(as10.1hzsplit$`4`$Period_Time_s_Waveform, as10.1hzsplit$`4`$Shear_Stress_Pa_Waveform)
par(mfrow=c(5,2))
plot(as10.1hzsplit$`5`$Period_Time_s_Waveform, as10.1hzsplit$`5`$`Shear_Strain_%_Waveform`)
plot(as10.1hzsplit$`5`$Period_Time_s_Waveform, as10.1hzsplit$`5`$Shear_Stress_Pa_Waveform)
plot(as10.1hzsplit$`6`$Period_Time_s_Waveform, as10.1hzsplit$`6`$`Shear_Strain_%_Waveform`)
plot(as10.1hzsplit$`6`$Period_Time_s_Waveform, as10.1hzsplit$`6`$Shear_Stress_Pa_Waveform)
plot(as10.1hzsplit$`7`$Period_Time_s_Waveform, as10.1hzsplit$`7`$`Shear_Strain_%_Waveform`)
plot(as10.1hzsplit$`7`$Period_Time_s_Waveform, as10.1hzsplit$`7`$Shear_Stress_Pa_Waveform)
plot(as10.1hzsplit$`8`$Period_Time_s_Waveform, as10.1hzsplit$`8`$`Shear_Strain_%_Waveform`)
plot(as10.1hzsplit$`8`$Period_Time_s_Waveform, as10.1hzsplit$`8`$Shear_Stress_Pa_Waveform)
plot(as10.1hzsplit$`9`$Period_Time_s_Waveform, as10.1hzsplit$`9`$`Shear_Strain_%_Waveform`)
plot(as10.1hzsplit$`9`$Period_Time_s_Waveform, as10.1hzsplit$`9`$Shear_Stress_Pa_Waveform)
#
par(mfrow=c(5,2))
plot(as20.1hzsplit$`0`$Period_Time_s_Waveform, as20.1hzsplit$`0`$`Shear_Strain_%_Waveform`)
plot(as20.1hzsplit$`0`$Period_Time_s_Waveform, as20.1hzsplit$`0`$Shear_Stress_Pa_Waveform)
plot(as20.1hzsplit$`1`$Period_Time_s_Waveform, as20.1hzsplit$`1`$`Shear_Strain_%_Waveform`)
plot(as20.1hzsplit$`1`$Period_Time_s_Waveform, as20.1hzsplit$`1`$Shear_Stress_Pa_Waveform)
plot(as20.1hzsplit$`2`$Period_Time_s_Waveform, as20.1hzsplit$`2`$`Shear_Strain_%_Waveform`)
plot(as20.1hzsplit$`2`$Period_Time_s_Waveform, as20.1hzsplit$`2`$Shear_Stress_Pa_Waveform)
plot(as20.1hzsplit$`3`$Period_Time_s_Waveform, as20.1hzsplit$`3`$`Shear_Strain_%_Waveform`)
plot(as20.1hzsplit$`3`$Period_Time_s_Waveform, as20.1hzsplit$`3`$Shear_Stress_Pa_Waveform)
plot(as20.1hzsplit$`4`$Period_Time_s_Waveform, as20.1hzsplit$`4`$`Shear_Strain_%_Waveform`)
plot(as20.1hzsplit$`4`$Period_Time_s_Waveform, as20.1hzsplit$`4`$Shear_Stress_Pa_Waveform)
par(mfrow=c(5,2))
plot(as20.1hzsplit$`5`$Period_Time_s_Waveform, as20.1hzsplit$`5`$`Shear_Strain_%_Waveform`)
plot(as20.1hzsplit$`5`$Period_Time_s_Waveform, as20.1hzsplit$`5`$Shear_Stress_Pa_Waveform)
plot(as20.1hzsplit$`6`$Period_Time_s_Waveform, as20.1hzsplit$`6`$`Shear_Strain_%_Waveform`)
plot(as20.1hzsplit$`6`$Period_Time_s_Waveform, as20.1hzsplit$`6`$Shear_Stress_Pa_Waveform)
plot(as20.1hzsplit$`7`$Period_Time_s_Waveform, as20.1hzsplit$`7`$`Shear_Strain_%_Waveform`)
plot(as20.1hzsplit$`7`$Period_Time_s_Waveform, as20.1hzsplit$`7`$Shear_Stress_Pa_Waveform)
plot(as20.1hzsplit$`8`$Period_Time_s_Waveform, as20.1hzsplit$`8`$`Shear_Strain_%_Waveform`)
plot(as20.1hzsplit$`8`$Period_Time_s_Waveform, as20.1hzsplit$`8`$Shear_Stress_Pa_Waveform)
plot(as20.1hzsplit$`9`$Period_Time_s_Waveform, as20.1hzsplit$`9`$`Shear_Strain_%_Waveform`)
plot(as20.1hzsplit$`9`$Period_Time_s_Waveform, as20.1hzsplit$`9`$Shear_Stress_Pa_Waveform)
#
#
par(mfrow=c(5,2))
plot(as20.1hzsplit$`6`$Period_Time_s_Waveform, as20.1hzsplit$`6`$`Shear_Strain_%_Waveform`)
plot(as20.1hzsplit$`6`$Period_Time_s_Waveform, as20.1hzsplit$`6`$Shear_Stress_Pa_Waveform)
plot(as20.5hzsplit$`6`$Period_Time_s_Waveform, as20.5hzsplit$`6`$`Shear_Strain_%_Waveform`)
plot(as20.5hzsplit$`6`$Period_Time_s_Waveform, as20.5hzsplit$`6`$Shear_Stress_Pa_Waveform)
plot(as21hzsplit$`6`$Period_Time_s_Waveform, as21hzsplit$`6`$`Shear_Strain_%_Waveform`)
plot(as21hzsplit$`6`$Period_Time_s_Waveform, as21hzsplit$`6`$Shear_Stress_Pa_Waveform)
plot(as23hzsplit$`6`$Period_Time_s_Waveform, as23hzsplit$`6`$`Shear_Strain_%_Waveform`)
plot(as23hzsplit$`6`$Period_Time_s_Waveform, as23hzsplit$`6`$Shear_Stress_Pa_Waveform)
plot(as25hzsplit$`6`$Period_Time_s_Waveform, as25hzsplit$`6`$`Shear_Strain_%_Waveform`)
plot(as25hzsplit$`6`$Period_Time_s_Waveform, as25hzsplit$`6`$Shear_Stress_Pa_Waveform)

#
par(mfrow=c(5,1))
plot(aequoreamiddlebell_amp_0.5hz$Average_Time_s,
     aequoreamiddlebell_amp_0.5hz$Shear_Strain_1)
plot(aequoreamiddlebell_amp_0.1hz$Average_Time_s,
     aequoreamiddlebell_amp_0.1hz$Shear_Strain_Pa)
plot(aequoreamiddlebell_amp_1hz$Average_Time_s,
     aequoreamiddlebell_amp_1hz$Shear_Strain_Pa)
plot(aequoreamiddlebell_amp_3hz$Average_Time_s,
     aequoreamiddlebell_amp_3hz$Shear_Strain_Pa)
plot(aequoreamiddlebell_amp_5hz$Average_Time_s,
     aequoreamiddlebell_amp_5hz$Shear_Strain_Pa)
#
par(mfrow=c(5,1))
plot(aequoreamiddlebell_amp_0.5hz$Average_Time_s,
     aequoreamiddlebell_amp_0.5hz$Shear_Stress_1)
plot(aequoreamiddlebell_amp_0.1hz$Average_Time_s,
     aequoreamiddlebell_amp_0.1hz$Shear_Stress_Pa)
plot(aequoreamiddlebell_amp_1hz$Average_Time_s,
     aequoreamiddlebell_amp_1hz$Shear_Stress_Pa)
plot(aequoreamiddlebell_amp_3hz$Average_Time_s,
     aequoreamiddlebell_amp_3hz$Shear_Stress_Pa)
plot(aequoreamiddlebell_amp_5hz$Average_Time_s,
     aequoreamiddlebell_amp_5hz$Shear_Stress_Pa)
#
par(mfrow=c(5,1))
plot(aequoreamiddlebell_amp_0.5hz$Period_Time_s_Waveform,
     aequoreamiddlebell_amp_0.5hz$`Shear_Strain_%_Waveform`)
plot(aequoreamiddlebell_amp_0.1hz$Period_Time_s_Waveform,
     aequoreamiddlebell_amp_0.1hz$`Shear_Strain_%_Waveform`)
plot(aequoreamiddlebell_amp_1hz$Period_Time_s_Waveform,
     aequoreamiddlebell_amp_1hz$`Shear_Strain_%_Waveform`)
plot(aequoreamiddlebell_amp_3hz$Period_Time_s_Waveform,
     aequoreamiddlebell_amp_3hz$`Shear_Strain_%_Waveform`)
plot(aequoreamiddlebell_amp_5hz$Period_Time_s_Waveform,
     aequoreamiddlebell_amp_5hz$`Shear_Strain_%_Waveform`)
#
par(mfrow=c(5,1))
plot(aequoreamiddlebell_amp_0.5hz$Period_Time_s_Waveform,
     aequoreamiddlebell_amp_0.5hz$Shear_Stress_Pa_Waveform)
plot(aequoreamiddlebell_amp_0.1hz$Period_Time_s_Waveform,
     aequoreamiddlebell_amp_0.1hz$Shear_Stress_Pa_Waveform)
plot(aequoreamiddlebell_amp_1hz$Period_Time_s_Waveform,
     aequoreamiddlebell_amp_1hz$Shear_Stress_Pa_Waveform)
plot(aequoreamiddlebell_amp_3hz$Period_Time_s_Waveform,
     aequoreamiddlebell_amp_3hz$Shear_Stress_Pa_Waveform)
plot(aequoreamiddlebell_amp_5hz$Period_Time_s_Waveform,
     aequoreamiddlebell_amp_5hz$Shear_Stress_Pa_Waveform)
#
par(mfrow=c(3,2))
plot(amb0.1hzsplit$`4`$Period_Time_s_Waveform, amb0.1hzsplit$`4`$`Shear_Strain_%_Waveform`)
plot(amb0.1hzsplit$`4`$Period_Time_s_Waveform, amb0.1hzsplit$`4`$Shear_Stress_Pa_Waveform)
plot(as10.1hzsplit$`4`$Period_Time_s_Waveform, as10.1hzsplit$`4`$`Shear_Strain_%_Waveform`)
plot(as10.1hzsplit$`4`$Period_Time_s_Waveform, as10.1hzsplit$`4`$Shear_Stress_Pa_Waveform)
plot(as20.1hzsplit$`4`$Period_Time_s_Waveform, as20.1hzsplit$`4`$`Shear_Strain_%_Waveform`)
plot(as20.1hzsplit$`4`$Period_Time_s_Waveform, as20.1hzsplit$`4`$Shear_Stress_Pa_Waveform)
#
par(mfrow=c(3,2))
plot(amb0.1hzsplit$`5`$Period_Time_s_Waveform, amb0.1hzsplit$`5`$`Shear_Strain_%_Waveform`)
plot(amb0.1hzsplit$`5`$Period_Time_s_Waveform, amb0.1hzsplit$`5`$Shear_Stress_Pa_Waveform)
plot(as10.1hzsplit$`5`$Period_Time_s_Waveform, as10.1hzsplit$`5`$`Shear_Strain_%_Waveform`)
plot(as10.1hzsplit$`5`$Period_Time_s_Waveform, as10.1hzsplit$`5`$Shear_Stress_Pa_Waveform)
plot(as20.1hzsplit$`5`$Period_Time_s_Waveform, as20.1hzsplit$`5`$`Shear_Strain_%_Waveform`)
plot(as20.1hzsplit$`5`$Period_Time_s_Waveform, as20.1hzsplit$`5`$Shear_Stress_Pa_Waveform)
#
#######################

# fourier transform
#######################
# formula
#   '0.001*[(A*sin(0.0628*x))+(B*cos(0.0628*x))]'
#   A = G' storage modulus, elastic moduli
#   B = G" loss modulus, viscous moduli
#   x = Time as independent variable
#   y = stress as dependent variable
#   start points A,B [0.913375856139019 0.63235924622541]
#   0.1% strain = 0.001, 0.2%=0.002, 0.5=0.005, 1=0.01, 2=0.02, 5=0.05, 10=0.1, 20=0.2, 50=0.5, 100=1
#   0                     1           2           3       4       5       6       7       8       9
#   1-10 strains (0.1,0.2,0.5,1,2,5,10,20,50,100) split(0-9)
#   1 hz = 6.2831853 rad/s
#   0.1hz = 0.62831853 rad/s

## examples
#example1
eDecay <- function(t, ampl, tau) (ampl*exp(-t/tau))
model1 <- nls(fluorI ~ eDecay(t,myA,myT), data=ExpData, start=list(myA=10,myT=5))
summary(model1)
#example2
p = function(x) x^3+2*x^2+5
x = seq(-0.99, 1, by = .01)
y = peq(x) + runif(200)
df = data.frame(x = x, y = y)
head(df)
fit = nls(y~a*x^2+b*x, data = df, start(a=0, b=0))
print(fit)
pred = predict(fit, x)
plot(x, y, pch = 20)
lines(x, pred, lwd = 3, col = "blue")

#trying example
funcmod <- function(A, B, x) (0.001*((A*sin(0.0628*x))+(B*cos(0.0628*x))))
fo <- as.formula("y ~ 0.001*((A*sin(0.0628*x))+(B*cos(0.0628*x)))")
nlsfit <- nls(Shear_Stress_Pa_Waveform ~ funcmod(Period_Time_s_Waveform,A,B),
              data=amb0.1hzsplit$`3`, start = list(A=0.913375856139019, B=0.63235924622541), trace = TRUE, model = T)
y = amb0.1hzsplit$`0`$Shear_Stress_Pa_Waveform
x = amb0.1hzsplit$`0`$Period_Time_s_Waveform 
DF = amb0.1hzsplit$`0`
fit <- nls(y ~ SSlogis(x, Asym, xmid, scal), data=DF)
summary(fit)
idk <- gnls(y ~ 0.001*((A*sin(0.0628*x))+(B*cos(0.0628*x))), data = amb0.1hzsplit$`0`,DF, start = coef(fit))
# didnt work

# trying example
p = function(x) 0.1*((a*sin(0.0628*x))+(b*cos(0.0628*x)))
x = as20.1hzsplit$`6`$Period_Time_s_Waveform
y = as20.1hzsplit$`6`$Shear_Stress_Pa_Waveform
df = data.frame(x = x, y = y)
fit = nls(y~0.1*((a*sin(0.0628*x))+(b*cos(0.0628*x))), data = df, 
           start=list(a=0.913375856139019, b=0.63235924622541),
           trace=TRUE, model=TRUE)
print(fit)
summary(fit)
str(fit)
class(fit)

pred = predict(fit, df)
plot(x, y, pch = 20)
lines(x, pred, lwd = 3, col = "blue")

coef(fit)
as20.1hzsplit$`6`$Storage_Modulus_Pa #G'=5.4077 is A
as20.1hzsplit$`6`$Loss_Modulus_Pa # G"=2.8183 is B





##########
ggplot(data=aequoreaSidecut_amp_1hz, aes(x=Shear_Strain_1, y=Period_Time_s_Waveform, group=1)) +
  geom_line()+
  geom_point()

ggplot(data=aequoreaSidecut_amp_5hz, aes(x=Shear_Stress_1, y=Period_Time_s_Waveform, group=1)) +
  geom_line()+
  geom_point()

p = ggplot() + 
  geom_line(data = aequoreaSidecut_amp_5hz, aes(x = Shear_Strain_1, y = Loss_Modulus_Pa), color = "blue") +
  geom_line(data = aequoreaSidecut_amp_3hz, aes(x = Shear_Strain_1, y = Loss_Modulus_Pa), color = "red") +
  geom_line(data = aequoreaSidecut_amp_1hz, aes(x = Shear_Strain_1, y = Loss_Modulus_Pa), color = "green") +
  geom_line(data = aequoreaSidecut_amp_0.5hz, aes(x = Shear_Strain_1, y = Loss_Modulus_Pa), color = "yellow") +
  geom_line(data = aequoreaSidecut_amp_0.1hz, aes(x = Shear_Strain_1, y = Loss_Modulus_Pa), color = "purple") +
  xlab('Shear Strain(%)') +
  ylab('Moduli (Pa)') 
print(p)

##########
p = ggplot() + 
  geom_line(data = aequoreamiddlebell_amp_5hz, aes(x = Shear_Strain_1, y = Loss_Modulus_Pa), color = "blue") +
  geom_line(data = aequoreamiddlebell_amp_3hz, aes(x = Shear_Strain_1, y = Loss_Modulus_Pa), color = "red") +
  geom_line(data = aequoreamiddlebell_amp_1hz, aes(x = Shear_Strain_1, y = Loss_Modulus_Pa), color = "green") +
  geom_line(data = aequoreamiddlebell_amp_0.5hz, aes(x = Shear_Strain_1, y = Loss_Modulus_Pa), color = "yellow") +
  geom_line(data = aequoreamiddlebell_amp_0.1hz, aes(x = Shear_Strain_1, y = Loss_Modulus_Pa), color = "purple") +
  xlab('Shear Strain(%)') +
  ylab('Loss Moduli (Pa)') 
print(p)

########
par(mfrow=c(5,2))
plot(Shear_Stress_Pa_Waveform ~ Period_Time_s_Waveform, data=amb0.1hzsplit$`0`)
plot(Shear_Stress_Pa_Waveform ~ Period_Time_s_Waveform, data=amb0.1hzsplit$`1`)
plot(Shear_Stress_Pa_Waveform ~ Period_Time_s_Waveform, data=amb0.1hzsplit$`2`)
plot(Shear_Stress_Pa_Waveform ~ Period_Time_s_Waveform, data=amb0.1hzsplit$`3`)
plot(Shear_Stress_Pa_Waveform ~ Period_Time_s_Waveform, data=amb0.1hzsplit$`4`)
plot(Shear_Stress_Pa_Waveform ~ Period_Time_s_Waveform, data=amb0.1hzsplit$`5`)
plot(Shear_Stress_Pa_Waveform ~ Period_Time_s_Waveform, data=amb0.1hzsplit$`6`)
plot(Shear_Stress_Pa_Waveform ~ Period_Time_s_Waveform, data=amb0.1hzsplit$`7`)
plot(Shear_Stress_Pa_Waveform ~ Period_Time_s_Waveform, data=amb0.1hzsplit$`8`)
plot(Shear_Stress_Pa_Waveform ~ Period_Time_s_Waveform, data=amb0.1hzsplit$`9`)

par(mfrow=c(5,2))
plot(Shear_Stress_Pa_Waveform ~ Period_Time_s_Waveform, data=amb0.5hzsplit$`0`)
plot(Shear_Stress_Pa_Waveform ~ Period_Time_s_Waveform, data=amb0.5hzsplit$`1`)
plot(Shear_Stress_Pa_Waveform ~ Period_Time_s_Waveform, data=amb0.5hzsplit$`2`)
plot(Shear_Stress_Pa_Waveform ~ Period_Time_s_Waveform, data=amb0.5hzsplit$`3`)
plot(Shear_Stress_Pa_Waveform ~ Period_Time_s_Waveform, data=amb0.5hzsplit$`4`)
plot(Shear_Stress_Pa_Waveform ~ Period_Time_s_Waveform, data=amb0.5hzsplit$`5`)
plot(Shear_Stress_Pa_Waveform ~ Period_Time_s_Waveform, data=amb0.5hzsplit$`6`)
plot(Shear_Stress_Pa_Waveform ~ Period_Time_s_Waveform, data=amb0.5hzsplit$`7`)
plot(Shear_Stress_Pa_Waveform ~ Period_Time_s_Waveform, data=amb0.5hzsplit$`8`)
plot(Shear_Stress_Pa_Waveform ~ Period_Time_s_Waveform, data=amb0.5hzsplit$`9`)

par(mfrow=c(2,1))
plot(Shear_Stress_Pa_Waveform ~ Period_Time_s_Waveform, data=amb0.1hzsplit$`5`)
plot(Shear_Stress_Pa_Waveform ~ Period_Time_s_Waveform, data=amb0.5hzsplit$`5`)
