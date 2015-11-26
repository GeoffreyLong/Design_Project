function [  nTrueDetections, nFalsePositives, nFalseNegatives ] = evaluatedetection( truthRect, detectRect )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% The percent error in the placement and sizing of the rect
%TODO see if this is good for our purposes
PLACEMENT_TOL = 0.30;
SIZE_TOL = 0.20;

% Seed the counters to 0
nTrueDetections = 0;
nFalsePositives = 0;
nFalseNegatives = 0;

idxlastFrame = max(truthRect(end,1), detectRect(end,1));

% Might be better just to index over one set or another...
for i = 1:idxlastFrame
    curTruth = truthRect(truthRect(:,1)==i,:);
    curDetect = detectRect(detectRect(:,1)==i,:);
    
    for j = 1:size(curDetect,1)
        tempNew = curDetect(j,:);
        
        found = false; 
        for k = 1:size(curTruth)
            tempTruth = curTruth(k,:);
            
            %TODO speed optimize the below... kindof slow as is
            
            
            placementError = (abs(tempNew(2)-tempTruth(2)) + abs(tempNew(3)-tempTruth(3))) / 2;
            sizeError = (abs(tempNew(4)-tempTruth(4)) + abs(tempNew(5)-tempTruth(5))) / 2;
            
            trueSize = tempTruth(4) + tempTruth(5) / 2;
            
            % Essentially, see if the size of x and y sizes are within threshold
            % of the known and that the location of x and y are within
            % thresholds based on their respective sizes
            if (placementError < trueSize*PLACEMENT_TOL && sizeError < trueSize*SIZE_TOL)
                nTrueDetections = nTrueDetections + 1;
                found = true;
                curTruth(k,:) = [0 0 0 0 0];
            end
        end
        
        if(~found)
            nFalsePositives = nFalsePositives + 1;
        end
    end
    
    for j = 1:size(curTruth,1)
        cur = curTruth(:,j);
        if (cur(1) ~= 0)
            nFalseNegatives = nFalseNegatives + 1;
        end
    end

end