# using oreo to plot rheology data
library(oreo); library(readxl); library(tibble)
library(tidyr); library(dplyr); library(magrittr)

# data is in four columns for applied strain control
#     Time (s)
#     Strain (-)
#     Rate (1/s)
#     Stress (Pa)

##example
data(mydata)
print(mydata)
class(mydata)
# SPP analysis via fourier
exampledf <- rpp_read2(mydata, selected=c(2,3,4,0,0,1,0,0))
exampletimewave <- exampledf$raw_time
examplerespwave <- data.frame(exampledf$strain, exampledf$strain_rate, exampledf$stress)
exampleout <- rpp_fft(exampletimewave, examplerespwave,L=1024,
                      omega=3.16,M=15,p=1)
  # L is number of measurement points
  # omega is frequency of oscillation (rad/s)
  # M is number of harmonics for stress
  # p is number of cycles
# they had frequency 3.16, harmonics 15, max harmonics 512
print(exampleout)
str(exampleout)
##


data <- read_excel("./Data-Redo/Cnido/aequorea/11-03-2020-aequoreamiddlebellamp.xlsx", sheet = 1, 
                   na = "", col_names = TRUE)
datadf <- as.data.frame(data)
print(datadf)
datadf[is.na(datadf)] <- "0"
dataa <- datadf %>% 
  mutate_at(c('stress','strain'), ~replace_na(.,"0"))
dataa
str(dataa)
str(datadf)
datadf <- as.numeric(datadf)

df <- rpp_read2(datadf, selected=c(5,3,6,0,0,1,4,2))
dataexample <- rpp_read2(mydata, selected=c(2,3,4,0,0,1,0,0))
str(df)
str(data)
time_wave <- df$raw_time
tw <- dataexample$raw_time
resp_wave <- data.frame(df$raw_strain, df$strain_rate, df$raw_stress)
resp_wave_ex <- data.frame(dataexample$strain, dataexample$strain_rate, dataexample$stress)
outf <- Rpp_num(time_wave, resp_wave, L=5130, k=10, num_mode = 2,
               omega=5, p=10)
out <- rpp_fft(time_wave, resp_wave, L=5130, omega=5, p=10, M=10)
out2 <- Rpp_num(tw, resp_wave_ex, L=1024, k=8, num_mode = 1)
outf
str(outf)
str(out)
str(out2)
strain= out$spp_data_out$strain
delta_t_dot= out$spp_data_out$delta_t_dot
delta_t= out$spp_data_out$delta_t


plotDeltaStrain(strain, delta_t, ylim=c(0,300))
plotPAV(strain, delta_t_dot)
plotTimeStrain(out$spp_data_out$time_wave, out$spp_data_out$strain,
               out$spp_data_in$time_wave, out$spp_data_in$strain, 
               plot(xlim=1))
plotTimeStrain(time_wave, out$spp_data_out$strain)
plotTimeRate(out$spp_data_out$time_wave, out$spp_data_out$rate,
             out$spp_data_in$time_wave, out$spp_data_in$strain_rate)
plotStressTime(out$spp_data_out$time_wave, out$spp_data_out$stress,
               out$spp_data_in$time_wave, out$spp_data_in$stress)
plotFft(out$ft_out$ft_amp, out$ft_out$fft_resp)
plotStressTime(out$spp_data_in$time_wave, out$spp_data_in$stress, time_wave, out$spp_data_out$stress)
