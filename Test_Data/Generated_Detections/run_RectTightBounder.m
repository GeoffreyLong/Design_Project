%filePath = '../Feb_13_cam1_5.avi';
filePath = 'Test_Data/July_6_cam1_01.avi';
%filePath = '../July_8_cam1_01.avi';
%filePath = '../July_8_cam1_02.avi';
%filePath = '../July_8_cam1_03.avi';
%filePath = '../July_8_cam1_04.avi';
%filePath = '../July_8_cam1_08.avi';
%filePath = '../Oct_20_cam3_07.avi';

%TODO an even better way to do the sizing of the rectangles
%   Would be to do a sort of moving average
%   The rectangle size shouldn't change too much frame to frame
%   so a moving average should smooth out the size differences
%   This should ensure that the plane doesn't vary too much in size 
%   with respects to its boundaries
%TODO make the rectangle resizing less aggressive. I want it to be rather
%   small, need tighter bounds than what I am giving.

% Instantiate the video reader
v = VideoReader(filePath);

readRect = readrectxml(filePath);

% Having a tight bound will actually get tighter detections
% Note that disk 7 is the se currently used in detection
se = strel('disk',1);
dilation = strel('disk',4);
newRect = [];

for i=1:size(readRect,1)
    i
    curRect = readRect(i,:);
    imageNumber = curRect(1);
    image = read(v,imageNumber);
    
    newImg = imcrop(image,curRect(2:5));
    open = imopen(newImg,se);
    close = imclose(newImg,se); 
    im = close - open;
    im = imdilate(im,dilation);

    thresh = 0.30;
    bw = im2bw(im, thresh);
    L = bwlabel(bw, 4);
    
    bounds = zeros(9,4);
    
    % There are a lot of cool regionprops that could be useful
    % Particularly userprops
    s = regionprops(L,'BoundingBox', 'Centroid');
    highThresh = 0;
    while (numel(s) == 0 && thresh > 0)
        thresh = thresh - 1/256;
        highThresh = thresh;
        bw = im2bw(im, thresh);
        L = bwlabel(bw, 4);
        s = regionprops(L,'BoundingBox', 'Centroid');
    end
    
    bounds(1,:) = s(1).BoundingBox;
    img = insertShape(newImg, 'Rectangle', s(1).BoundingBox, 'LineWidth', 1, 'color', 'blue');
    subplot(3,3,1), subimage(img);

    lowThresh = 0;
    while (numel(s) == 1 && thresh > 0)
        bw = im2bw(im, thresh);
        L = bwlabel(bw, 4);
        s = regionprops(L,'BoundingBox', 'Centroid');
        thresh = thresh - 1/256;
    end

    lowThresh = thresh + 1/256;
    bounds(9,:) = s(1).BoundingBox;
    img = insertShape(newImg, 'Rectangle', s(1).BoundingBox, 'LineWidth', 1, 'color', 'blue');
    subplot(3,3,9), subimage(img);
    
    threshBound = (highThresh - lowThresh) / 7;
    thresh = highThresh;
    for j=2:8
        thresh = thresh - threshBound;
        bw = im2bw(im, thresh);
        L = bwlabel(bw, 4);
        s = regionprops(L,'BoundingBox');
        if (numel(s) >= 1)
            bounds(j,:) = s(1).BoundingBox;
            img = insertShape(newImg, 'Rectangle', s(1).BoundingBox, 'LineWidth', 1, 'color', 'blue');
            subplot(3,3,j), subimage(img);        
        end    
    end

    
    % Choose the image to save, press '1' through '9' to choose
    % Press ctrl-c to exit
    % Any other key to continue
    CH = getkey
    if CH >= 49 && CH <= 57 % Corresponds to '1' through '9'
        % Get the index from the keystroke
        idx = CH - 48
        
        % Normalize the bounds to be from the initial image coords
        bounds(idx,1) = curRect(2) + bounds(idx,1);
        bounds(idx,2) = curRect(3) + bounds(idx,2);
        
        newRect = [newRect; [imageNumber bounds(idx,:)]];
    elseif CH == 3 % A ctrl-c command will exit the program
       break;
    end
end

newRect
addString = 'tightBound_';
readRect = readrectxml(filePath,addString);
writeRect = averagerects(newRect,readRect);
writerectxml(filePath,writeRect,addString)