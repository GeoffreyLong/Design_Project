function [ output_args ] = testgenerator( videos, detect )
%TESTGENERATOR responsible for generating the testing data
    output_args = 10;
    for vidIdx = 1:numel(videos)
        % Select one of the videos for testing
        filePath = char(videos{vidIdx});

        try
            v = VideoReader(filePath);
        catch
            continue;
        end

        % Get the truth rects if they exist
        % If they don't then skip the video
        readRect = readrectxml(filePath, 'Previous/');
        if (~readRect)
            continue
        end

        nFrames = v.NumberOfFrames;
        height = v.Height;
        width = v.Width;

        % Read in the SRT data
        [host, target] = getdetailedsrt(filePath, nFrames);

        %TODO consider adding if statement to host w/ continue like for readrect

        for i = 1:nFrames
            detections = [];
            % Read in necessary data
            origImg = read(v, i);
            curHost = host(i,:);

            % Rotate the image
            rotatedImage = imrotate(origImg, -curHost(4), 'crop');
            detections = detect(rotatedImage, curHost, height, width)
            %TODO write detections to file
            
            
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

    output_args = 0;
end

