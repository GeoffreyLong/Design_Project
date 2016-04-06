function [ output_args ] = test_DetectionVSRects( nFrames, rect, truth )
%TEST_DETECTIONVSRECTS Summary of this function goes here
%   Detailed explanation goes here

    opt_falsePositives = 0;
    opt_falseNegatives = 0;
    for i = 1:nFrames
        curTruth = truth(truth(:,1)==i,:);    
        curRect = rect(rect(:,1)==i,:);

        % Get the number of false positives vs Opt

        for j = 1:size(curRect,1)
            tempRect = curRect(j,:);

            for k = 1:size(curTruth,1)
                tempTruth = curTruth(k,:);
                
                % 
                if (bboxOverlapRatio(tempRect(2:5), tempTruth(2:5), 'ratioType', 'min') == 1)
                    bboxOverlapRatio(tempRect(2:5), tempTruth(2:5), 'ratioType', 'min')

                end
            end 
        end



    end

end

