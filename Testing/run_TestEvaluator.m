%TODO figure out how to handle scramble vs optimized rectangles

% This script runs the tests for a given testing instance or instances
% Want to pass a folder to the test evaluator function
%folderNames = {'strel-disk7 thresh-0.08', 'strel-disk7 thresh-0.10', 'strel-disk7 thresh-0.12'};
%folderNames = {'July 6 cam1 01 Test #1', 'July 8 cam1 02 Test #1', 'July 8 cam1 03 Test #1'};
%folderNames = {'Expanded Crop (1.33)'};
folderNames = {'Pre-Track #1', 'Post-Track #1'};

if isempty(folderNames)
    baseDir = dir('../Testing/Test_Instances/');
    isub = [baseDir(:).isdir];
    folderNames = {baseDir(isub).name}';
    folderNames(ismember(folderNames,{'.','..'})) = [];
end
    
total_tracks = struct('folderName', {}, 'totalTracks', {});

% TODO add a loop over all folders
for folderIdx = 1:numel(folderNames)
    folderName = folderNames{folderIdx}
    
    % Set the detection file to test against
    %truthy_file = 'scrambled_';
    truthy_file = 'optimized_';


    % Set the name of the specific directory and get the directories from it
    testFileBase = strcat('../Testing/Test_Instances/',folderName,'/')
    d = dir(testFileBase);
    isub = [d(:).isdir];
    videoDirectories = {d(isub).name}';
    videoDirectories(ismember(videoDirectories,{'.','..'})) = [];
    
    tempTracks = [];

    % Loop over the video directories in the super directory
    for i=1:numel(videoDirectories)
        detections = [];
        timing = [];

        video = videoDirectories{i}

        newFileBase = strcat(testFileBase, video, '/')

        truths = readrectxml(strcat(video,'.avi'),truthy_file);

        % Might be a bad idea to require reading in the video
        % Might be better just to store this information somewhere
        videoFile = strcat('../Test_Data/', video, '.avi');
        v = VideoReader(videoFile);
        nFrames = v.NumberOfFrames;
        height = v.Height;
        width = v.Width;

        [host, target] = getdetailedsrt(videoFile, nFrames);

        files = dir(newFileBase);
        for j=1:numel(files)
            fileName = files(j).name

            % Read in the data corresponding to the file
            if strcmp(fileName,'detection.dat')
                detections = csvread(strcat(newFileBase,fileName));
            elseif strcmp(fileName,'tracking_detections.dat')
                trackDetections = csvread(strcat(newFileBase,fileName));
            elseif strcmp(fileName,'tracking_detections.dat')
                trackTracks = csvread(strcat(newFileBase,fileName));
            elseif strcmp(fileName,'ttc.dat')

            elseif strcmp(fileName,'timing.dat')
                timing = csvread(strcat(newFileBase,fileName));
            end     
        end

        % Make a results folder
        mkdir(strcat('../Testing/Test_Instances/', folderName, '/', video, '/'), 'Results');
        resultFileBase = strcat('../Testing/Test_Instances/', folderName, '/', video, '/', '/Results/');

        % These next if statements test the detection results against the
        % chosen truth file
        try
            if (~isempty(detections) && ~isempty(truths))
                test_DetectionVSRects(resultFileBase, nFrames, detections, truths);
            end
        catch
        end
        try
            if (~isempty(trackDetections) && ~isempty(truths))
                test_DetectionVSRects(strcat(resultFileBase,'track_'), nFrames, trackDetections, truths);
            end
        catch 
        end

        % This will gather metrics such as 
        %   first sightings
        %       estimated time to collision of first sighting
        %       distance of first sighting
        %   timing metrics
        try
            if (~isempty(detections) && ~isempty(truths) && ~isempty(target))
                test_DetectionMetrics(resultFileBase, nFrames, detections, truths, target);
            end
        catch
        end  
        try
            if (~isempty(trackDetections) && ~isempty(truths) && ~isempty(target))
                test_DetectionMetrics(strcat(resultFileBase,'track_'), nFrames, trackDetections, truths, target);
            end
        catch
        end
        try
            if (~isempty(trackDetections) && ~isempty(truths))
                totalTrackTemp = test_TrackCounts(resultFileBase, nFrames, trackDetections, truths);
                tempTracks = [tempTracks; totalTrackTemp];
            end
        catch
        end
        try
            if (~isempty(trackTracks) && ~isempty(truths))
                totalTrackTemp = test_Tracks(resultFileBase, nFrames, trackTracks, truths);
            end
        catch
        end
    end
 
    try
        tempTracks = sortrows(tempTracks);
        endIdx = tempTracks(end,1);
        newTrackObj = zeros(endIdx, 2);
        for j = 1:endIdx
            tempSum = sum(tempTracks(tempTracks(:,1)==j,2));
            newTrackObj(j,1) = j;
            newTrackObj(j,2) = tempSum;
        end
        total_tracks(end+1) = struct('folderName', folderName, 'totalTracks', newTrackObj);
    catch 
    end
end

hold off
for i = 1:numel(total_tracks)
    curTrack = total_tracks(i);
    plot(curTrack.totalTracks(:,1), curTrack.totalTracks(:,2), 'LineWidth', 2)
    hold on
end
title('Total Tracks vs Different Thresholds');
legend(total_tracks.folderName);
xlabel('Frame Number');
ylabel('Number of Tracks')
saveas(gcf, 'PlotTracks.png')
hold off