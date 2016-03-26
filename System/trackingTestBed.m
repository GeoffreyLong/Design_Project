% Instantiate the video reader
v = VideoReader('/Users/Xavier/Documents/workspace/Design_Project/Algorithm_Two/cam1_01.avi');

% Get the number of frames, frame width, and frame height from the video data
nFrames = v.NumberOfFrames;

% Get SRT data

[host, target] = getdetailedsrt('/Users/Xavier/Documents/workspace/Design_Project/Test_Data/July_6_cam1_01.srt',nFrames);
rectFileName = '/Users/Xavier/Documents/workspace/Design_Project/Test_Data/Generated_Detections/Detections/Previous/July_6_cam1_01.avi.dat';

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
param = [];
param.motionModel           = 'ConstantAcceleration';
param.initialLocation       = [0 0];
param.initialEstimateError  = 1E5 * ones(1, 3);
param.motionNoise           = [25, 10, 1];
param.measurementNoise      = 25;
% param.segmentationThreshold = 0.05;

kalman = KalmanTracker(param);

for i = firstDetection:nFrames+30
    
%   host: All of the own-ship information
%       [Frame Number, Altitude (feet), Pitch (degrees), Roll (degrees), Heading]
%   target: All of the intruder information
%       [Frame Number, Azimuth (degrees), Elevation (degrees), Distance (feet)]
    
    
    img = read(v,i);
   
    
    if i >= firstDetection
        
        tempRect = [rect(rectIndx,2) rect(rectIndx,3) rect(rectIndx,4) rect(rectIndx,5)];
        rectIndx = rectIndx + 1;
      
%         fprintf('rectIndx = %f\n',rectIndx);
        x = tempRect(1)+0.5*tempRect(3);
        y = tempRect(2)+0.5*tempRect(4);
        
        % center point is the center of the bounding box on the detection         
        midPoint = [x y];
        track = kalman.track(midPoint);
%         fprintf('detect: %f, track: %f\n', midPoint, track);
         test1 = insertShape(img, 'Circle', [ midPoint, 3], 'LineWidth', 3, 'Color', 'red');
         test2 = insertShape(test1, 'Circle', [ track, 3], 'LineWidth', 3, 'Color', 'green');
           %RGB = insertText(img,[200 1950; 800 1950; 1500 1950], {'Host Speed', 'Target Speed', 'Estimated Speed'}, 'FontSize',50);
         imshow(test2);
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
    
%         test1 = insertShape(img, 'Circle', [ midPoint, 3], 'LineWidth', 3, 'Color', 'red');
       % RGB = insertText(test1,[200 1950; 800 1950], {strcat('est. distance: ', distance), strcat('act. distance ',actDist )}, 'FontSize',50);
%         imshow(test1);
        
        
    else
        tempRect = [0 0 0 0];   
        centerPoint = [0 0 0];             
    end
    
    
   
    
   
end