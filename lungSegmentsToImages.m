% Titus John
% May 13, 2019

clc
clear



files = dir(fullfile(pwd, '*.txt'));
fileCount = 1;
cycleCount =1;

wheezeCrackleCount =1 ;
crackleCount = 1;
normalCount = 1;
wheezeCount = 1;

wheezeEventOverallCount = 0 ; 
crackleEventOverallCount = 0 ; 

AllCrackleTimeStarts = [];
checkErrorTemp = 0;
usableEvents = 0; 

%Segemented groundTrutch signals with correponding Fs
Signals = {};





for i = 1:length(files) %this reps the first 200 patients

            cycleStart = [];
            cycleEnd = [];
            cracklePresent = [];
            wheezePresent = [];
            numCycles = 0 ;
            cycleCount = 0;
            

            
            eventFilename = files(i).name;

            temp = strsplit(eventFilename,'.');
            recordingLabel = temp{1};
            
            
            temp2 = strsplit(temp{1},'_');
            hardware = temp2{5};

            patientNum = eventFilename(1:3);
            
            
            wavFilename = strcat(temp2{1},'_',temp2{2},'_',temp2{3},'_',temp2{4},'_',temp2{5},'.wav');
            
  
            
            if isfile(wavFilename)
                %% This is to check if the file exist in the Testing testing split method
                  fileProcess = 1; %This variable sees if the files exist in Testing random spit
% 
%                 for k = 1:length(TestingFileNames)
%                     if strcmp(eventFilename,TestingFileNames{k}) %&& files(i).bytes == 0 %making sure the files is really empty
%                         fileProcess = 1;
%                     end
%                 end
%     
               
                if fileProcess ==1
     
                            [rawWholeSignal,ogFs] = audioread(wavFilename ); %Read the signal in if applicable
                            allIndexStarts = [];


                           %% This is for reading the  event text files
                                       fileID = fopen(eventFilename);
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

                                                
                                                AllWheezeTimeStarts(wheezeEventOverallCount) = x(eventCount-1);
                                                
                                                eventStarts(tempEventCount ) = x(eventCount-2);
                                                eventEnds(tempEventCount) = x(eventCount-1);
                                            end  
                                        end

                                        
                                       wheezeEventCounts 
                                        
                                   

        
%% This is to pick of the normal segments
%                    if isempty(x) 
%                         dt = 1/ogFs;
%                         Norig = length(rawWholeSignal);
%                         rawTime = 0:dt:(Norig*dt)-dt;
% 
%                         normalWindow = .65; % this should be in msec
%                         eventStarts = 0:.65:rawTime(end);
% 
% 
%                              for j = 1:(length(eventStarts)-1)
% 
%                                        [d, indexStart] = min(abs( rawTime-round(eventStarts(j),3)));
%                                        
%                                        eventSignal = rawWholeSignal(indexStart:indexStart+(ogFs*.65)); % .65 sec represents the window size
%                                        figure(3)
%                                        plot(eventSignal)
%                                        
%                                        [filter_out] = plotWaveCoeff(eventSignal,ogFs);
%                                        figure(4)
%                                        plot(filter_out)
%                                        
%                                        Fs = 4000;
%                                                if length(filter_out) > 128
%                                                    figure(1)
%                                                    spectrogram(filter_out,128,120,128,Fs,'yaxis')
% 
%                                                    imageName =  strcat('normal_',patientNum,'_',hardware,'_',num2str(i),'_',num2str(normalCount));
% 
% 
%                                                    set(gca,'XTick',[]) % Remove the ticks in the x axis!
%                                                    set(gca,'YTick',[]) % Remove the ticks in the y axis
%                                                    set(gca,'Position',[0 0 1 1]) % Make the axes occupy the hole figure
% 
%                                                     % Save the figure 
%                                                     cd('CWTNormImages/')
%                                                     saveas(gcf,imageName,'png')
%                                                     cd ..
%                 
%                                                    normalCount= normalCount +1;
%                                                end
%                              end
%                     end
%% This is to pick of the wheeze segments
                            
                             
                             for j = 1:wheezeEventCounts %numCycles changing to events as opposed to segemented cycles
                                        cycleCount = cycleCount+1;

                                        %time make up 
                                        dt = 1/ogFs;
                                        Norig = length(rawWholeSignal);
                                        rawTime = 0:dt:(Norig*dt)-dt;


                                        [d, indexStart] = min(abs( rawTime-round(eventStarts(j),3)));
                                        [d, indexEnd ] = min(abs( rawTime-round(eventEnds(j),3)));                    
                                        groundTruthSegmentedSignal = rawWholeSignal(indexStart:indexEnd);
                                        %eventSignal = rawWholeSignal(indexStart:indexEnd);

                                         %Going to center the wheeze event in the
                                         %middele of the spectorgram
                                         if (indexStart+(ogFs*.325)) < indexEnd && length(rawWholeSignal) > (indexEnd+(ogFs*.325)) && (indexStart-(ogFs*.325)) > 0                  
                                            usableEvents = usableEvents + 1; 

                                            s = (indexStart-ceil(ogFs*.325));
                                            e = (indexEnd+ceil(ogFs*.325));



                                            eventSignal = rawWholeSignal(s:e); % .65 sec represents the window size
                                            eventSignal = resample(eventSignal,4000,ogFs);
                                            windowEventSignalSplit(eventSignal,ogFs,hardware,wheezeEventOverallCount, patientNum)
                                          end


                                        allIndexStarts(cycleCount) = indexStart;
                                        allIndexEnds(cycleCount)  = indexEnd;

                                        normalCount= normalCount +1; 
                                    end
            end
                    

                  
    end
end

    

