% Instantiate the video reader
v = VideoReader('/Users/Xavier/Documents/workspace/Design_Project/Algorithm_Two/cam1_01.avi');

% Get the number of frames, frame width, and frame height from the video data
nFrames = v.NumberOfFrames;

% Get SRT data

[host, target] = getdetailedsrt('/Users/Xavier/Documents/workspace/Design_Project/testData/July_6_cam1_01.srt',nFrames);


for i=1:nFrames
    
%   host: All of the own-ship information
%       [Frame Number, Altitude (feet), Pitch (degrees), Roll (degrees), Heading]
%   target: All of the intruder information
%       [Frame Number, Azimuth (degrees), Elevation (degrees), Distance (feet)]
    
    
    img = read(v,i);
    RGB = insertText(img,[200 1950; 800 1950; 1500 1950], {'Host Speed', 'Target Speed', 'Estimated Speed'}, 'FontSize',50);
    imshow(RGB);
   
end