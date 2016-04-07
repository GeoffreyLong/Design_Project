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
    detectionFilter_file = strcat(testFileBase,'detectionFilter.dat');
    tracking_file = strcat(testFileBase,'tracking.dat');
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


    for i = 1:nFrames
        detections = [];
        timing = zeros(5);
        timing(1) = i;

        % Read in necessary data
        origImg = read(v, i);
        curHost = host(i,:);

        %%%%% DETECTION %%%%%
        % Start detection timing
        time_detect = tic;
        % Get detections
        detections = anon_detect(origImg, curHost, height, width);
        % End detection timing
        timing(2) = toc(time_detect);

        % Add the frame number to the detections
        detectionsWrite = [i*ones(size(detections,1),1),detections]
        % Write the detections
        dlmwrite(detection_file,detectionsWrite,'-append');



        %TODO add in tracking and TTC 
        %%%%% TRACKING %%%%%
        kalman.track(detections)


        %%%%% TTC %%%%%


        % Write timing file
        dlmwrite(timing_file,timing,'-append');
    end
end


%For each video
% 	Read in the SRT
% 	Read in the truth rects
% 	Declare a folder named <timestamp>
% 	Declare all relevant files
% 		description: holds the description of the data to differentiate
% 		detection_<video>
% 		detectionFilter_<video>
% 		tracking_<video>
% 		ttc_<video>
% 	Instantiate tracks
% 
% 	For each frame in video
% 		truth = Get the specific truth rect
% 		im = Get the image
% 		
% 		detection_time = tic;
% 		[detections] = detection(im);
% 		detection_time = toc;
% 		write all detection info to a file
% 			NAME: detection_<video>
% 			STRUCTURE: frameNo, detectionRectangle, probability (if have)
% 
% 
% 		detection_filter_time = tic;
% 		[detections] = detection_filter(im, detections);
% 		detectionFilter_time = toc;
% 		write all detection info to a file
% 			NAME: detection_filter_<video>
% 			STRUCTURE: frameNo, detectionRectangle, probability (if have)
% 
% 
% 		tracking_time = tic;
% 		tracks = tracking(im);
% 		tracking_time = toc;
% 		write all tracks info to a file
% 			NAME: tracking_<video>
% 			STRUCTURE: frameNo, trackNo, detectionRectangle
% 
% 
% 		ttc_time = tic;
% 		[detections] = ttc(im);
% 		ttc_time = toc;
% 		write all ttc info to a file
% 			NAME: ttc_<video>
% 			STRUCTURE: frameNo, detectionRectangle, probability (if have)
% 
% 
% 		write all timing stuff to file
% 			NAME: timing_<video>
% 			STRUCTURE: frameNo, detection
