%%  Script for plotting rheometer data - Frequency Sweeps

%Importing data from an excel file that has multiple sheets and saving to a
%new variable
Freq_Amp_Data = importdata('02_07_2020_02_12_2020_cteno_freq_amp_sweeps.xlsx');

%Taking out the frequency data from my file where I used the shaking
%protocol
%Freq_Amp_Data.data.Sheet__ indicates which sheet you want to take data
%from
%(:,8) indicates that you are going to take an entire column "that's what
%:" means, 8 indicates the column that you want to take out - for me frequency
%was column 8
shaking_freq_sweep_freq = Freq_Amp_Data.data.Sheet14(:,8);
%This line takes out the rows in the data that don't have any data in them,
%not really sure how it works to be honest, I just looked it up
shaking_freq_sweep_freq(any(isnan(shaking_freq_sweep_freq),2),:)=[]

%This takes out the loss modulus data, similar process as above
shaking_freq_sweep_lossmodulus = Freq_Amp_Data.data.Sheet14(:,12);
%Removes rows that have no data same as above
shaking_freq_sweep_lossmodulus(any(isnan(shaking_freq_sweep_lossmodulus),2),:)=[]

%Taking out the storage modulus
shaking_freq_sweep_storagemodulus = Freq_Amp_Data.data.Sheet14(:,11);
%Removing rows that have no data
shaking_freq_sweep_storagemodulus(any(isnan(shaking_freq_sweep_storagemodulus),2),:)=[]


%Taking out frequency data for whole animal data
animal_freq_sweep_freq = Freq_Amp_Data.data.Sheet15(:,8);
%Removing empty cells
animal_freq_sweep_freq(any(isnan(animal_freq_sweep_freq),2),:)=[]

%taking out loss modulus data
animal_freq_sweep_lossmodulus = Freq_Amp_Data.data.Sheet15(:,12);
%Removing empty cells
animal_freq_sweep_lossmodulus(any(isnan(animal_freq_sweep_lossmodulus),2),:)=[]

%taking out storage modulus data
animal_freq_sweep_storagemodulus = Freq_Amp_Data.data.Sheet15(:,11);
%Removing empty cells
animal_freq_sweep_storagemodulus(any(isnan(animal_freq_sweep_storagemodulus),2),:)=[]


%Plotting the data
%Specify figure number, clf and box on just make it look nice
figure(1), clf, box on;

%Using plot function to plot freq vs loss and storage modulu, you can
%specify different colors, linewidths, and linestyles to specify different
%data
plot(shaking_freq_sweep_freq, shaking_freq_sweep_lossmodulus, 'linewidth', 3, 'color', 'red', 'linestyle', '-')
%hold on allows you to plot multiple things on one graph
hold on
%other data
plot(shaking_freq_sweep_freq, shaking_freq_sweep_storagemodulus, 'linewidth',3, 'color', 'blue', 'linestyle',':')
plot(animal_freq_sweep_freq, animal_freq_sweep_lossmodulus, 'linewidth', 3, 'color', 'green', 'linestyle','-')
plot(animal_freq_sweep_freq, animal_freq_sweep_storagemodulus, 'linewidth', 3, 'color', 'yellow', 'linestyle',':')
%hold off tells that you're done plotting
hold off

%gca just looks axes look nice
ax = gca;
%specifies font size for axes
ax.FontSize = 22;
%Changing Y axis to a log scale
ax.YScale = 'log';

%Labeling the x and y axes and the legend
xlabel('Frequency (Hz)')
ylabel('Pa')
legend('Shaking Protocol - G" Loss Modulus',' Shaking Protocol - Gprime Storage Modulus','Whole Animal - G" Loss Modulus','Whole Animal - Gprime Storage Modulus')

%% Rheometer data - Amplitude/Strain sweeps 

%shaking protocol data, getting out frequency info
shaking_amp_sweep_strain = Freq_Amp_Data.data.Sheet12(:,9);
%removing empty cells
shaking_amp_sweep_strain(any(isnan(shaking_amp_sweep_strain),2),:)=[]

%getting out loss modulus data
shaking_amp_sweep_lossmodulus = Freq_Amp_Data.data.Sheet12(:,12);
%removing empty cells
shaking_amp_sweep_lossmodulus(any(isnan(shaking_amp_sweep_lossmodulus),2),:)=[]

%getting out storage modulus data
shaking_amp_sweep_storagemodulus = Freq_Amp_Data.data.Sheet12(:,11);
%removing empty cells
shaking_amp_sweep_storagemodulus(any(isnan(shaking_amp_sweep_storagemodulus),2),:)=[]

% Whole animal protocol

%getting freq data
animal_amp_sweep_strain = Freq_Amp_Data.data.Sheet9(:,9);
animal_amp_sweep_strain(any(isnan(animal_amp_sweep_strain),2),:)=[]
 
animal_amp_sweep_lossmodulus = Freq_Amp_Data.data.Sheet9(:,12);
animal_amp_sweep_lossmodulus(any(isnan(animal_amp_sweep_lossmodulus),2),:)=[]

animal_amp_sweep_storagemodulus = Freq_Amp_Data.data.Sheet9(:,11);
animal_amp_sweep_storagemodulus(any(isnan(animal_amp_sweep_storagemodulus),2),:)=[]

%plotting amplitude data
figure(2), clf, box on;
plot(shaking_amp_sweep_strain, shaking_amp_sweep_lossmodulus, 'linewidth', 3, 'color', 'red', 'linestyle', '-')
hold on
plot(shaking_amp_sweep_strain, shaking_amp_sweep_storagemodulus, 'linewidth',3, 'color', 'blue', 'linestyle',':')
plot(animal_amp_sweep_strain, animal_amp_sweep_lossmodulus, 'linewidth', 3, 'color', 'green', 'linestyle','-')
plot(animal_amp_sweep_strain, animal_amp_sweep_storagemodulus, 'linewidth', 3, 'color', 'yellow', 'linestyle',':')
hold off
ax = gca;
ax.FontSize = 22;

ax.YScale = 'log';


xlabel('Strain (%)')
ylabel('Pa')
legend('Shaking Protocol - G" Loss Modulus',' Shaking Protocol - Gprime Storage Modulus','Whole Animal - G" Loss Modulus','Whole Animal - Gprime Storage Modulus')
" Loss Modulus - 0.5Hz','Gprime Storage Modulus - 0.5Hz', 'G" Loss Modulus - 1 Hz'. 'Gprime Storage Modulus - 1Hz')