getwd()

# Load packages
library("readxl"); library("xlsx"); library("janitor"); library("expss"); library("ggplot2")
library("tidyverse")

# Read in the data
SiphAmp <- read.csv("Jan23-2020_SiphTest/SweeneyLab_jan23-2020_siph_ampsweep.csv",col.names = x,y)
SiphAmp <- read.csv(header=T, sep=",",file="/Jan23-2020_SiphTest/SweeneyLabsiphjan232020attempt2.csv",col.names = x,y)

feb9freqsweepforskalialive.necto.sandpaperbottom <- read.xlsx2("./rheo/feb9_freqsweep.xlsx", sheetIndex =1, 
                                                               as.data.frame = T, header=F, startRow = 4,
                                                               stringsAsFactors=FALSE)
units <- feb9freqsweepforskalialive.necto.sandpaperbottom[3,]
names(feb9freqsweepforskalialive.necto.sandpaperbottom) <- c("PointNo.","TestTime","AverageTime","DeflectionAngle",
                                                             "Torque","NormalForce","Gap","Frequency","ShearStrain",
                                                             "ShearStress","StorageModulus","LossModulus","StorageCompliance",
                                                             "LossCompliance","ShearStrainWF","ShearStressWF")
nounits <- feb9freqsweepforskalialive.necto.sandpaperbottom[-(1:3), ]

freq <- drop_empty_rows(as.data.frame(as.array(nounits$Frequency)))
freq <- as.numeric(unlist(freq[1]))
LossMod <- drop_empty_rows(as.data.frame(as.array(nounits$`LossModulus`)))
LossMod <- as.numeric(unlist(LossMod[1]))
StorMod <- drop_empty_rows(as.data.frame(as.array(nounits$`StorageModulus`)))
StorMod <- as.numeric(unlist(StorMod[1]))

is.numeric(LossMod)
plot(freq, LossMod)

all <- cbind(freq, LossMod, StorMod)
all <- as.data.frame(all)

colors <- c("LossMod"="blue","StorMod"="red")



# Jan12,2021
#sheet 3 is 1hz for amplitude
#sheet 3 is 1%strain for freq
CyaneaMiddleFreq <- read.xlsx2("./Data(Jan2021)/Cnido/cyanea/10-20-2020_cyanea1_middlebell_freq_sweeps.xlsx", sheetIndex = 3, 
                              as.data.frame = T, header=F, startRow = 2,
                              stringsAsFactors=FALSE)
units <- CyaneaMiddleFreq[3,]
names(CyaneaMiddleFreq) <- c("PointNo.","TestTime","AverageTime","DeflectionAngle",
                                                             "Torque","NormalForce","Gap","Frequency","ShearStrain",
                                                             "ShearStress","StorageModulus","LossModulus","StorageCompliance",
                                                             "LossCompliance","ShearStrainWF","ShearStressWF","PhaseShift",
                                                              "Viscosity","Temperature")
nounits <- CyaneaMiddleFreq[-(1:3), ]

freq <- drop_empty_rows(as.data.frame(as.array(nounits$Frequency)))
freq <- as.numeric(unlist(freq[1]))
LossMod <- drop_empty_rows(as.data.frame(as.array(nounits$`LossModulus`)))
LossMod <- as.numeric(unlist(LossMod[1]))
StorMod <- drop_empty_rows(as.data.frame(as.array(nounits$`StorageModulus`)))
StorMod <- as.numeric(unlist(StorMod[1]))
Stress <- drop_empty_rows(as.data.frame(as.array(nounits$`ShearStress`)))
Stress <- as.numeric(unlist(Stress[1]))
Strain <- drop_empty_rows(as.data.frame(as.array(nounits$`ShearStrain`)))
Strain <- as.numeric(unlist(Stress[1]))

StressWF <- drop_empty_rows(as.data.frame(as.array(nounits$`ShearStressWF`)))
StressWF <- as.numeric(unlist(StressWF[1]))
StrainWF <- drop_empty_rows(as.data.frame(as.array(nounits$`ShearStrainWF`)))
StrainWF <- as.numeric(unlist(StrainWF[1]))

is.numeric(LossMod)
plot(freq, LossMod)

# stress vs strain
plot(StressWF, StrainWF)


all <- cbind(freq, LossMod, StorMod)
all <- as.data.frame(all)

colors <- c("LossMod"="blue","StorMod"="red")


ChrysaoraMiddleAmp <- read.xlsx2("./Data(Jan2021)/Cnido/cyanea/10-20-2020_cyanea1_middlebell_ampsweeps.xlsx", sheetIndex = 3, 
                                as.data.frame = T, header=F, startRow = 2,
                                stringsAsFactors=FALSE)
AeqMiddleAmp <- 


nounits <- feb9freqsweepforskalialive.necto.sandpaperbottom[-(1:3), ]

freq <- drop_empty_rows(as.data.frame(as.array(nounits$Frequency)))
freq <- as.numeric(unlist(freq[1]))
LossMod <- drop_empty_rows(as.data.frame(as.array(nounits$`LossModulus`)))
LossMod <- as.numeric(unlist(LossMod[1]))
StorMod <- drop_empty_rows(as.data.frame(as.array(nounits$`StorageModulus`)))
StorMod <- as.numeric(unlist(StorMod[1]))

is.numeric(LossMod)
plot(freq, LossMod)

all <- cbind(freq, LossMod, StorMod)
all <- as.data.frame(all)

colors <- c("LossMod"="blue","StorMod"="red")

q <- ggplot(all, aes(x=freq)) + 
                geom_line(aes(y=LossMod, color="LossMod"), size=1.5) + 
                geom_line(aes(y=StorMod, color="StorMod"), size=1.5) + 
                labs(x='Frequency (Hz)',
                    y = "Pa",
                    color="Legend") +
                scale_color_manual(values=colors) +
                labs("Forskalia Live Nectophore") +
                theme(legend.justification = c("right", "top"),
                      plot.title = element_text(hjust = 0.5, face="bold"), 
                      legend.position="right", 
                      legend.title = element_text(colour = "black",size=16) +
                      scale_color_discrete(name="Variables"))
q


cy1midbellsandtop1_amp_5hz, 
cy1midbellsandbot1_amp_5hz, 
cy2midbellsandtop1_amp_5hz, 
cy2midbellsandbot1_amp_5hz

cy1outerbell_amp_5hz
cy2outerbell_amp_5hz

cy1middle_amp_5hz
cy2middle_amp_5hz

cy1sidecut1_amp_5hz
cy1sidecut2_amp_5hz

cy2sidecut1_amp_5hz
cy2sidecut2_amp_5hz














