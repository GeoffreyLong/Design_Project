function kalmanTracking

    frame = []; %video frame
    detectedLocation = []; %detected object location
    trackedLocation = []; %location after kalman filtering
    label = '';
    utilities = []; %utilities used process video
    
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
        
        for i = 1:nFrames
            
            
            frame = read(utilities.videoReader,i);
   
            if i >= firstDetection
                try
                    % Detect the plane            
                    detection = [rect(rectIndx,2) rect(rectIndx,3) rect(rectIndx,4) rect(rectIndx,5)];
                    x = detection(1)+0.5*detection(3);
                    y = detection(2)+0.5*detection(4);

                    % detectedLocation is the midpoint of the detection
                    detectedLocation = [x y];
                    isObjectDetected = true;
                    % Incremement rectIndx
                   
                catch
                    % If no detection captured in this frame
                    detectedLocation = [];
                    isObjectDetected = false;
                    
                end
                
                rectIndx = rectIndx + 1;
            end
            
            if ~isTrackInitialized
                if isObjectDetected
                    % Initialize a track by creating a Kalman filter when the ball is
                    % detected for the first time.
                    initialLocation = computeInitialLocation(param, detectedLocation);
                    kalmanFilter = configureKalmanFilter(param.motionModel, ...
                    initialLocation, param.initialEstimateError, ...
                    param.motionNoise, param.measurementNoise);

                    isTrackInitialized = true;
                    trackedLocation = correct(kalmanFilter, detectedLocation);
                    label = 'Initial';
                else
                    trackedLocation = [];
                    label = '';
                end

            else
                % Use the Kalman filter to track the ball.
                if isObjectDetected % The ball was detected.
                    % Reduce the measurement noise by calling predict followed by
                    % correct.
                    predict(kalmanFilter);
                    trackedLocation = correct(kalmanFilter, detectedLocation);
                    label = 'Corrected';
                else % The ball was missing.
                    % Predict the ball's location.
                    trackedLocation = predict(kalmanFilter);
                    label = 'Predicted';
                end
            end

            annotateTrackedObject();
        end % while

          showTrajectory();
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
        param.initialLocation       = 'Same as first detection';
        param.initialEstimateError  = 1E5 * ones(1, 3);
        param.motionNoise           = [25, 10, 1];
        param.measurementNoise      = 25;
        param.segmentationThreshold = 0.05;
    end


   

    % Show the current detection and tracking results.
    function annotateTrackedObject()
        accumulateResults();
        % Combine the foreground mask with the current video frame in order to
        % show the detection result.
        combinedImage = max(repmat(utilities.foregroundMask, [1,1,3]), frame);

        if ~isempty(trackedLocation)
            shape = 'circle';
            region = trackedLocation;
            region(:, 3) = 5;
            combinedImage = insertObjectAnnotation(combinedImage, shape, region, {label}, 'Color', 'red');
        end
        step(utilities.videoPlayer, combinedImage);
    end

    % Accumulate video frames, detected locations, and tracked locations to
    % show the trajectory of the ball.
    function accumulateResults()
        utilities.accumulatedImage      = max(utilities.accumulatedImage, frame);
        utilities.accumulatedDetections = [utilities.accumulatedDetections; detectedLocation];
        utilities.accumulatedTrackings  = [utilities.accumulatedTrackings; trackedLocation];
    end

    % Create utilities for reading video, detecting moving objects, and
    % displaying the results.
    
    function utilities = createUtilities(param)
        % Create System objects for reading video, displaying video, extracting
        % foreground, and analyzing connected components.
        videoFile = '/Users/Xavier/Documents/workspace/Design_Project/Algorithm_Two/cam1_01.avi';
        detectionFile  = '/Users/Xavier/Documents/workspace/Design_Project/testData/Generated_Detections/July_6_cam1_01.avi.dat';
        utilities.videoReader = VideoReader(videoFile);
        utilities.detections = csvread(detectionFile);
        utilities.accumulatedImage      = 0;
        utilities.accumulatedDetections = zeros(0, 2);
        utilities.accumulatedTrackings  = zeros(0, 2);
    end
    
end