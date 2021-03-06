function testgenerator( filePath, anon_detect, testFileBase )
%TESTGENERATOR responsible for generating the testing data
% should consider having this output a 1 on success and 0 on failure


    % Check to see if the video actually exists
    try
        v = VideoReader(filePath);
    catch
        outputString = strcat('filePath: "', filePath, '" Not found');
        display(outputString);
        return;
    end

    % Get the video information
    nFrames = v.NumberOfFrames;
    height = v.Height;
    width = v.Width;

    %TODO consider adding if statement to host w/ continue like for readrect
    % Read in the SRT data
    [host, target] = getdetailedsrt(filePath, nFrames);


    % Create the files
    detection_file = strcat(testFileBase,'detection.dat');
    detectionFilter_file = strcat(testFileBase,'detection_filter.dat');
    
    %TODO decide if we want these separate or together
    %   Could just iterate over in the tracks file to get the same info
    %   about the detections
    trackingDetection_file = strcat(testFileBase,'tracking_detections.dat');
    trackingTracks_file = strcat(testFileBase,'tracking_tracks.dat');
    ttc_file = strcat(testFileBase,'ttc.dat');

    % Timing in the form nFrames x 5 matrix
    %   frameNumber, 
    %   detection time,
    %   detection filter time,
    %   tracking time,
    %   ttc calc time
    % Full system time can be calculated from adding up the others
    %   Don't want to combine that in since there is filewriting time

    timing_file = strcat(testFileBase, 'timing.dat');

    

    kalman = KalmanTracker;
    trackingTracks = [];

    for i = 1:nFrames
        i
        detections = [];
        trackDetections = [];
        timingVector = [];
        timingVector = [timingVector i];

        % Read in necessary data
        origImg = read(v, i);
        curHost = host(i,:);

        %%%%% DETECTION %%%%%
        % Start detection timing
        time_detect = tic;
        % Get detections
        detections = anon_detect(origImg, curHost, height, width);
        % End detection timing
        timingVector = [timingVector toc(time_detect)];
        timingVector = [timingVector size(detections,1)];
        % Add the frame number to the detections
        detectionsWrite = [i*ones(size(detections,1),1),detections];
        % Write the detections
        dlmwrite(detection_file,detectionsWrite,'-append');



        %TODO add in tracking and TTC 
        %%%%% TRACKING %%%%%
        % Start tracking timing
        time_track = tic;
        % Get tracks
        tracks = kalman.track(i,detections);
        % End tracking timing
        timingVector = [timingVector toc(time_track)];
        
        for j = 1:numel(tracks)
            trackDetections = [trackDetections; tracks(j).bbox];
            trackDetections = unique(trackDetections, 'rows');
        end
        % This form is necessary to save the tracks to a file
        % Structures don't lend themselves well to reading and writing
        % So far as I can tell
        for j = 1:numel(tracks)
            trackingTracks = [trackingTracks; tracks(j).id i tracks(j).bbox];
        end
        
        timingVector = [timingVector size(trackDetections,1)];
        % Add the frame number to the detections
        trackDetectionsWrite = [i*ones(size(trackDetections,1),1),trackDetections];
        % Write the detections from tracking to file
        dlmwrite(trackingDetection_file,trackDetectionsWrite,'-append');
        
        
        
        %%%%% TTC %%%%%
        % Not completed for testing


        % Write timing file
        % timingVector = [frameNo detectionTime #detections trackingTime #tracks]
        dlmwrite(timing_file,timingVector,'-append');
        
        s1 = sprintf('Number of initial detections: \t %d', size(detections,1));
        s2 = sprintf('Number of final detections: \t %d \n', size(tracks,1));
        disp(s1);
        disp(s2);
    end
    
    trackingTracks = sortrows(trackingTracks);
    % Sometimes there are duplicates
    trackingTracks = unique(trackingTracks, 'rows');
    csvwrite(trackingTracks_file, trackingTracks);
end
