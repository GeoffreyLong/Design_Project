function kalmanTracking

    frame = []; %video frame
    detectedLocation = []; %detected object location
    trackedLocation = []; %location after kalman filtering
    utilities = []; %utilities used process video
    
    locationTrack = [];
    sizeTrack = [];
    % The procedure for tracking a single object is shown below.
    function trackSingleObject(param)
        
        % Create utilities used for reading video, detecting moving objects,
        % and displaying the results.
        utilities = createUtilities(param);
        
        % Get the number of frame in the video
        nFrames = utilities.videoReader.NumberOfFrames;
        
        % Get frame number of first detection
        rect = utilities.detections;
        firstDetection = rect(1);
        isTrackInitialized = false;
        rectIndx = 1;
        
        for i = firstDetection:nFrames
            
            
            utilities.currentFrame = read(utilities.videoReader,i);
    
            if i >= firstDetection
                try
                    % Detect the plane            
                    detection = [rect(rectIndx,2) rect(rectIndx,3) rect(rectIndx,4) rect(rectIndx,5)];
                    x = detection(1)+0.5*detection(3);
                    y = detection(2)+0.5*detection(4);

                    % detectedLocation is the midpoint of the detection
                    detectedLocation = [x y];
                catch
                    % If no detection captured in this frame
                    detectedLocation = [];
                    
                end
                
                rectIndx = rectIndx + 1;
            end
            
            if isempty(detectedLocation)
                isObjectDetected = false;
            else
                % To simplify the tracking process, only use the first detected object.
%                 detection = detectedLocation(1, :);
                isObjectDetected = true;
            end
            
            if ~isTrackInitialized
                if isObjectDetected
                    % Initialize a track by creating a Kalman filter when the target is
                    % detected for the first time.
                    initialLocation = [0 0];
                    kalmanFilter = configureKalmanFilter(param.motionModel, ...
                    initialLocation, param.initialEstimateError, ...
                    param.motionNoise, param.measurementNoise);

                    isTrackInitialized = true;
                    trackedLocation = correct(kalmanFilter, detectedLocation);
                else
                    trackedLocation = [];
                end

            else
                % Use the Kalman filter to track the target.
                if isObjectDetected % The target was detected.
                    % Reduce the measurement noise by calling predict followed by
                    % correct.
                    predict(kalmanFilter);
                    trackedLocation = correct(kalmanFilter, detectedLocation);
                else % The target was missing.
                    % Predict the target's location.
                    trackedLocation = predict(kalmanFilter);
                end
            end
            
            % Accumulate detection locations and tracked locations
            utilities.accumulatedDetections = [utilities.accumulatedDetections; detectedLocation];
            utilities.accumulatedTrackings = [utilities.accumulatedTrackings; trackedLocation];
            
            test1 = insertShape(utilities.currentFrame, 'Circle', [ detectedLocation, 3], 'LineWidth', 3, 'Color', 'red');
            test2 = insertShape(test1, 'Circle', [ trackedLocation, 3], 'LineWidth', 3, 'Color', 'green');
%          RGB = insertText(img,[200 1950; 800 1950; 1500 1950], {'Host Speed', 'Target Speed', 'Estimated Speed'}, 'FontSize',50);
            imshow(test2);
            
        end % while
        

    end


% Track Multiple Objects Using Kalman Filter

% Tracking multiple objects poses several additional challenges:

% * Multiple detections must be associated with the correct tracks
% * You must handle new objects appearing in a scene 
% * Object identity must be maintained when multiple objects merge into a
%   single detection
%
% The |vision.KalmanFilter| object together with the
% |assignDetectionsToTracks| function can help to solve the problems of


% * Assigning detections to tracks
% * Determining whether or not a detection corresponds to a new object, 
%   in other words, track creation
% * Just as in the case of an occluded single object, prediction can be
%   used to help separate objects that are close to each other
%
% To learn more about using Kalman filter to track multiple objects, see
% the example titled <matlab:showdemo('multiObjectTracking')
% Motion-Based Multiple Object Tracking>.

% Utility Functions Used in the Example
% Utility functions were used for detecting the objects and displaying the
% results. This section illustrates how the example implemented these
% functions.

% Get default parameters for creating Kalman filter and for segmenting the
% ball.
    
    
    function param = getDefaultParameters
        param.motionModel           = 'ConstantAcceleration';
        param.initialEstimateError  = 1E5 * ones(1, 3);
        param.motionNoise           = [25, 10, 1];
        param.measurementNoise      = 25;
        param.segmentationThreshold = 0.05;
    end

  

    % Create utilities for reading video, detecting moving objects, and
    % displaying the results.
    
    function utilities = createUtilities(param)
        % Create System objects for reading video, displaying video, extracting
        % foreground, and analyzing connected components.
        videoFile = '/Users/Xavier/Documents/workspace/Design_Project/Algorithm_Two/cam1_01.avi';
        detectionFile  = '/Users/Xavier/Documents/workspace/Design_Project/testData/Generated_Detections/July_6_cam1_01.avi.dat';
        utilities.currentFrame = 0;
        utilities.videoReader = VideoReader(videoFile);
        utilities.detections = csvread(detectionFile);
        utilities.accumulatedDetections = zeros(0, 2);
        utilities.accumulatedTrackings  = zeros(0, 2);
    end
    param = getDefaultParameters();  % get Kalman configuration that works well
                                 % for this example
                                 
    trackSingleObject(param);  % visualize the results
end