%This script takes the ground truth timings and creates the envolope shoing
%the change states time and ending

function [groundTruthEnvolope] = plotGroundTruthEnvelope(allIndexStarts, allIndexEnds,Norig, Fs )

    % Create the change mask envolope
    groundTruthEnvolope = zeros(1, Norig);
    
    for i = 1:length(allIndexStarts)      
        if allIndexStarts(i) ~= 0
            allIndexStarts(i);
            allIndexEnds(i);
            groundTruthEnvolope(allIndexStarts(i):allIndexEnds(i)) = 1;
        end
    end
    
end
