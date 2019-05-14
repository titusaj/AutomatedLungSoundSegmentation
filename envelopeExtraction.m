% Titus John
% May 11, 2019

% This function takes the filtered signal and gives out the the diffrent
% envolopes of matching length.

function [hiltbertEnv] = envelopeExtraction(filteredSignal, Fs)

% %%  Homomorphic 
%     lpf_frequency = 80;
%     homomorphicEnv = Homomorphic_Envelope_with_Hilbert(filteredSignal, Fs,lpf_frequency);
%     

%% Hilbert
    hiltbertEnv = abs(hilbert(filteredSignal));

% %% Wavelet
%     win_time = 40/1000; % sec
%     overlap_per = 0.5;
%     time_interval = win_time * overlap_per; % sec
%     window = round(Fs*win_time);
%     noverlap = round(window*overlap_per);
%     F = 2048*2;
% 
%     [s,w,t] = spectrogram(filteredSignal,window,noverlap,Fs/2,Fs,'yaxis');
% 
% 
%      
%         bandPower = []; 
%         bandEnergy = []; 
%         fh = 1000;
%         fl = 80;
% 
%          for k = 1:length(s(1,:))
% 
%              rawBand = s(:,k);
%              Ex = norm(rawBand,2)^2;  % the energy
% 
%              Px = (1/(fh-fl))* 1/numel(rawBand)*norm(rawBand,2)^2; % power
%              bandPower(k)= Px; 
%              bandEnergy(k)= Ex; 
%          end
% 
% 
%         WaveEnv = bandPower;
% 
% %% PSD
%     N = length(filteredSignal);
%     filteredSignal_dft = fft(filteredSignal);
%     PSDEnv= (1/(2*pi*N)) * abs(filteredSignal_dft).^2;

end