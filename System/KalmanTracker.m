classdef KalmanTracker<handle
    
    properties
        value;
        isTrackInitialized = false;
        kalmanFilter;
    
        %for multi 
        tracks;
        nextId;
        centroids;
        bboxes;
        mask = [];
        assignments;
        unassignedTracks;
        unassignedDetections;
        
        oldTracks;
    end
     
    methods (Static)
        
       
        
        % The |initializeTracks| function creates an array of tracks, where each
        % track is a structure representing a moving object in the video. The
        % purpose of the structure is to maintain the state of a tracked object.
        % The state consists of information used for detection to track assignment,
        % track termination, and display. 
        
         function obj = KalmanTracker()
            %create kalman filter tracker         
            obj.tracks = struct(...
                'id', {}, ...
                'bbox', {}, ...
                'track', {}, ...
                'kalmanFilter', {}, ...
                'age', {}, ...
                'totalVisibleCount', {}, ...
                'consecutiveInvisibleCount', {}, ...
                'deathFrame', {});
            
            obj.nextId = 1; % ID of the next track
           
         end
         % This method splits the detections into centroids and bboxes
        function [centroids, bboxes] = formatInputs(detections)
            if ~isempty(detections)
                centroids = detections(:,1:2);
                bboxes = detections; 
            else
                centroids = [];
                bboxes = [];
            end
        end
    end
    methods
        % Predict New Locations of Existing Tracks
        % Use the Kalman filter to predict the centroid of each track in the
        % current frame, and update its bounding box accordingly.

        function predictNewLocationsOfTracks(obj)
            for i = 1:length(obj.tracks)
            
                bbox = obj.tracks(i).bbox;

                % Predict the current location of the track.
                predictedCentroid = predict(obj.tracks(i).kalmanFilter);
                
                % Shift the bounding box so that its center is at 
                % the predicted location.
                predictedCentroid = predictedCentroid - bbox(3:4) / 2;
                obj.tracks(i).bbox = [predictedCentroid, bbox(3:4)];
            end
        end
        
        % Assign Detections to Tracks
        % Assigning object detections in the current frame to existing tracks is
        % done by minimizing cost. The cost is defined as the negative
        % log-likelihood of a detection corresponding to a track.  
        function [assignments, unassignedTracks, unassignedDetections] = ...
            detectionToTrackAssignment(this)
            nTracks = length(this.tracks);
            nDetections = size(this.centroids, 1);

            % Compute the cost of assigning each detection to each track.
            cost = zeros(nTracks, nDetections);
            for i = 1:nTracks
                cost(i, :) = distance(this.tracks(i).kalmanFilter, this.centroids);
            end
        
            % Solve the assignment problem.
            costOfNonAssignment = 20;
            [assignments, unassignedTracks, unassignedDetections] = ...
            assignDetectionsToTracks(cost, costOfNonAssignment);
        end
        
        % Update Assigned Tracks
        % The |updateAssignedTracks| function updates each assigned track with the
        % corresponding detection. It calls the |correct| method of
        % |vision.KalmanFilter| to correct the location estimate. Next, it stores
        % the new bounding box, and increases the age of the track and the total
        % visible count by 1. Finally, the function sets the invisible count to 0. 

        function updateAssignedTracks(this, frameNum)
            numAssignedTracks = size(this.assignments, 1);
            for i = 1:numAssignedTracks
                trackIdx = this.assignments(i, 1);
                detectionIdx = this.assignments(i, 2);
                centroid = this.centroids(detectionIdx, :);
                bbox = [frameNum this.bboxes(detectionIdx, :)];

                % Correct the estimate of the object's location
                % using the new detection.
                correct(this.tracks(trackIdx).kalmanFilter, centroid);

                % Replace predicted bounding box with detected
                % bounding box.
                this.tracks(trackIdx).bbox = bbox;
                this.tracks(trackIdx).track = [this.tracks(trackIdx).track; bbox];

                % Update track's age.
                this.tracks(trackIdx).age = this.tracks(trackIdx).age + 1;
                this.tracks(trackIdx).deathFrame = frameNum;
                % Update visibility.
                this.tracks(trackIdx).totalVisibleCount = ...
                    this.tracks(trackIdx).totalVisibleCount + 1;
                this.tracks(trackIdx).consecutiveInvisibleCount = 0;
            end
        end
        
        % Update Unassigned Tracks
        % Mark each unassigned track as invisible, and increase its age by 1.

        function updateUnassignedTracks(this, frameNum)
            for i = 1:length(this.unassignedTracks)
                ind = this.unassignedTracks(i);
                this.tracks(ind).age = this.tracks(ind).age + 1;
                this.tracks(ind).deathFrame = frameNum;
                this.tracks(ind).consecutiveInvisibleCount = ...
                    this.tracks(ind).consecutiveInvisibleCount + 1;
            end
        end
        
        % Delete Lost Tracks
        % The |deleteLostTracks| function deletes tracks that have been invisible
        % for too many consecutive frames. It also deletes recently created tracks
        % that have been invisible for too many frames overall. 

        function deleteLostTracks(this)
            if isempty(this.tracks)
                return;
            end

            invisibleForTooLong = 20;
            ageThreshold = 8;

            % Compute the fraction of the track's age for which it was visible.
            ages = [this.tracks(:).age];
            totalVisibleCounts = [this.tracks(:).totalVisibleCount];
            visibility = totalVisibleCounts ./ ages;

            % Find the indices of 'lost' tracks.
            lostInds = (ages < ageThreshold & visibility < 0.6) | ...
                [this.tracks(:).consecutiveInvisibleCount] >= invisibleForTooLong;

            % Delete lost tracks.
            this.oldTracks = [this.oldTracks; this.tracks(lostInds)];
            this.tracks = this.tracks(~lostInds);
            
        end
    
        % Create New Tracks
        % Create new tracks from unassigned detections. Assume that any unassigned
        % detection is a start of a new track. In practice, you can use other cues
        % to eliminate noisy detections, such as size, location, or appearance.

        function createNewTracks(this, frameNum)
            this.centroids = this.centroids(this.unassignedDetections, :);
            this.bboxes = this.bboxes(this.unassignedDetections, :);

            for i = 1:size(this.centroids, 1)

                centroid = this.centroids(i,:);
                bbox = [frameNum this.bboxes(i, :)];

                % Create a Kalman filter object.
                kalmanFilter = configureKalmanFilter('ConstantVelocity', ...
                    centroid, [200, 50], [100, 25], 100);

                % Create a new track.
                newTrack = struct(...
                    'id', this.nextId, ...
                    'bbox', bbox, ...
                    'track', bbox, ...
                    'kalmanFilter', kalmanFilter, ...
                    'age', 1, ...
                    'totalVisibleCount', 1, ...
                    'consecutiveInvisibleCount', 0,...
                    'deathFrame', -1);

                % Add it to the array of tracks.
                this.tracks(end + 1) = newTrack;

                % Increment the next id.
                this.nextId = this.nextId + 1;
            end
        end
        
        function r = getTracks(this)

            minVisibleCount = 8;
            if ~isempty(this.tracks)

                % Noisy detections tend to result in short-lived tracks.
                % Only display tracks that have been visible for more than 
                % a minimum number of frames.
                reliableTrackInds = ...
                    [this.tracks(:).totalVisibleCount] > minVisibleCount;
                reliableTracks = this.tracks(reliableTrackInds);

                % Display the objects. If an object has not been detected
                % in this frame, display its predicted bounding box.
                if ~isempty(reliableTracks)
                
                    r = reliableTracks;
                else  
                    r = [];
                end
            else
                r = [];
            end 
            
        end
        
        
        
        % This is the main function which calls all the 
        % Kalman filter helper methods and returns the detection tracks
        
        function r = track(this, frameNum, detections)
            
            [this.centroids, this.bboxes] = this.formatInputs(detections);
         
            this.predictNewLocationsOfTracks();
            
            [this.assignments, this.unassignedTracks, this.unassignedDetections] = this.detectionToTrackAssignment();

            this.updateAssignedTracks(frameNum);
            this.updateUnassignedTracks(frameNum);
            this.deleteLostTracks();
            this.createNewTracks(frameNum);
    
            r = this.getTracks();
        end
       
        
    end
end
