%This script takes the ground truth timings and creates the envolope shoing
%the change states time and ending

function [groundTruthEnvolope] = plotGroundTruthEnvelope(allIndexStarts, allIndexEnds,Norig,Fs, ogFs )

    % Create the change mask envolope
    groundTruthEnvolope = ones(1, Norig);
    
    %This is the window of segmentation length that we need for
    %segementation
    halfWindowLength = .1*ogFs;
    
    for i = 1:length(allIndexStarts)      
        if allIndexStarts(i) ~= 0 && allIndexStarts(i) > halfWindowLength
            allIndexStarts(i);
            allIndexEnds(i);
            groundTruthEnvolope(allIndexStarts(i)-halfWindowLength:allIndexStarts(i)+halfWindowLength) = 0;
        end
    end
    
    
     %groundTruthEnvolope = resample(groundTruthEnvolope,Fs,ogFs);

end
