%This script takes the ground truth timings and creates the envolope shoing
%the change states time and ending

function [groundTruthEnvolope] = plotGroundTruthEnvelope(allIndexStarts, allIndexEnds,Norig, Fs )

    
   
    changeIndex = horzcat(allIndexStarts,allIndexEnds(end));

    j=2;
   
    % Create the change mask envolope
    groundTruthEnvolope = [];
    
    for i = 1:Norig       
    groundTruthEnvolope(i) = 0 ;
    
        if i == changeIndex(j) && j<length(changeIndex)
            
            samplesAdjusted = (1/(Fs/200))*Fs; 
            groundTruthEnvolope((i-samplesAdjusted):(i+samplesAdjusted)) = 1; 
            
            j = j+1;
            i = i +10;
        end
        
    end
    
end
