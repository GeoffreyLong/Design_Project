% Instantiate the video reader
v = VideoReader('/Users/Xavier/Documents/workspace/Design_Project/Test_Data/July_6_cam1_01.avi');

% Get the number of frames, frame width, and frame height from the video data
nFrames = v.NumberOfFrames;

% Get SRT data

[host, target] = getdetailedsrt('/Users/Xavier/Documents/workspace/Design_Project/Test_Data/July_6_cam1_01.srt',nFrames);
rectFileName = '/Users/Xavier/Documents/workspace/Design_Project/Test_Data/Generated_Detections/Detections/Previous/tightBound_July_6_cam1_01.avi.dat';

% should use readrectxml.m file
try
    rect = csvread(rectFileName);
catch
    sprintf('No rect file found');
end

% first detection at frame
firstDetection = rect(1);
posTracker = [];
areaTracker = [];
rectIndx = 1;


%create kalman filter tracker
% param = [];
% param.motionModel           = 'ConstantAcceleration';
% param.initialLocation       = [0 0];
% param.initialEstimateError  = 1E5 * ones(1, 3);
% param.motionNoise           = [25, 10, 1];
% param.measurementNoise      = 25;
% param.segmentationThreshold = 0.05;

kalman = KalmanTracker;
tracker = Tracker;
realTracker = Tracker;
rectIndx = 1;
tempCount = 1;
allTracks = [];
for i = firstDetection:firstDetection+10%nFrames
    
%   host: All of the own-ship information
%       [Frame Number, Altitude (feet), Pitch (degrees), Roll (degrees), Heading]
%   target: All of the intruder information
%       [Frame Number, Azimuth (degrees), Elevation (degrees), Distance (feet)]
    
    
    img = read(v,i);
   
    
    if i >= firstDetection
        
        
        
        centroid = getMidPoint(rect(rectIndx,:));
        bbox = [rect(rectIndx,4) rect(rectIndx,5)];
        
        centroids = [centroid; [2000 2000] ];
        box1 = [rect(rectIndx,2) rect(rectIndx,3) rect(rectIndx,4) rect(rectIndx,5)];
        height = rect(rectIndx,5);
        box2 = [2000 200 50 60];
        bboxes = [box1;box2];
        tracks = kalman.track(box1);
        if isempty(tracks)
            x = [];
        else 
            x = tracks.bbox;
        end
        allTracks = [allTracks;x];
%         if ~isempty(tracks)
%             output = cat(1, tracks.bbox)
%         end
        dist = target(i,4);
        estDist = tracker.estimateDistance(height);
        realTTC = tracker.ttc(dist);
        estTTC = realTracker.ttc(estDist);
        
%         fprintf('tracks: %f\n', tracks);
%          if mod(tempCount,15) == 0
%          fprintf('distance: %f, estDist: %f, realTTC: %f, estTTC: %f\n', dist, estDist, realTTC, estTTC);
%              tempCount = 0;
%          end
        tempCount = tempCount + 1;
        
%         tracks = [[10 10 10 10];[20 20 10 10];[100 100 40 50]];
%          test1 = insertShape(img, 'Circle', [[centroid 3];[2000 2000 3] ], 'LineWidth', 3, 'Color', 'red');
%          test2 = insertShape(img, 'Rectangle', tracks , 'LineWidth', 5, 'Color', 'green');
%          imshow(test2);
%         movAvg = tracker.movingAvg(midPoint);
        rectIndx = rectIndx + 1;
%          fprintf('distance: %f, myDistance: %f\n', target(i,4)*0.3048, tracker.estimateDistance(height));

        % Get heading of host
%         hostHeading = host(i,5);
        % get heading estimate of target
%         azimuth = target(i,2);
%         myAz = radtodeg(-atan((v.width/2 - midPoint(1))/(v.height/2 - midPoint(2))));
%            myAz = (90/v.width)*(v.width/2 - midPoint(1));
%             targetHeading = tracker.direction(hostHeading);
%         fprintf('azimuth: %f, myAzimuth: %f\n', azimuth, myAz);
   
        
%         fprintf('detect: %f, track: %f\n', midPoint, track);
         
%           
%           RGB = insertText(test2,[200 1950; 800 1950;], {strcat('Host Heading: ', num2str(hostHeading)), strcat('Target Heading: ', num2str(realHeading))}, 'FontSize',50);
%           imshow(RGB);
%         [posTrack, areaTrack] = tracking(tempRect, host(i,:), target(i,:));
%         posTracker = [posTracker; posTrack];
%         areaTracker = [areaTracker; areaTrack];
        
        % Get heading of target
%         hostHeading = host(i,5);
        
        %estimate distance to target
        % look up pinhole cameras
%         calcRect = estimateDistance(target(i,:), host(i,:));
%         actDist = target(i,4);
%         actAlt = target(i,3);
%        
%         fprintf('Est. Distance: %f, Act. Distance = %f\n', calcRect(1), actDist);
%         fprintf('Est. Size: %f\n',calcRect(3));
    

        % GROUND TRUTH DATA END
    
%         fprintf('________________\n');
    

    %distance (m or pixels)
    %speed (pixels/s)
    % TTC 15 +2T time  before collision
    % at radius of 500feet = 152.4m
    %TTC = (distance-152.4)/(speed)
    % fps = 15;
        
    else
        tempRect = [0 0 0 0];   
        centerPoint = [0 0 0];             
    end
    
    
   
    
   
end