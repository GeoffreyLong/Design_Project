% Instantiate the video reader
v = VideoReader('/Users/Xavier/Documents/workspace/Design_Project/Algorithm_Two/cam1_01.avi');

% Get the number of frames, frame width, and frame height from the video data
nFrames = v.NumberOfFrames;

% Get SRT data

[host, target] = getdetailedsrt('/Users/Xavier/Documents/workspace/Design_Project/testData/July_6_cam1_01.srt',nFrames);
rectFileName = '/Users/Xavier/Documents/workspace/Design_Project/testData/Generated_Detections/July_6_cam1_01.avi.dat';

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

for i = firstDetection:firstDetection+1
    
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
        
%         [posTrack, areaTrack] = tracking(tempRect, host(i,:), target(i,:));
%         posTracker = [posTracker; posTrack];
%         areaTracker = [areaTracker; areaTrack];
        
        % Get heading of target
        hostHeading = host(i,5);
        
        %estimate distance to target
        calcRect = estimateDistance(target(i,:), host(i,:));
        actDist = target(i,4);
        actAlt = target(i,3);
       
        fprintf('Est. Distance: %f, Act. Distance = %f\n', calcRect(1), actDist);
        fprintf('Est. Size: %f\n',calcRect(3));


        % GROUND TRUTH DATA END
    
        fprintf('________________\n');
    
%         test1 = insertShape(img, 'Circle', [ midPoint, 3], 'LineWidth', 3, 'Color', 'red');
       % RGB = insertText(test1,[200 1950; 800 1950], {strcat('est. distance: ', distance), strcat('act. distance ',actDist )}, 'FontSize',50);
%         imshow(test1);
        
        
    else
        tempRect = [0 0 0 0];   
        centerPoint = [0 0 0];             
    end
    
    
   
    
   
end