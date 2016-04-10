function test_Detection( nFrames, rect, truth, target )
%TEST_DETECTION Summary of this function goes here
%   Detailed explanation goes here

opt_falsePositives = 0;
opt_falseNegatives = 0;
for i = 1:nFrames
    curTarget = target(i,:);
    curOpt = opt_truth(opt_truth(:,1)==i,:);    
    curScram = scramble_truth(scramble_truth(:,1)==i,:);    
    curRect = rect(rect(:,1)==i,:);
    
    % Get the number of false positives vs Opt
    
    for j = 1:size(curRect,1)
        tempRect = curRect(j,:);
        
        for k = 1:size(curOpt,1)
            tempTruth = curOpt(k,:);
            if (bboxoverlap(tempRect, tempTruth, 'min') >= 0.75)
            end
        end 
        for k = 1:size(curScram,1)
            tempTruth = curOpt(k,:);
        end
    end


    % Get the number of false negatives vs Opt


    % Get the number of false positives vs Scramble


    % Get the number of false negatives vs Scramble
    
end

% Get the number of false positives vs Opt


% Get the number of false negatives vs Opt


% Get the number of false positives vs Scramble


% Get the number of false negatives vs Scramble




end

