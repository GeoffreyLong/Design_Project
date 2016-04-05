function testgenerator( videos, anon_detect, testFileBase )
%TESTGENERATOR responsible for generating the testing data
% should consider having this output a 1 on success and 0 on failure


    % Create the formatspecs??

    
    % Iterate through the cell of videos
    for vidIdx = 1:numel(videos)
        % Select one of the videos for testing
        filePath = char(videos{vidIdx});

        % Check to see if the video actually exists
        try
            v = VideoReader(filePath);
        catch
            outputString = strcat('filePath: "', filePath, '" Not found');
            display(outputString);
            continue;
        end

        
        % Get the truth rects if they exist
        % If they don't then skip the video
        readRect = readrectxml(filePath, 'Previous/');
        if (~readRect)
            continue
        end

        % Get the video information
        nFrames = v.NumberOfFrames;
        height = v.Height;
        width = v.Width;

        %TODO consider adding if statement to host w/ continue like for readrect
        % Read in the SRT data
        [host, target] = getdetailedsrt(filePath, nFrames);
        
        
        % If all the requisite information is in the system, 
        % then we can proceed with testing.
        % Get the video name
        filePathTokens = strread(filePath,'%s','delimiter','/');
        fileName = filePathTokens(length(filePathTokens));
        vidName = char(fileName);
        
        % Create the files
        detection_file = strcat(testFileBase,'detection_',vidName,'.dat');
        detectionFilter_file = strcat(testFileBase,'detectionFilter_',vidName,'.dat');
        tracking_file = strcat(testFileBase,'tracking_',vidName);
        ttc_file = strcat(testFileBase,'ttc_',vidName);
        
        
        for i = 1:nFrames
            detections = [];
            % Read in necessary data
            origImg = read(v, i);
            curHost = host(i,:);

            % Rotate the image
            rotatedImage = imrotate(origImg, -curHost(4), 'crop');
            
            % Get detections
            detections = anon_detect(rotatedImage, curHost, height, width);
            % Add the frame number to the detections
            detectionsWrite = [i*ones(size(detections,1),1),detections]
            % Write the detections
            dlmwrite(detection_file,detectionsWrite,'-append');
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
end
