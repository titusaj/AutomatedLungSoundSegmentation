% Titus John
% August 14, 2018

clc
clear
close all

files = dir;
fileCount = 1;
cycleCount =1;

wheezeCrackleCount =1 ;
crackleCount = 1;
normalCount = 1;
wheezeCount = 1;

%Segemented groundTrutch signals with correponding Fs
Signals = {};


for i = 4:2:length(files)

            cycleStart = [];
            cycleEnd = [];
            cracklePresent = [];
            wheezePresent = [];
            numCycles = 0 ;
            cycleCount = 0;
            

            textFilename = files(i).name;
            wavFilename = files(i+1).name;

            temp = strsplit(textFilename,'.');
            recordingLabel = temp{1};
            
            
            temp2 = strsplit(temp{1},'_');
            hardware = temp2{5};

            patientNum = textFilename(1:3);


            audioLabelData =  textread(textFilename); %Read the text file into workspace

            cycleStart = audioLabelData(:,1); 
            cycleEnd = audioLabelData(:,2);
            cracklePresent = audioLabelData(:,3);
            wheezePresent = audioLabelData(:,4);
            numCycles = length(cycleStart);

            [rawWholeSignal,Fs] = audioread(wavFilename ); %Read the signal in if applicable
        
            
            allIndexStarts = [];
            
          %  if Fs == 44100

                    for j = 1:numCycles

                        cycleCount = cycleCount+1;
                    
                            if strcmp(hardware,'Litt3200') ||strcmp(hardware,'Meditron')
                            if cracklePresent(j) == 0 &&  wheezePresent(j) == 0           
                                    %time make up 
                                    dt = 1/Fs;
                                    Norig = length(rawWholeSignal);
                                    rawTime = 0:dt:(Norig*dt)-dt;


                                    [d, indexStart] = min( abs( rawTime-round(cycleStart(j),3) ));
                                    [d, indexEnd ] = min( abs( rawTime-round(cycleEnd(j),3) ));                    
                                    groundTruthSegmentedSignal = rawWholeSignal(indexStart:indexEnd);
                                    
                                    
                                    %[cd1_filter_out] = plotWaveCoeff(groundTruthSegmentedSignal, Fs);
                                    allIndexStarts(cycleCount) = indexStart;
                                    allIndexEnds(cycleCount)  = indexEnd;
                                    
                                   % figure(1)
                                    %plot(cd1_filter_out)



                %                 Signals.data{crackleCount} = groundTruthSegmentedSignal;
                %                 Signals.Fs{cracklelCount} = Fs;        
                                   normalCount= normalCount +1; 
                                    
                                    [filter_out] = plotWaveCoeff( groundTruthSegmentedSignal,Fs);
                                    
                                    %%%%%%% Here signal Remsamples
                                    Fs = 4000
                                    
                   
                                   spectrogram(filter_out,128,120,128,Fs,'yaxis')

                                     
%                                      dt = 1/Fs;
%                                      Norig = Fs;
%                                      t = 0:dt:(Norig*dt)-dt;

                                  
                                     imageName = strcat('normal_',hardware,'_',num2str(normalCount));

                                     %imagesc(t,period, abs(wt));
                                     set(gca,'XTick',[]) % Remove the ticks in the x axis!
                                     set(gca,'YTick',[]) % Remove the ticks in the y axis
                                     set(gca,'Position',[0 0 1 1]) % Make the axes occupy the hole figure
                                     
                                     %Save figure
                                     cd('CWTNormImages/')
                                     saveas(gcf,imageName,'png') 
                                     cd ..
                                   

%                                     win_time = 40/1000; % sec
%                                     overlap_per = 0.5;
%                                     time_interval = win_time * overlap_per; % sec
%                                     window = round(Fs*win_time);
%                                     noverlap = round(window*overlap_per);
%                                     F = 2048*2;
% 
%                                     Fs;
%                                     wn= (25*2) /Fs;
%                                     n=6;
%                                     [b,a] = butter(n,wn,'low');
% 
%                                     filter_out= filtfilt(b,a,rawWholeSignal);
%                                     filter_out = filter_out/max(abs(filter_out));   
                            end
                            end

                    end
                    
%                     check = isempty(allIndexStarts)
%                     if check == 0
%                         if sum(cracklePresent) ~= numCycles
%                             if Fs == 44100
%                                 %                              [groundTruthEnvelope] = plotGroundTruthEnvelope(allIndexStarts, allIndexEnds,Norig, Fs );
%                                 %                              [cd1_filter_out,downReGround] = plotWaveCoeff(rawWholeSignal, groundTruthEnvelope, Fs);
%                                 %
%                                 %                              cd1_filter_out = downsample((cd1_filter_out(2:end)),10);
%                                 %                              downReGround = downsample(downReGround,10);
%                                 %
%                                 %
%                                 %                     %            [hilbertEnv] = envelopeExtraction(filter_out, Fs);
%                                 %
%                                 %                     %            groundTruthEnvelope = downsample(groundTruthEnvelope,100);
%                                 %                     %            hilbertEnv = downsample(hilbertEnv ,100);
%                                 %
%                                 %         %                      figure(1)
%                                 %         %                      plot(groundTruthEnvelope,'r')
%                                 %                     %              hold on
%                                 %                     %              plot(hilbertEnv)
%                                 %
%                                 %                                     cd('rawVector/')
%                                 %                                     %csvwrite(strcat(temp{1},'_data.csv'),hilbertEnv)
%                                 %                                     mex_WriteMatrix(strcat(temp{1},'_data.csv'),cd1_filter_out, '%10.10f', ',', 'w+'); % 30 times faster!
%                                 %                                     cd ..
%                                 %
%                                 %                                     cd('labels/')
%                                 %                                     %writematrix(strcat(groundTruthEnvolope,temp{1},'_label.csv'),'Delimiter',' ')
%                                 %                                     %csvwrite(strcat(temp{1},'_label.csv'),groundTruthEnvolope, '%i', ' ', 'w+');  % 30 times faster!
%                                 %                                     dlmwrite((strcat(temp{1},'_label.csv')),downReGround,' ')
%                                 %                                     cd ..
%                                 %
%                                 %                                     figure(1)
%                                 %                                     plot(cd1_filter_out)
%                                 %                                     hold on
%                                 %                                     plot(downReGround,'r')
%                                 %                                     hold off
%                                 %
%                                 %                                     fileCount = fileCount+1
%                             end
%                         end
%                     end
         %   end
 
end

    

