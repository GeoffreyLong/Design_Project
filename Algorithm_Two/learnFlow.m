% Take in the roll / pitch / yaw using testData/getdetailedsrt.m
% Within local windows i.e. sized 24x24 or thereabouts
%   Calculate the expected flow based on these params
%       i.e. how the local features are supposed to change based on their 
%       position in the frame and the ego motion
%       This estimation would be based on the camera intrinsics 
%       See the file Algorithm_One/estimateplanelocation.m for help
%       At any rate the projections in this script probably need to be improved
%   Search for any deviations
% In a head on collision scenario there won't be any deviations, 
%   only growth of the plane, so this won't help to much in that
% It is possible that this will allow us to remove ego motion from the
%   motion of the features though, which will allow us to estimate the
%   trajectory of the plane
% It would be best if we could learn what a 
%   combination of window location and camera motion does to the local
%   image flow... i.e. learn what adjustments need to be made in each scenario
%   to account for the ego motion

% Instantiate the video reader
v = VideoReader('/Users/Xavier/Documents/workspace/Design_Project/Algorithm_Two/cam1_01.avi');

% Get the number of frames, frame width, and frame height from the video data
nFrames = v.NumberOfFrames;
    

% Get SRT data
% srt call should go in a sepertae file, should just pass in row of data
% related to frame of interest
srt = getdetailedsrt('/Users/Xavier/Documents/workspace/Design_Project/testData/July_6_cam1_01.srt',nFrames);
% get data from row of interest
% srtData = srt(1,:); % [Frame Number, Altitude (feet), Pitch (degrees), Roll (degrees), Heading]
% roll is rotation around the middle of the plane (twist)
% roll = srtData(4);
% pitch is rotation around center of gravity (flip)
% pitch = srtData(3);
% disp(srtData)
% disp(roll);
% disp(pitch);


% load one image to perform operation on
%image is 650x600 pixles (y vs x)
% curImage = read(v,1); 
% 
% % compensation equations
% 
% rollImage = imrotate(curImage, -roll, 'crop');
% C = imfuse(curImage,rollImage);
% imshow(C);
% rectangle = int32([10 10 30 30]); %[x y width height]
rectWidth = 24; %rectangle width well be ... pixels
rectHeight = 24; %rect height well be ... pixels
numRects = v.Width/rectWidth; %600/24=25

% Initiate search at top left corner of image
x_pixel = 0;
y_pixel = 0;
rectArray = [];

for i = 1800:nFrames
    
    % get data from row of interest
    srtData = srt(i,:); % [Frame Number, Altitude (feet), Pitch (degrees), Roll (degrees), Heading]
    % roll is rotation around the middle of the plane (twist)
    roll = srtData(4);
    % pitch is rotation around center of gravity (flip)
    pitch = srtData(3);
    yaw = 0;
    dcm = angle2dcm( yaw, pitch, roll );% returns 3x3 matrix
%     https://en.wikipedia.org/wiki/Rotation_formalisms_in_three_dimensions
   % dcm row 1
   %[cos(yaw)*cos(pitch), cos(roll)]
    % do we convolute?
    curImage = read(v,i); 
    % compensation equations
    if i~=1800
        compImage = imwarp(curImage,dcm);
        %rollImage = imrotate(curImage, -roll, 'crop');
        diffImage = imabsdiff(compImage,pastImage);
        
        % To do: translation motion
        
        imshow(diffImage);
        pastImage = curImage;
%     C = imfuse(curImage,rollImage);
       
    else
        rollImage = imrotate(curImage, -roll, 'crop');
        pastImage = curImage;
    end    
    
    
end
% for j = 1:numRects
%     
%     for k = 1:numRects
%         % for now just draw rectangle to simulate search area
%         rectArray = [rectArray; [x_pixel y_pixel rectWidth rectHeight] ];
%         rectangle = insertShape(curImage, 'Rectangle', rectArray, 'LineWidth', 5);
%         imshow(rectangle);
%         x_pixel = x_pixel + rectWidth;
%     end
%     y_pixel = y_pixel + rectHeight;
%     x_pixel = 0;
%    
%     
% end



%     curImage = im2double(curImage);
%     V = step(opticalFlow, curImage);

%new = V(:,:) >= 0.0100;
%imshow(new);

% function displayRect( videoPath, rect )

% Instantiate the video reader

% v = VideoReader(videoPath);
% nFrames = v.NumberOfFrames;
% 
% rectIdx = 1;
% maxRectIdx = size(rect,1);
% 
% mov(1:nFrames) = struct('cdata',zeros(v.Height,v.Width,3,'uint8'),'colormap',[]);


% for i = 1:nFrames
% %   insert the rectangle as the specified location on each frame
%     if (rectIdx <= maxRectIdx && rect(rectIdx,1) == i)
%         tmpIdx = 1;
% 
%         while (rectIdx <= maxRectIdx && rect(rectIdx,1) == i)
%             tmpRects(tmpIdx, :) = [rect(rectIdx,2) rect(rectIdx,3) rect(rectIdx,4) rect(rectIdx,5)];
%             rectIdx = rectIdx + 1;
%             tmpIdx = tmpIdx + 1;
%         end
%         mov(i).cdata= insertShape(read(v,i), 'Rectangle', tmpRects, 'LineWidth', 1);
%     else
% 
%         mov(i).cdata= insertShape(read(v,i), 'Rectangle', [0 0 0 0], 'LineWidth', 1);
%     end
% end

