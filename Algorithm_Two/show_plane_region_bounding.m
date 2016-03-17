% This shows how the plane region bounding works
% From this (since the sigma is really small) we might want to bound from
% the horizon estimation (usually lower than the true horizon) to 3*sigma.
% This should account for any issues that may arise from improper rotation

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
height = v.Height;

% Read in the SRT data
[host, target] = getdetailedsrt(filePath, nFrames);

% PDF_Y
mu = 68.0164;
sigma = 16.2477;

for i = 1:nFrames
    % Read in necessary data
    img = read(v, i);
    curHost = host(i,:);

    % Rotate the image
    img = imrotate(img, -curHost(3), 'crop');

    % Horizon estimation
    y = rotated_horizon_detection(curHost, 2050);
    
    % 3 sigma will get 99.7 percent of the detections
	midpoint = y - mu;
    upper = midpoint - 3*sigma;
    lower = midpoint + 3*sigma;
    
    hold off;
    imshow(img);
    hold on;
    line([0,2448],[y,y],'Color','red');
    
    line([0,2448],[midpoint,midpoint],'Color','green');
    line([0,2448],[upper,upper],'Color','blue');
    line([0,2448],[lower,lower],'Color','blue');
    
    % Visualize the cropping
%    img = imcrop(img, [0 upper 2448 abs(upper-y)]);
%    imshow(img)
end