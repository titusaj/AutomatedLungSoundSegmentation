clear
close all

files = dir;
fileCount = 1;
cycleCount =1;

crackleCount = 1;
wheezeCount = 1;



for i = 3:1:length(files)

    if files(i).bytes > 0
         textFilename = files(i).name;
         temp = strsplit(textFilename,'.');
         recordingLabel = temp{1};

         patientNum = textFilename(1:3);
         
         fileID = fopen(textFilename);
         x = fscanf(fileID,'%f %f %s');
         fclose(fileID);
         
            wheezeEventCounts = 1;
            eventStarts = [];
            eventEnds = [];

            for i = 1:length(x)
                if x(i) == 119.0000 % This represent the ascII for wheeze start 
                    eventStarts(wheezeEventCounts) = x(i-2);
                    eventEnds(wheezeEventCounts) = x(i-1);
             
                    wheezeEventCounts = wheezeEventCounts + 1;
                end  
            end
         
        eventsDiff= eventEnds - eventStarts;
        allMeans(i) = mean(eventsDiff);
        
    end
     
     
end