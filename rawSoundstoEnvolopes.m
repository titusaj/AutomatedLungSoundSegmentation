clear all
close all

clc

segEventFiles = dir(fullfile('Segementation Events/','*.txt'));

for i = 1:length(segEventFiles)
    
    cycleStart = [];
    cycleEnd = [];
    cracklePresent = [];
    wheezePresent = [];
    numCycles = 0 ;
    cycleCount = 0;
    fileCount = 1;
    
    groundTruthEnvelope = [];
    allIndexStarts = [];
    allIndexEnds = [];
    
    audioLabelData =  textread(fullfile('Segementation Events/',segEventFiles(i).name)); %Read the text file into workspace               
    cycleStart = audioLabelData(:,1); 
    cycleEnd = audioLabelData(:,2);
    cracklePresent = audioLabelData(:,3);
    wheezePresent = audioLabelData(:,4);
    numCycles = length(cycleStart);

    
    temp = strsplit(segEventFiles(i).name,'.');
    recordingLabel = temp{1};
    temp2 = strsplit(temp{1},'_');
    hardware = temp2{5};
    patientNum = segEventFiles(i).name(1:3);
    wavFilename = strcat(temp2{1},'_',temp2{2},'_',temp2{3},'_',temp2{4},'_',temp2{5},'.wav');

    if exist(wavFilename)
        %Load the raw signal
        [rawWholeSignal,ogFs] = audioread(fullfile(wavFilename)); 
        Norig = length(rawWholeSignal);
        
         for j =1:numCycles
             cycleCount = cycleCount +1;
              %time make up 
              dt = 1/ogFs;
              Norig = length(rawWholeSignal);
              rawTime = 0:dt:(Norig*dt)-dt;
              [d, indexStart] = min(abs(rawTime-round(cycleStart(j),3)));
              [d, indexEnd ] = min(abs(rawTime-round(cycleEnd (j),3)));            
              allIndexStarts(cycleCount) = indexStart;
              allIndexEnds(cycleCount)  = indexEnd;
         end
         

         if ogFs > 4000
            %Resample to 4000
            Fs = 4000;
            reSampledRawWhole = resample(rawWholeSignal,Fs,ogFs);
            Nresampled = length(reSampledRawWhole);
         end

        hardware
        ogFs

        [groundTruthEnvelope] = plotGroundTruthEnvelope(allIndexStarts, allIndexEnds,Norig, Fs, ogFs );
        [cd1_filter_out,downReGround] = plotWaveCoeff(reSampledRawWhole,groundTruthEnvelope, Fs);
        %[hilbertEnv] = envelopeExtraction(cd1_filter_out, ogFs);

  
        
%         groundTruthEnvelope = downsample(groundTruthEnvelope,100);
%         hilbertEnv = downsample(hilbertEnv ,100);
% 
%         figure(1)
%         plot(groundTruthEnvelope,'r')
%         hold on
%         plot(hilbertEnv)

%         cd('rawVector/')
%         %csvwrite(strcat(temp{1},'_data.csv'),hilbertEnv)
%         mex_WriteMatrix(strcat(temp{1},'_data.csv'),cd1_filter_out, '%10.10f', ',', 'w+'); % 30 times faster!
%         cd ..
% 
%         cd('labels/')
%         %writematrix(strcat(groundTruthEnvolope,temp{1},'_label.csv'),'Delimiter',' ')
%         %csvwrite(strcat(temp{1},'_label.csv'),groundTruthEnvolope, '%i', ' ', 'w+');  % 30 times faster!
%         dlmwrite((strcat(temp{1},'_label.csv')),downReGround,' ')
%         cd ..
% 
%         figure(1)
%         plot(cd1_filter_out)
%         hold on
%         plot(downReGround,'r')
%         hold off

        fileCount = fileCount+1
end                    

end