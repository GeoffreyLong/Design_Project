%filePath = 'testData/Feb_13_cam1_5.avi';
%filePath = 'testData/July_6_cam1_01.avi';
%filePath = 'testData/July_8_cam1_01.avi';
%filePath = 'testData/July_8_cam1_02.avi';
filePath = 'testData/July_8_cam1_03.avi';
%filePath = 'testData/July_8_cam1_04.avi';
%filePath = 'testData/July_8_cam1_08.avi';
%filePath = 'testData/Oct_20_cam3_07.avi';

%TODO an even better way to do the sizing of the rectangles
%   Would be to do a sort of moving average
%   The rectangle size shouldn't change too much frame to frame
%   so a moving average should smooth out the size differences
%   This should ensure that the plane doesn't vary too much in size 
%   with respects to its boundaries

% Instantiate the video reader
v = VideoReader(filePath);

readRect = readrectxml(filePath, 'postProcess_');

% Specific to each file... instantiate a solid starting point
bound = [27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27];
j = 1;
for i=1:size(readRect,1)
    curRect = readRect(i,:);
    imageNumber = curRect(1);
    image = read(v,imageNumber);
    
    newRect = [0 0 0 0];
    
    curBound = curRect(5);
    bound = [bound(2:20) curBound];
    newBound = mean(bound);
    newRect(1) = ceil(curRect(2) + curBound / 2 - newBound / 2);
    newRect(2) = ceil(curRect(3) + curBound / 2 - newBound / 2);
    newRect(3) = ceil(newBound);
    newRect(4) = ceil(newBound);
    
    
    newImg = imcrop(image,newRect);
    imshow(newImg);
    %writeString = strcat('/home/geoffrey/Dropbox/Temps/Design_Project/testData/Generated_Detections/truth_images/July_8_cam1_03_', num2str(j), '.png');
    %imwrite(newImg, writeString)
    j = j + 1;
end