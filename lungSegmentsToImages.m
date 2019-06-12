% Titus John
% August 14, 2018

clc
close all


files = dir;
fileCount = 1;
cycleCount =1;

wheezeCrackleCount =1 ;
crackleCount = 1;
normalCount = 1;
wheezeCount = 1;
wheezeEventOverallCount = 0; 

%Segemented groundTrutch signals with correponding Fs
Signals = {};





for i = 4:2:length(files)

            cycleStart = [];
            cycleEnd = [];
            cracklePresent = [];
            wheezePresent = [];
            numCycles = 0 ;
            cycleCount = 0;
            

            
            wavFilename = files(i).name;

            temp = strsplit(wavFilename,'.');
            recordingLabel = temp{1};
            
            
            temp2 = strsplit(temp{1},'_');
            hardware = temp2{5};

            patientNum = wavFilename(1:3);
            
            tempTextFilename = strcat(temp{1},'_events.txt');
            
            if isfile(tempTextFilename)

            textFilename = files(i+1).name;
            
                %% This is to check if the file exist in the training testing split method
                 fileProcess = 0; %This variable sees if the files exist in training random spit

                for k = 1:length(TestingFileNames)
                    if strcmp(textFilename,TestingFileNames{k})
                        fileProcess = 1;
                    end
                end

                if fileProcess ==1
               %% This is for reading the segmenetation events
                %             audioLabelData =  textread(textFilename); %Read the text file into workspace
                % 
                %             cycleStart = audioLabelData(:,1); 
                %             cycleEnd = audioLabelData(:,2);
                %             cracklePresent = audioLabelData(:,3);
                %             wheezePresent = audioLabelData(:,4);
                %             numCycles = length(cycleStart);

                            [rawWholeSignal,ogFs] = audioread(wavFilename ); %Read the signal in if applicable
                            allIndexStarts = [];


                           %% This is for reading the segmenetation events
                                       fileID = fopen(textFilename);
                                       x = fscanf(fileID,'%f %f %s');
                                       fclose(fileID);


                                       tempEventCount = 0;
                                       wheezeEventCounts = 0;
                                       eventStarts = [];
                                       eventEnds = [];
                                     
                                  
                                     
                                       
                                        for eventCount= 1:length(x)
                                           if x(eventCount) == 119.0000 % This represent the ascII for wheeze start 
                                                
                                                tempEventCount = tempEventCount +1;
                                                wheezeEventCounts = wheezeEventCounts + 1;
                                                wheezeEventOverallCount = wheezeEventOverallCount +1; 
                                                
                                                eventStarts(tempEventCount ) = x(eventCount-2);
                                                eventEnds(tempEventCount) = x(eventCount-1);
                                            end  
                                        end


                                        %% This is to pick of the normal segments
                                       %if isempty(x) 
%                                            dt = 1/ogFs;
%                                            Norig = length(rawWholeSignal);
%                                            rawTime = 0:dt:(Norig*dt)-dt;
% 
%                                            normalWindow = .65; % this should be in msec
%                                            eventStarts = 0:.65:rawTime(end);
% 
% 
%                                                  for j = 1:(length(eventStarts)-1)
% 
%                                                            [d, indexStart] = min(abs( rawTime-round(eventStarts(j),3)));
%                                                            eventSignal = rawWholeSignal(indexStart:indexStart+(ogFs*.65)); % .65 sec represents the window size
%                                                            [filter_out] = plotWaveCoeff(eventSignal,ogFs);
%                                                            Fs = 4000;
%                                                                    if length(filter_out) > 128
%                                                                        spectrogram(filter_out,128,120,128,Fs,'yaxis')
% 
%                                                                        imageName = strcat('normal_',hardware,'_',num2str(normalCount));
% 
%                                                                        %imagesc(t,period, abs(wt));
%                                                                        set(gca,'XTick',[]) % Remove the ticks in the x axis!
%                                                                        set(gca,'YTick',[]) % Remove the ticks in the y axis
%                                                                        set(gca,'Position',[0 0 1 1]) % Make the axes occupy the hole figure
% 
%                                                                        %Save figure
%                                                                        cd('CWTNormImages/')
%                                                                        saveas(gcf,imageName,'png')
%                                                                        cd ..
% 
%                                                                        normalCount= normalCount +1;
%                                                                    end
%                                                  end
                                          %end
                            %% This is to pick of the wheeze segments
                             for j = 1:wheezeEventCounts %numCycles changing to events as opposed to segemented ccycles
                                cycleCount = cycleCount+1;
                                            %time make up 
                                            dt = 1/ogFs;
                                            Norig = length(rawWholeSignal);
                                            rawTime = 0:dt:(Norig*dt)-dt;


                                            [d, indexStart] = min(abs( rawTime-round(eventStarts(j),3)));
                                            [d, indexEnd ] = min(abs( rawTime-round(eventEnds(j),3)));                    
                                            groundTruthSegmentedSignal = rawWholeSignal(indexStart:indexEnd);
                                            eventSignal = rawWholeSignal(indexStart:indexEnd);
                                            length(eventSignal)
                                            
                                            
                                             %Going to center the wheeze event in the
                                             %middele of the spectorgram
                                            %eventSignal = rawWholeSignal(indexStart:indexStart+(ogFs*.65)); % .65 sec represents the window size
                                            
                                            
                                            allIndexStarts(cycleCount) = indexStart;
                                            allIndexEnds(cycleCount)  = indexEnd;

                                            normalCount= normalCount +1; 
                                            [filter_out] = plotWaveCoeff(eventSignal,ogFs);

                                            %%%%%% Here signal Remsamples
                                            Fs = 4000;

                                            if length(filter_out) > 128
                                                spectrogram(filter_out,128,120,128,Fs,'yaxis')

                                                 imageName = strcat('wheeze_',hardware,'_',num2str(normalCount));

                                                 %imagesc(t,period, abs(wt));
                                                 set(gca,'XTick',[]) % Remove the ticks in the x axis!
                                                 set(gca,'YTick',[]) % Remove the ticks in the y axis
                                                 set(gca,'Position',[0 0 1 1]) % Make the axes occupy the hole figure

                                                 %Save figure
                                                 cd('CWTWheezeImages/')
                                                 saveas(gcf,imageName,'png') 
                                                 cd ..                                                            
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
            end
end

    

