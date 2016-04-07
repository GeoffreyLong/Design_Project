function test_DetectionVSRects( resultFile, nFrames, rect, truth )
%TEST_DETECTIONVSRECTSmary of this function goes here
%   Detailed explanation goes here

    truePositives = 0;
    trueNegatives = 0;
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
        % Calculate the true negative rate
        % This will be when there is no plane in the frame
        % and the algorithm detects no plane
        elseif size(curRect,1) == 0 && size(curTruth,1) == 0
            trueNegatives = trueNegatives + 1;
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

    % A few of the formulas and descriptions are from
    % https://himmelfarb.gwu.edu/tutorials/studydesign101/formulas.html
    % http://www.hpl.hp.com/techreports/2003/HPL-2003-4.pdf
    
    fileID = fopen(strcat(resultFile, 'vsRect.txt'), 'w');
    
    truePositives
    fprintf(fileID, 'True Positives: \t\t %d \n', truePositives);
    trueNegatives
    fprintf(fileID, 'True Negatives: \t\t %d \n', trueNegatives);
    falsePositives
    fprintf(fileID, 'False Positives: \t\t %d \n', falsePositives);
    falseNegatives
    fprintf(fileID, 'False Negatives: \t\t %d \n\n', falseNegatives);

    truePosRate = truePositives / (truePositives + falseNegatives)
    fprintf(fileID, 'True Positive Rate: \t\t %f \n', truePosRate);

    falsePosRate = falsePositives / (trueNegatives + falsePositives)
    fprintf(fileID, 'False Positive Rate: \t\t %f \n', falsePosRate);
    
    falseNegRate = falseNegatives / (truePositives + falseNegatives)
    fprintf(fileID, 'False Negative Rate: \t\t %f \n\n', falseNegRate);
    
    
    % Sensitivity = The number of positive test results for the presence of an outcome
    %               divided by the total presence of an outcome
    sensitivity = truePositives / (truePositives + falseNegatives)
    fprintf(fileID, 'Sensitivity: \t\t\t %f \n', sensitivity);

    % Specificity = Number of negative test results for the absence of an outcome 
    %               divided by the total absences of an outcome
    specificity = trueNegatives / (trueNegatives + falsePositives)
    fprintf(fileID, 'Specificity: \t\t\t %f \n\n', specificity);

    
    % Positive predictive value = The number of positive test results for the presence of an outcome
    %                             divided by the total number of positive test results
    posPredictVal = truePositives / (truePositives + falsePositives);
    fprintf(fileID, 'Pos Predictive Value (Precision): \t %f \n', posPredictVal);
    
    % Negative Predictive Value = The number of negative test results for the absence of an outcome 
    %                             divided by the total number of negative test results
    negPredictVal = trueNegatives / (trueNegatives + falseNegatives);
    fprintf(fileID, 'Neg Predictive Value: \t %f \n', negPredictVal);

    
    accuracy = (truePositives + trueNegatives) / (truePositives + falsePositives + trueNegatives + falseNegatives);
    fprintf(fileID, 'Accuracy: \t\t\t %f \n', accuracy);

    fscore = posPredictVal * truePosRate;
    fprintf(fileID, 'F-Score: \t\t\t %f \n\n', fscore);

    
    
    
    % Loosely, the number of erroneous detections 
    % (extra detections, false positives, etc)
    detectionToPlaneRatio = totalDetections / totalPlanes
    fprintf(fileID, 'Detection To Plane Ratio: \t %f \n', detectionToPlaneRatio);

    
    % The number of detections on each plane
    % Sometimes there may be several bounding boxes on a single plane
    % that grab wings, decals, etc
    detectionsPerPlane = truePositives / foundPlanes
    fprintf(fileID, 'Detections Per Plane: \t\t %f \n', detectionsPerPlane);
    
    % boundQuality: the quality of the bounding (how much the rects overlap)
    %   Make a histogram
    %   Fit a gaussian
    boundQuality = fitdist(bboxratios, 'Normal')
    boundValues = 0:0.01:1;
    points = pdf(boundQuality,boundValues);
    boundPlot = plot(boundValues,points,'LineWidth',2);
    title('Gaussian Fit of Bounding Box Overlap Ratio');
    fprintf(fileID, 'Detection Quality: \t\t Mu=%f, \n\t\t\t\t sigma=%f \n', boundQuality.mu, boundQuality.sigma);
    saveas(boundPlot, strcat(resultFile, 'vsRect_Quality.png'));
    
    fclose(fileID);
end
