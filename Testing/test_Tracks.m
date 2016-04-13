function test_Tracks( resultFileBase, nFrames, rect, truth )
%TEST_TRACKS Summary of this function goes here
%   [id frameNo bbox]

    % [id age posRate]
    tracks = [];

    nTracks = rect(end,1);
    for i = 1:nTracks
        curId = rect(rect(:,1)==i, :);
        if (isempty(curId))
            continue;
        end

        numValid = 0;
        for j = 1:size(curId,1)
            valid = 0;
            curRect = curId(j,:);
            curTruth = truth(truth(:,1)==curRect(2),2:5);
            for k = 1:size(curTruth,1)
                if (bboxOverlapRatio(curTruth, curRect(3:6), 'ratioType', 'min') >= 0.5)
                    valid = 1;
                end
            end
            if (valid)
                numValid = numValid + 1;
            end
        end
        
        tracks = [tracks; i size(curId,1) (numValid/size(curId,1))]
    end

    numTruth = 0;
    numFalse = 0;
    truthSize = 0;
    falseSize = 0;
    truthAvg = 0;
    falseAvg = 0;
    truthAge = 0;
    falseAge = 0;
    
    numTracks = size(tracks,1);
    for i = 1:numTracks
        curTrack = tracks(i, :);
        % If the track has more than 50% positives, then truth track
        if (curTrack(3) > 0.5)
            numTruth = numTruth + 1;
            truthSize = truthSize + 1;
            truthAvg = truthAvg + curTrack(3);
            truthAge = truthAge + curTrack(2);
        else
            numFalse = numFalse + 1;
            falseSize = falseSize + 1;
            falseAvg = falseAvg + curTrack(3);
            falseAge = falseAge + curTrack(2);
        end
    end

    fileID = fopen(strcat(resultFileBase, 'TrackMetrics.txt'), 'w');


    fprintf(fileID, 'Number of True Tracks: \t\t %d \n', numTruth);
    fprintf(fileID, 'Number of False Tracks: \t %d \n', numFalse);
    fprintf(fileID, 'Percent True Tracks: \t\t %0.1f \n', 100*numTruth/numTracks);
    fprintf(fileID, 'Avg Size of True Tracks: \t %0.3f \n', truthSize/numTruth);
    fprintf(fileID, 'Avg Size of False Tracks: \t %0.3f \n', falseSize/numFalse);
    fprintf(fileID, 'Percent Truth in True Tracks: \t %0.1f \n', 100*truthAvg/numTruth);
    fprintf(fileID, 'Percent Truth of False Tracks: \t %0.1f \n', 100*falseAvg/numFalse);
    fprintf(fileID, 'Avg Age of True Tracks: \t %0.3f \n', truthAge/numTruth);
    fprintf(fileID, 'Avg Age of False Tracks: \t %0.3f \n', falseAge/numFalse);
    fprintf(fileID, 'Avg Age of All Tracks: \t\t %0.3f \n', (truthAge+falseAge)/numTracks);

    %TODO could apppend the tracksobject to the file



    fclose(fileID);
end

