% Titus John
% August 14, 2018

clc
clear

files = dir;
fileCount = 1;
cycleCount =1;

wheezeCrackleCount =1 ;
crackleCount = 1;
wheezeCount = 1;
normalCount = 1;

%Segemented groundTrutch signals with correponding Fs
Signals = {};

for i = 4:2:length(files)
    
    cycleStart = [];
    cycleEnd = [];
    cracklePresent = [];
    wheezePresent = [];
    numCycles = 0 ;
    
    textFilename = files(i).name;
    wavFilename = files(i+1).name;
    
    temp = strsplit(textFilename,'.');
    recordingLabel = temp{1};
    
    patientNum = textFilename(1:3);
    
    
    audioLabelData =  textread(textFilename); %Read the text file into workspace
    
    cycleStart = audioLabelData(:,1); 
    cycleEnd = audioLabelData(:,2);
    cracklePresent = audioLabelData(:,3);
    wheezePresent = audioLabelData(:,4);
    numCycles = length(cycleStart);
    
   
    imageCreated =0; 
    
    for j = 1:numCycles
           
        cycleCount = cycleCount+1;
        %disp(strcat('Cycle Count',num2str(cycleCount)));
            

%        if cracklePresent(j) == 0 && wheezePresent(j) == 1      
                wheezeCount = wheezeCount + 1
                
                [rawWholeSignal,Fs] = audioread(wavFilename ); %Read the signal in if applicable
                %time make up 
                dt = 1/Fs;
                Norig = length(rawWholeSignal);
                t = 0:dt:(Norig*dt)-dt;
                
                [d, indexStart] = min( abs( t-round(cycleStart(j),3) ));
                [d, indexEnd ] = min( abs( t-round(cycleEnd(j),3) ));                    
                groundTruthSegmentedSignal = rawWholeSignal(indexStart:indexEnd);
                 %groundTruthSegmentedSignal = downsample(groundTruthSegmentedSignal,10);
                
               
                
%                 Signals.data{crackleCount} = groundTruthSegmentedSignal;
%                 Signals.Fs{cracklelCount} = Fs;        
                    normalCount= normalCount +1; 
                    
                    win_time = 40/1000; % sec
                    overlap_per = 0.5;
                    time_interval = win_time * overlap_per; % sec
                    window = round(Fs*win_time);
                    noverlap = round(window*overlap_per);
                    F = 2048*2;
                 
% 
%                     figure(1)
%                     spectrogram(groundTruthSegmentedSignal,window,noverlap,Fs/2,Fs,'yaxis');
%                     ylim([0 2])
                    
                    Fs;
                    wn= [80 1000]*2 /Fs;
                    n=4;
                    [b,a] = butter(n,wn,'bandpass');
                    filter_out= filtfilt(b,a,rawWholeSignal);
                    filter_out = filter_out/max(abs(filter_out));


%                       figure(4)
%                       plot(filter_out)
% %                    [wt, period] = cwt( filter_out,Fs); 
% 
% 
%                   
% 
%         
%                     
%                      figure(2)
%                      spectrogram(filter_out,window,noverlap,Fs/2,Fs,'yaxis');
%                      ylim([0 2])
%                      
%                      figure(3)
%                       [wt, period] = cwt(filter_out,Fs); 
%                      imagesc(t,period, flipud(abs(wt)));
%                      set(gca,'XTick',[]) % Remove the ticks in the x axis!
%                      set(gca,'YTick',[]) % Remove the ticks in the y axis
%                      set(gca,'Position',[0 0 1 1]) % Make the axes occupy the whole figure

% %                     cd('normal/')
%                     imageName =  strcat('normal','_',recordingLabel,'_',num2str(j));
%                     imageName
%                     saveas(gcf,imageName,'png')
%                     cd ..
%            end   
    
    end

    fileCount = fileCount+1;
   
end

    

