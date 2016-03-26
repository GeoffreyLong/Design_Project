classdef KalmanTracker<handle
    
    properties
        value;
        isTrackInitialized = false;
        kalmanFilter;

        
    end
     
    methods (Static)
        
        function obj = KalmanTracker(param)
             obj.kalmanFilter = configureKalmanFilter(param.motionModel, ...
                param.initialLocation, param.initialEstimateError, ...
                param.motionNoise, param.measurementNoise);
            
        end
        
    end
    methods
%         function obj = KalmanTracker(val)      
%             obj.value = val;     
%         end
        function r = add(this, val)
            this.value = this.value + val;
            r = this.value;
        end
             
        % The procedure for tracking a single object is shown below.
        function trackedLocation = track(this, detection)                         
            
            if isempty(detection)
                isObjectDetected = false;
            else
                % To simplify the tracking process, only use the first detected object.
                % detection = detectedLocation(1, :);
                isObjectDetected = true;

            end
            
            if ~this.isTrackInitialized
                if isObjectDetected
                    % Initialize a track by creating a Kalman filter when the target is
                    % detected for the first time.
                    initialLocation = [0 0];
                   
                    this.isTrackInitialized = true;
                    trackedLocation = correct(this.kalmanFilter, detection);
                else
                    trackedLocation = [];
                end

            else
                % Use the Kalman filter to track the target.
                kf = this.kalmanFilter;
                if isObjectDetected % The target was detected.
                    % Reduce the measurement noise by calling predict followed by
                    % correct.
                   
                    predict(kf);
                    trackedLocation = correct(kf, detection);
                else % The target was missing.
                    % Predict the target's location.
                    trackedLocation = predict(kf);
                end
            end
        end
        % end tracking method
        
    end
end
