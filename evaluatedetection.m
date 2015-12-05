function [  nTruePositives, nFalsePositives, nFalseNegatives ] = evaluatedetection( truthRect, detectRect, idx )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% The percent error in the placement and sizing of the rect
%TODO see if this is good for our purposes
%   Probably best to do visually, i.e. see how much the rects overlap
%   Depends on how tightly the planes are bounded
PLACEMENT_TOL = 0.30;
SIZE_TOL = 0.30;

% Seed the counters to 0
nTruePositives = 0;
nFalsePositives = 0;
nFalseNegatives = 0;

if isempty(truthRect)
    nFalsePositives = size(detectRect,1);
    return
end
if isempty(detectRect)
    nFalseNegatives = size(truthRect,1);
    return
end

idxStart = 1;
idxlastFrame = max(truthRect(end,1), detectRect(end,1));
% This is to ensure that only one frame is checked if we are only comparing one
if nargin == 3
    idxStart = idx;
    idxlastFrame = idx;
end

% Might be better just to index over one set or another...
for i = idxStart:idxlastFrame
    curTruth = truthRect(truthRect(:,1)==i,:);
    curDetect = detectRect(detectRect(:,1)==i,:);
    
    for j = 1:size(curDetect,1)
        tempNew = curDetect(j,:);
        
        found = false; 
        for k = 1:size(curTruth,1)
            tempTruth = curTruth(k,:);
            
            %TODO speed optimize the below... kindof slow as is
            
            tempNew
            tempTruth
            
            placementError = (abs(tempNew(2)-tempTruth(2)) + abs(tempNew(3)-tempTruth(3))) / 2;
            sizeError = (abs(tempNew(4)-tempTruth(4)) + abs(tempNew(5)-tempTruth(5))) / 2;
            
            trueSize = tempTruth(4) + tempTruth(5) / 2;
            
            % Essentially, see if the size of x and y sizes are within threshold
            % of the known and that the location of x and y are within
            % thresholds based on their respective sizes
            if (placementError < trueSize*PLACEMENT_TOL && sizeError < trueSize*SIZE_TOL)
                nTruePositives = nTruePositives + 1;
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