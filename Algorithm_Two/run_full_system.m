% This will be for running the entire system... This is what's up

% All the files for the videos... We actually only want the SRT ones,
%   so pare this down
filePaths = {
    '/home/geoffrey/Dropbox/Temps/Design_Project/testData/Feb_13_cam1_5.avi', ...
    '/home/geoffrey/Dropbox/Temps/Design_Project/testData/July_6_cam1_01.avi', ...
    '/home/geoffrey/Dropbox/Temps/Design_Project/testData/July_8_cam1_01.avi', ...
    '/home/geoffrey/Dropbox/Temps/Design_Project/testData/July_8_cam1_02.avi', ... 
    '/home/geoffrey/Dropbox/Temps/Design_Project/testData/July_8_cam1_03.avi', ...
    '/home/geoffrey/Dropbox/Temps/Design_Project/testData/July_8_cam1_04.avi', ...
    '/home/geoffrey/Dropbox/Temps/Design_Project/testData/July_8_cam1_08.avi', ... 
    '/home/geoffrey/Dropbox/Temps/Design_Project/testData/Oct_20_cam3_07.avi', ...
};

% Select one of the videos for testing
filePath = char(filePaths{4})

% Instantiate the video reader
v = VideoReader(filePath);
nFrames = v.NumberOfFrames;

% Read in the SRT data
% We don't really need to read it one at a time to simulate a real system.
% The real IMU information would probably be rather quick to read in.
% NOTE: We don't really need host for this script
[host, target] = getdetailedsrt(filePath, nFrames);

% DETECTION OBJECT
% I think we would want an array of arrays or a cell of arrays
% Inside each cell would be a bounding box with the probability that the
% plane is a valid object
%   x, y, xSize, ySize, probability, (TTC?)
% detections = [];

for i = 1:nFrames
    % Read in necessary data
    img = read(v, i);
    curHost = host(i,:)

    % So we will want to do a full screen detection sparingly as these are expensive.
    % It should definitely be done every X frames, but also if there are no planes detected.
    % This will focus mostly on getting the initial detections (those far
    % away from the plane)
%   if (mod(i, MODULO) || isEmpty(detections))
%       detections.add(full detection) 
%   end

    % If we do have previous detections, we will want to do a more in depth
    % analysis of these locations. This will probably be where we run our CNN
    % Will likely want to do this even if we have a full detection to check
%   detections.add(focusedDetection(detections))

    % Will want to overwrite the detections based on what the tracking returns. 
    % The tracking will update the probability of the detections based on
    % the motion of the plane. 
    % It is possible that we will return new detections though, might want
    % to structure this similar to tracking where every few frames there is
    % a more in depth tracking (not during in depth detection though)
%   detections = tracking(detections)

    % Time to collision estimation
    % Might be a part of tracking
%   detections = timeToCollision(detections)
end