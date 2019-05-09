close all

figure
plot(rawTime,rawWholeSignal)

for i=1:length(cycleStart)
    vline([cycleStart(i)],['g'])
end

hold on

for i=1:length(cycleEnd)
    vline([cycleEnd(i)],['r'])
end


 figure
 plot(rawTime, filter_out)

 
 for i=1:length(cycleStart)
    vline([cycleStart(i)],['g'])
end

hold on

for i=1:length(cycleEnd)
    vline([cycleEnd(i)],['r'])
end








 win_time = 40/1000; % sec
 overlap_per = 0.5;
 time_interval = win_time * overlap_per; % sec
 window = round(Fs*win_time);
 noverlap = round(window*overlap_per);
 F = 2048*2;
                 
 figure
 spectrogram(filter_out,window,noverlap,Fs/2,Fs,'yaxis')
 [s,w,t] = spectrogram(filter_out,window,noverlap,Fs/2,Fs,'yaxis');
 ylim([0 .5])
 
 for i=1:length(cycleStart)
    vline([cycleStart(i)],['g'])
end

hold on

for i=1:length(cycleEnd)
    vline([cycleEnd(i)],['r'])
end


bandPower = [];
bandEnergy = []; 
fh = 1000;
fl = 80;
for k = 1:length(s(1,:))

    rawBand = s(:,k);
    Ex = norm(rawBand,2)^2;  % the energy
    
    Px = (1/(fh-fl))* 1/numel(rawBand)*norm(rawBand,2)^2; % power
    bandPower(k)= Px; 
    bandEnergy(k)= Ex; 
end



smoothBandPower = smoothn(bandPower,10);


figure
title('Band Power Unsmooth')
hold on
plot(t, bandPower)

%find the local min
[TFmin, minTimeIndicies] = islocalmin(smoothBandPower);
plot(t,smoothBandPower,t(TFmin),smoothBandPower(TFmin),'r*')

%find the local max
[TFmax, maxTimeIndicies] = islocalmax(smoothBandPower);
plot(t,smoothBandPower,t(TFmax),smoothBandPower(TFmax),'b*')

 
 for i=1:length(cycleStart)
    vline([cycleStart(i)],['g'])
end

for i=1:length(cycleEnd)
    vline([cycleEnd(i)],['r'])
end

figure
hold on

plot(t,smoothBandPower,t(TFmin),smoothBandPower(TFmin),'r*')
plot(t,smoothBandPower,t(TFmax),smoothBandPower(TFmax),'b*')


for i=1:length(cycleStart)
    vline([cycleStart(i)],['g'])
end

for i=1:length(cycleEnd)
    vline([cycleEnd(i)],['r'])
end

%% This find the distance between the first minmum and the next max
timeBandPowerMins = t(TFmin);
timeBandPowerMaxs = t(TFmax);

bandPowerMins= smoothBandPower(TFmin);
bandPowerMaxs = smoothBandPower(TFmax);

bandPowerMaxs = bandPowerMaxs(2:end); %match the length of mins
deltasMinMax = bandPowerMaxs- bandPowerMins;

[deltasMinMax, deltasMinMaxIndicies] = sort(deltasMinMax, 'descend');


scatter(timeBandPowerMins(I(1:8)),bandPowerMins(I(1:8)),'k*')
