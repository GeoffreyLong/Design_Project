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

for i = firstDetection:nFrames
    
%   host: All of the own-ship information
%       [Frame Number, Altitude (feet), Pitch (degrees), Roll (degrees), Heading]
%   target: All of the intruder information
%       [Frame Number, Azimuth (degrees), Elevation (degrees), Distance (feet)]
    
    
    img = read(v,i);
   
    
    if i >= firstDetection
        rectIndx = 1;
        tempRect = [rect(rectIndx,2) rect(rectIndx,3) rect(rectIndx,4) rect(rectIndx,5)];
        rectIndx = rectIndx + 1;
        
        x = tempRect(1)+0.5*tempRect(3);
        y = tempRect(2)+0.5*tempRect(4);
        
        % center point is the center of the bounding box on the detection         
        centerPoint = [x y 3];
        
%   %       next need to pass in detection, srt data of the frame to
%   tracking file
    else
        tempRect = [0 0 0 0];   
        centerPoint = [0 0 0];
    end
    tracking(tempRect, host(i,:), target(i,:));
    
    testImage = insertShape(img, 'Rectangle', tempRect, 'LineWidth', 2);
    test2 = insertShape(testImage, 'Circle', centerPoint, 'LineWidth', 3);
%     RGB = insertText(img,[200 1950; 800 1950; 1500 1950], {'Host Speed', 'Target Speed', 'Estimated Speed'}, 'FontSize',50);
    imshow(test2);
   
end