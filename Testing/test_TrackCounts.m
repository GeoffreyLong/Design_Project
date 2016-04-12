function numberOfTracks = test_TrackCounts( resultFileBase, nFrames, rect, truth )
%TEST_TRACKCOUNTS 
%   Plot the true positive and false positive counts for a given track
%   Return a matrix of the total tracks per frame

    % Will be form [frameNumber #tracks]
    numberOfTracks = [];

    % Will be [#tracks]
    % frame number doesn't have to be in, can be added at plot time
    numberOfFalseTracks = [];
    numberOfTrueTracks = [];
    truthTrack = [];
    for i = 1:nFrames
        curRect = rect(rect(:,1)==i, 2:5);
        curTruth = truth(truth(:,1)==i, 2:5);

        truths = 0;
        falses = 0;

        for j = 1:size(curRect,1)
            plane = 0;
            for k = 1:size(curTruth,1)
                if (bboxOverlapRatio(curRect(j,:), curTruth(k,:), 'ratioType', 'min') >= 0.5)
                    plane = 1;
                end            
            end

            if (plane)
                truths = truths + 1;
            else
                falses = falses + 1;
            end
        end
        
        truthTrack = [truthTrack; size(curTruth,1)];
        numberOfTracks = [numberOfTracks; i size(curRect,1)];
        numberOfFalseTracks = [numberOfFalseTracks; falses];
        numberOfTrueTracks = [numberOfTrueTracks; truths];    
    end

    falseTrackPlot = plot(1:nFrames, truthTrack, 1:nFrames, numberOfTrueTracks, 1:nFrames, numberOfFalseTracks, 'LineWidth', 2)
    legend({'Truth Track', 'True Positive Tracks', 'False Tracks'})
    title('Number of Tracks Through Video')
    ylabel('Number of Tracks')
    xlabel('Frame Number')
    try
        saveas(falseTrackPlot, strcat(resultFileBase, 'FalseTrackPlot.png'));
    catch
        saveas(gcf, strcat(resultFileBase, 'FalseTrackPlot.png'));
    end
end

