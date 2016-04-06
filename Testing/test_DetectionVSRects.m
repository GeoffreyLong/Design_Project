function [ output_args ] = test_DetectionVSRects( nFrames, rect, truth )
%TEST_DETECTIONVSRECTS Summary of this function goes here
%   Detailed explanation goes here

    truePositives = 0;
    falsePositives = 0;
    falseNegatives = 0;
    totalPlanes = 0;
    foundPlanes = 0;
    totalDetections = 0;
    bboxratios = [];
    for i = 1:nFrames
        curTruth = truth(truth(:,1)==i,:);    
        curRect = rect(rect(:,1)==i,:); 

        % If there were no planes found by the algorithm
        % But there were planes in the image
        if size(curRect,1) == 0 && size(curTruth,1) ~= 0
            falseNegatives = falseNegatives + size(curTruth,1);
        % If there were no planes in the image
        % But there were planes found by the algorithm
        %TODO what about the case where plane not found during test gen?
        elseif size(curRect,1) ~= 0 && size(curTruth,1) == 0
            falsePositives = falsePositives + size(curRect,1);
        % Either neither found a plane or both found planes
        else
            % Used to keep track of truePositives for trueNegative logging
            truthCounts = zeros(size(curTruth,1));

            % Iterate over the detections found for the frame
            for j = 1:size(curRect,1)
                tempRect = curRect(j,:);

                % plane checks to see if a plane existed
                % foundPlane checks to see if a plane was found
                plane = 0;
                foundPlane = 0;

                % Iterate over the actual detections in the frame
                for k = 1:size(curTruth,1)
                    plane = 1;
                    tempTruth = curTruth(k,:);

                    % If the ratio of the minimum is 1, 
                    % then one rect is completely within another rect.
                    % This is a valid detection
                    %TODO consider adding || if bbox >= 0.5 or something
                    if (bboxOverlapRatio(tempRect(2:5), tempTruth(2:5), 'ratioType', 'min') == 1)
                        % Store the true overlap ratio to be analyzed later
                        bboxratios = [bboxratios; bboxOverlapRatio(tempRect(2:5), tempTruth(2:5))];
                        foundPlane = 1;
                        truthCounts(k) = 1;
                    end
                end 
                
                % If there was a plane found for the rect, then true pos
                if (plane == 1 && foundPlane == 1)
                    truePositives = truePositives + 1;
                % If there was a plane, but nothing found, then false pos
                elseif (plane == 1 && foundPlane == 0)
                    falsePositives = falsePositives + 1;
                end
            end
            
            % If not all the planes were discovered, then false neg
            for j = 1:numel(truthCounts)
                if truthCounts(j) == 0
                    falseNegatives = falseNegatives + 1;
                else
                    foundPlanes = foundPlanes + 1;
                end
            end
                
            % Add to the counts of totalPlanes and totalDetections
            totalPlanes = totalPlanes + size(curTruth,1);
            totalDetections = totalDetections + size(curRect,1);
        end
    end

    % Loosely, the number of erroneous detections 
    % (extra detections, false positives, etc)
    detectionToPlaneRatio = totalDetections / totalPlanes
    
    % The number of detections on each plane
    % Sometimes there may be several bounding boxes on a single plane
    % that grab wings, decals, etc
    detectionsPerPlane = truePositives / foundPlanes
    
    % boundQuality: the quality of the bounding (how much the rects overlap)
    %   Make a histogram
    %   Fit a gaussian
    %   Both of these can be found in static plane location model
end

