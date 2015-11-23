addpath(genpath('./resources'));
% Instantiate the video reader
v = VideoReader('/home/geoffrey/Dropbox/Temps/Design_Project/Feb_13_cam1_5.avi');

% Get the number of frames, frame width, and frame height from the video data
nFrames = v.NumberOfFrames;
    
opticalFlow = vision.OpticalFlow;

for i = 1:nFrames 
    curImage = read(v,i); 
    curImage = im2double(curImage);
    V = step(opticalFlow, curImage);
    
    %new = V(:,:) >= 0.0100;
    %imshow(new);
    
    imshow(V);
end

