clear all
close all
clc

files = dir(fullfile(pwd, '*.txt'));
cycleCount = 1; % This is numfiles * the cycle count (based on each file thats read into memory)


for i = 8:length(files)
i
%Intialize and clear variables each time    
rawWholeSignal = [];
rawTime = [];
cycleStart = [];
cycleEnd = [];
cracklePresent = [];
wheezePresent = [];
numCycles = 0 ;

            
    
    
eventFilename = files(i).name;

temp = strsplit(eventFilename,'.');
recordingLabel = temp{1};


temp2 = strsplit(temp{1},'_');
hardware = temp2{5}

patientNum = eventFilename(1:3);
            
            
wavFilename = strcat(temp2{1},'_',temp2{2},'_',temp2{3},'_',temp2{4},'_',temp2{5},'.wav');

%% This is for reading the segmenetation events
audioLabelData =  textread(eventFilename); %Read the text file into workspace
cycleStart = audioLabelData(:,1); 
cycleEnd = audioLabelData(:,2); 
cracklePresent = audioLabelData(:,3);
wheezePresent = audioLabelData(:,4);
numCycles = length(cycleStart);



if isfile(wavFilename) && sum(wheezePresent)  > 0 || sum(cracklePresent) > 0   % right now just looking the normal fiels         
       %% This is to calculate information about cycles
         for j = 1:numCycles
             allCycleLengths(j) = cycleEnd(j) - cycleStart(j);
             cycleCount = cycleCount +1; 
         end
             
         halfMedianCycleLength = median(allCycleLengths)/2;
             
        %% Read the raw signal
        [rawWholeSignal,fs] = audioread(wavFilename ); %Read the signal in if applicable
        dt = 1/fs;
        Norig = length(rawWholeSignal);
        rawTime = 0:dt:(Norig*dt)-dt;
        
        %% Extract the PCG features
%      [PCG_Features, featuresFs] = getSpringerPCGFeatures(rawWholeSignal, fs);
        
        %% Filter the signal
        filter_out = bandpass(rawWholeSignal,[200 1000],fs);
       
        % norm the signal magnitude
        normfilterOut = filter_out - min(filter_out(:));
        normfilterOut = normfilterOut ./ max(normfilterOut(:)) ;% *
       

            
        %% Segment out the cycles
        for j = 1:numCycles
            [d, indexStarts(j)] = min(abs( rawTime-round(cycleStart(j),3)));
            [d, indexEnds(j) ] = min(abs( rawTime-round(cycleEnd(j),3)));                    
%             groundTruthSegmentedSignal = normfilterOut(indexStart:indexEnd);
%             THRESHOLD = 2.5
%             runLTSD(fs,groundTruthSegmentedSignal,THRESHOLD )  
        end
%         close all
%         
%         figure(1);
%         t1 = (1:length(groundTruthSegmentedSignal))./fs;
%         plot(t1, groundTruthSegmentedSignal)

        %% Plot the signal with the ground truth
            figure('Name', 'PCG features');
            t1 = (1:length(rawWholeSignal))./fs;
            plot(t1,rawWholeSignal);
            hold on;
            %t2 = (1:length(PCG_Features))./featuresFs;
            %plot(t2,PCG_Features);


            for k=1:length(cycleStart)
                vline([cycleStart(k)],['g'])
                %%this draw a line midway adding the half median cycle
                %%count to the start of the cycle
                 %if k ~=length(cycleStart) % check not at the end
                 %    vline([cycleStart(k)+halfMedianCycleLength],['k'])
                 %end
           end
            
            hold on
            for k=1:length(cycleEnd)
                vline([cycleEnd(k)],['r'])
            end
            hold off
            
            
            
            %% Create Ground Truth Envelope bsed on the segmented cycle annotation
            groundTruthEnvolope = zeros(1, length(t1));
            for j = 1:numCycles
                
                if wheezePresent(j) == 1
                    groundTruthEnvolope(indexStarts(j):indexEnds(j)) = 1; %Set wheeze to 1

                elseif cracklePresent(j) == 1
                    groundTruthEnvolope(indexStarts(j):indexEnds(j)) = 2; %Set crackle to two
                    
                elseif cracklePresent(j) == 1 && wheezePresent(j) == 1
                    groundTruthEnvolope(indexStarts(j):indexEnds(j)) = 3; %Set crackle to three
                    
                end
            end
            
            hold on
            plot(t1,groundTruthEnvolope,'k');
          
%% Write the raw vector to a file
%         cd('rawHilberts/')
%         %csvwrite(strcat(temp{1},'_data.csv'),hilbertEnv)
%         length(PCG_Features(:,3))
%         dlmwrite(strcat(temp{1},'_data.csv'),PCG_Features(:,3)); % 30 times faster!
%         cd ..
%         
      

 
end

end
