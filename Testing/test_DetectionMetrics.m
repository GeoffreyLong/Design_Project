function test_DetectionMetrics( resultFileBase, nFrames, rect, truth, target, timing )
%TEST_DETECTIONMETRICS Summary of this function goes here
%   


    
    % Where a plane first appears in the generated files
    firstTruthDetection = [];
    % Where a plane first appears in the detections
    firstRectDetection = [];
    % Where the first unbroken string of 4+ detections occurs
    %   Note: the number 4+ rather arbitrarily chosen
    firstDetectionString = [];
    continuityCount = 0;
    stringThreshold = 4;
    
    for i = 1:nFrames
        curTruth = truth(truth(:,1)==i,:);
        curRect = rect(rect(:,1)==i,:);
        
        if (size(curTruth,1) ~= 0 && isempty(firstTruthDetection))
            firstTruthDetection = curTruth(1,:);
        end

        % Iterate over the detections found for the frame
        for j = 1:size(curRect,1)
            tempRect = curRect(j,:);

            % foundPlane checks to see if a plane was found
            foundPlane = 0;

            % Iterate over the actual detections in the frame
            for k = 1:size(curTruth,1)
                tempTruth = curTruth(k,:);

                % If the ratio of the minimum is 1, 
                % then one rect is completely within another rect.
                % This is a valid detection
                if (bboxOverlapRatio(tempRect(2:5), tempTruth(2:5), 'ratioType', 'min') == 1)
                    foundPlane = 1;
                    if (isempty(firstRectDetection))
                        firstRectDetection = tempRect;
                    end
                end
            end 

            % If there was a plane found for the rect, then true pos
            if (foundPlane == 1)
                continuityCount = continuityCount + 1;
                if continuityCount >= stringThreshold ...
                        && isempty(firstDetectionString)
                    firstDetectionString = tempRect;
                end
            else
                continuityCount = 0;
            end
        end
    end

    
    firstDetectionString(1) = firstDetectionString(1) - stringThreshold;
    firstTruthDetection
    firstRectDetection
    firstDetectionString

    
    fileID = fopen(strcat(resultFileBase, 'DetectionMetrics.txt'), 'w');

    fprintf(fileID, 'Number of frames between \n');
    fprintf(fileID, '\t First truth detection and detection: \t\t %d \n', (firstRectDetection(1) - firstTruthDetection(1)));
    fprintf(fileID, '\t First truth detection and 4+ detection string: %d \n', (firstDetectionString(1) - firstTruthDetection(1)));
    fprintf(fileID, '\t First detection and 4+ detection string: \t %d \n\n', (firstDetectionString(1) - firstRectDetection(1)));

    fprintf(fileID, 'Distance of plane at \n');
    fprintf(fileID, '\t First truth detection: \t\t\t %d (ft) \n', target(firstTruthDetection(1)));
    fprintf(fileID, '\t First detection: \t\t\t\t %d (ft) \n', target(firstRectDetection(1)));
    fprintf(fileID, '\t First 4+ detection string: \t\t\t %d (ft) \n', target(firstDetectionString(1)));
        
    fclose(fileID);
end

