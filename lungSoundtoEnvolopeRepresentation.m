          % This is for reading the segmenetation events
                            audioLabelData =  textread(textFilename); %Read the text file into workspace
                
                            cycleStart = audioLabelData(:,1); 
                            cycleEnd = audioLabelData(:,2);
                            cracklePresent = audioLabelData(:,3);
                            wheezePresent = audioLabelData(:,4);
                            numCycles = length(cycleStart);



              check = isempty(allIndexStarts)
                    if check == 0
                        if sum(cracklePresent) ~= numCycles
                            if Fs == 44100
                                                             [groundTruthEnvelope] = plotGroundTruthEnvelope(allIndexStarts, allIndexEnds,Norig, Fs );
                                                             [cd1_filter_out,downReGround] = plotWaveCoeff(rawWholeSignal, groundTruthEnvelope, Fs);
                                
                                                             cd1_filter_out = downsample((cd1_filter_out(2:end)),10);
                                                             downReGround = downsample(downReGround,10);
                                
                                
                                                    %            [hilbertEnv] = envelopeExtraction(filter_out, Fs);
                                
                                                    %            groundTruthEnvelope = downsample(groundTruthEnvelope,100);
                                                    %            hilbertEnv = downsample(hilbertEnv ,100);
                                
                                        %                      figure(1)
                                        %                      plot(groundTruthEnvelope,'r')
                                                    %              hold on
                                                    %              plot(hilbertEnv)
                                
                                                                    cd('rawVector/')
                                                                    %csvwrite(strcat(temp{1},'_data.csv'),hilbertEnv)
                                                                    mex_WriteMatrix(strcat(temp{1},'_data.csv'),cd1_filter_out, '%10.10f', ',', 'w+'); % 30 times faster!
                                                                    cd ..
                                
                                                                    cd('labels/')
                                                                    %writematrix(strcat(groundTruthEnvolope,temp{1},'_label.csv'),'Delimiter',' ')
                                                                    %csvwrite(strcat(temp{1},'_label.csv'),groundTruthEnvolope, '%i', ' ', 'w+');  % 30 times faster!
                                                                    dlmwrite((strcat(temp{1},'_label.csv')),downReGround,' ')
                                                                    cd ..
                                
                                                                    figure(1)
                                                                    plot(cd1_filter_out)
                                                                    hold on
                                                                    plot(downReGround,'r')
                                                                    hold off
                                
                                                                    fileCount = fileCount+1
                            end
                        end
                        
                        
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

                end
                  
    end
end

    

