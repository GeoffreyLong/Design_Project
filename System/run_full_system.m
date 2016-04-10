% This will be for running the entire system... This is what's up

% All the files for the videos... We actually only want the SRT ones,
%   so pare this down
filePaths = {
    'Test_Data/Feb_13_cam1_5.avi', ...
    'Test_Data/July_6_cam1_01.avi', ...
    'Test_Data/July_8_cam1_01.avi', ...
    'Test_Data/July_8_cam1_02.avi', ... 
    'Test_Data/July_8_cam1_03.avi', ...
    'Test_Data/July_8_cam1_04.avi', ...
    'Test_Data/July_8_cam1_08.avi', ... 
    'Test_Data/Oct_20_cam3_07.avi', ...
};

% Select one of the videos for testing
filePath = char(filePaths{2})

% Instantiate the video reader
v = VideoReader(filePath);
nFrames = v.NumberOfFrames;
height = v.Height;
width = v.Width;

% Read in the SRT data
% We don't really need to read it one at a time to simulate a real system.
% The real IMU information would probably be rather quick to read in.
% NOTE: We don't really need host for this script
[host, target] = getdetailedsrt(filePath, nFrames);

% DETECTION OBJECTS
% There will be two objects, one for detection, the other for tracking
% Both of these will have the form of 
%   x, y, xSize, ySize, probability, (TTC?)
%   Perhaps TTC will be only in tracks?

% detections
%   This will be an array of unassigned detections
%   The detection stage will populate this array
% tracks
%   This will be a cell of arrays. Each array will contain a single track.
%   This will be populated by the tracking phase. The tracking will take
%   each of the detections to see if they belong in a given track. If they
%   do not, then a new track will be made.
% detections = [];
% tracks = {};

kalman = KalmanTracker;
tracker = Tracker;
tracks = [];

for i = 1800:nFrames
    % Read in necessary data
    origImg = read(v, i);
    curHost = host(i,:);

    % Grab the initial detections
    % Not running the modulus full screen yet
    detections = initial_detections(origImg, curHost, height, width)
    tracks = kalman.track(detections)
    realTTC = tracker.ttc(target(i,4));
    % So we will want to do a full screen detection sparingly as these are expensive.
    % It should definitely be done every X frames, but also if there are no planes detected.
    % This will focus mostly on getting the initial detections (those far
    % away from the plane)
%   if (mod(i, MODULO) || isEmpty(detections))
%       detections.add(full_detection(img, curHost));
%   end


    % If we do have previous detections, we will want to do a more in depth
    % analysis of these locations. This will take the most recent detection
    % of each track and check the area for the most recent detection.
    % Will likely want to do this even if we ran a full detection on this run
    % Perhaps we will only want to do this if a suitable next detection has
    % not been found for a given track? Therefore we might want to move it
    % down or into the tracking part
%   for each track cell in the track cell array
%       detections.add(focused_detections(rotatedImage, track[0]));
%   end

    % After we get all of our detections, we might want to do some in depth
    % screening on them. This will take the detections and put them through
    % the CNN to find the probability that they are indeed detections.
%   detections = screen_detection(detections)

    % Will want to overwrite the tracks object based on what the tracking returns. 
    % The tracking will update the probability of the detections based on
    % the motion of the plane. It will take the new detections and see if
    % they belong on any of the tracks.
    % TODO we need to decide if each of the detections gets a probability
    % or if the whole track gets a probability. If we give each detection a
    % probability then perhaps we would want to regressively update the
    % probabilities of previous detections in the track based on the new
    % detection and the track. Tracks that have a low probability should be
    % removed from the system.
    % It is possible that we will return new detections though, might want
    %   to structure this similar to tracking where every few frames there is
    %   a more in depth tracking (not during in depth detection though)
%   tracks = tracking(detections, tracks)

    % Time to collision estimation
    % Might be a part of tracking
%   detections = timeToCollision(detections)
end