function test_Timing( resultFileBase, timing )
%TEST_TIMING Summary of this function goes here
%   Detailed explanation goes here

    overallTime = 0;
    overallDetectionTime = 0;
    overallTrackTime = 0;
    nFrames = size(timing,1);
    
    % The time it takes if no output
    overheadDetection = 0;
    % The time it takes if no output
    overheadTrackingOutput = 0;
    % The time it takes if no input
    overheadTrackingInput = 0;
    % The time it takes if no input or output
    overheadTracking = 0;
    
    countNoOut = 0;
    countNoDetectOut = 0;
    countNoTrackOut = 0;
    countInAndOut = 0;
    for i = 1:nFrames
        overallTime = overallTime + timing(i,2) + timing(i,4);
        overallDetectionTime = overallDetectionTime + timing(i,2);
        overallTrackTime = overallTrackTime + timing(i,4);
        
        % No detection output or tracking output
        if timing(i,3) == 0 && timing(i,5) == 0
            overheadDetection = overheadDetection + timing(i,2);
            overheadTracking = overheadTracking + timing(i,4);
            overheadTrackingInput = overheadTrackingInput + timing(i,4);            
            overheadTrackingOutput = overheadTrackingOutput + timing(i,4);
            countNoOut = countNoOut + 1;
        % No detection output, Tracking Output
        elseif timing(i,3) == 0
            overheadDetection = overheadDetection + timing(i,2);
            overheadTrackingInput = overheadTrackingInput + timing(i,4);
            countNoDetectOut = countNoDetectOut + 1;
        % Detection Output, No tracking output
        elseif timing(i,5) == 0
            overheadTrackingOutput = overheadTrackingOutput + timing(i,5);
            countNoTrackOut = countNoTrackOut + 1;
        else
            countInAndOut = countInAndOut + 1;
        end
    end
    
    
    overheadDetection = overheadDetection / (countNoOut + countNoDetectOut);
    overheadTrackingOutput = overheadTrackingOutput / (countNoOut + countNoTrackOut);
    overheadTrackingInput = overheadTrackingInput / (countNoOut + countNoDetectOut);
    overheadTracking = overheadTracking / countNoOut;
    
    detectionTimePerDetection = 0;
    trackTimePerDetection = 0;
    trackTimePerDetectionInput = 0;
    trackTimePerDetectionOutput = 0;
    nDetections = 0;
    nTracks = 0;
    for i = 1:nFrames
        if (timing(i,3))
            detectTimeTemp = timing(i,2) - overheadDetection;
            detectionTimePerDetection = detectionTimePerDetection + detectTimeTemp;
            nDetections = nDetections + timing(i,3);
        end
        if (timing(i,5))
            trackTimeTemp = timing(i,4) - overheadTracking;
            trackTimePerDetection = trackTimePerDetection + trackTimeTemp;

            trackTimeTemp = timing(i,4) - overheadTrackingInput;
            trackTimePerDetectionInput = trackTimePerDetectionInput + trackTimeTemp;

            trackTimeTemp = timing(i,4) - overheadTrackingOutput;
            trackTimePerDetectionOutput = trackTimePerDetectionOutput + trackTimeTemp;
            
            nTracks = nTracks + timing(i,5);
        end
    end
    
    detectionTimePerDetection = detectionTimePerDetection / nDetections;
    trackTimePerDetection = trackTimePerDetection / nTracks;
    trackTimePerDetectionInput = trackTimePerDetectionInput / nTracks;
    trackTimePerDetectionOutput = trackTimePerDetectionOutput / nTracks;
    
    
    
    fileID = fopen(strcat(resultFileBase, 'TimingMetrics.txt'), 'w');

    fprintf(fileID, 'Number of Frames: \t\t\t\t %d \n\n', nFrames);
    fprintf(fileID, 'Overall Time: \t\t\t\t\t %0.1f \n', overallTime);
    fprintf(fileID, 'Overall Detection Time: \t\t\t %0.1f \n', overallDetectionTime);
    fprintf(fileID, 'Overall Tracking Time: \t\t\t\t %0.1f \n\n', overallTrackTime);
    
    fprintf(fileID, 'Avg Time (per frame): \t\t\t\t %f \n', overallTime/nFrames);
    fprintf(fileID, 'Avg Time for Detection (per frame): \t\t %f \n', overallDetectionTime/nFrames);
    fprintf(fileID, 'Avg Time for Tracking (per frame): \t\t %f \n\n', overallTrackTime/nFrames);

    fprintf(fileID, 'Detection Overhead (per frame): \t\t %f \n', overheadDetection);
    fprintf(fileID, 'Tracking Overhead (per frame): \t\t\t %f \n', overheadTracking);
    %fprintf(fileID, 'Tracking Overhead No Input (per frame): \t %f \n', overheadTrackingInput);
    %fprintf(fileID, 'Tracking Overhead No Output (per frame): \t %f \n', overheadTrackingOutput);

    % Not too sure about the labelling here...
    fprintf(fileID, 'Time per Additional Detection: \t\t\t %f \n\n\n', detectionTimePerDetection);
    %fprintf(fileID, 'Time per Additional Track Detection: \t\t %f \n\n\n', trackTimePerDetection);
    %fprintf(fileID, 'Time per Additional Track Output: \t\t %f \n', trackTimePerDetectionInput);
    %fprintf(fileID, 'Time per Additional Track Input: \t\t %f \n\n\n', trackTimePerDetectionOutput);

    % Not really timing, but already have information
    % countNoOut = number of times there is nothing in and nothing out
    % countNoDetectOut = number of times there are tracks when no detections
    % countNoTrackOut = number of times there are detections but no tracks
    fprintf(fileID, 'Probability of Tracking Output when Input: \t %f \n', countInAndOut/(countNoTrackOut+countInAndOut));
    fprintf(fileID, 'Probability of Tracking Output w/o Input: \t %f \n', countNoDetectOut/(countNoDetectOut+countNoOut));
    fprintf(fileID, 'Probability of Tracking Input w/o Output: \t %f \n', countNoTrackOut/(countNoTrackOut+countInAndOut));
    fprintf(fileID, 'Probability of No Tracking Output w/o Input: \t %f \n', countNoOut/(countNoDetectOut+countNoOut));

    fclose(fileID);
end

