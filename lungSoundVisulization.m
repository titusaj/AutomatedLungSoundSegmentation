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


 win_time = 40/1000; % sec
 overlap_per = 0.5;
 time_interval = win_time * overlap_per; % sec
 window = round(Fs*win_time);
 noverlap = round(window*overlap_per);
 F = 2048*2;
                 
 figure
 spectrogram(rawWholeSignal,window,noverlap,Fs/2,Fs,'yaxis')
 [s,w,t] = spectrogram(rawWholeSignal,window,noverlap,Fs/2,Fs,'yaxis');
 ylim([0 .5])
 
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

bandPower = [];

for k = 1:length(s(1,:))
    k
    rawBand = s(:,k);
    Ex = norm(rawBand,2)^2;  % the energy
    Px = 1/numel(rawBand)*norm(rawBand,2)^2 % power
    bandPower(k)= Px; 
end