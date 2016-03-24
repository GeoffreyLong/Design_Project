%filePath = '../Feb_13_cam1_5.avi';
filePath = 'testData/July_6_cam1_01.avi';
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
se = strel('disk',7);
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
    im = imdilate(im,se);

    thresh = 0.30;
    bw = im2bw(im, thresh);
    L = bwlabel(bw, 4);
    
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
    
    bound = [0 0 0 0];
    centroid = round(s(1).Centroid);
    newbound1 = s(1).BoundingBox
    newImg1 = insertShape(newImg, 'Rectangle', newbound1, 'LineWidth', 1, 'color', 'blue');
    subplot(1,3,1), subimage(newImg1);

    lowThresh = 0;
    while (numel(s) == 1 && thresh > 0)
        bw = im2bw(im, thresh);
        L = bwlabel(bw, 4);
        s = regionprops(L,'BoundingBox', 'Centroid');
        thresh = thresh - 1/256;
    end

    lowThresh = thresh + 1/256;
    bound = [0 0 0 0];
    centroid = round(s(1).Centroid);
    newbound2 = s(1).BoundingBox
    newImg2 = insertShape(newImg, 'Rectangle', newbound2, 'LineWidth', 1, 'color', 'blue');
    subplot(1,3,2), subimage(newImg2);
    
    midThresh = (highThresh + lowThresh) / 2;
    bw = im2bw(im, midThresh);
    L = bwlabel(bw, 4);
    s = regionprops(L,'BoundingBox', 'Centroid');
    if (numel(s) >=1)
        newbound3 = s(1).BoundingBox
        newImg3 = insertShape(newImg, 'Rectangle', newbound3, 'LineWidth', 1, 'color', 'blue');
        subplot(1,3,3), subimage(newImg3);        
    end
    
    

    
    % Choose the image to save, press '1', '2', or '3' to choose
    % Press ctrl-c to exit
    % Any other key to continue
    CH = getkey;
    if CH == 49 % Corresponds to a 'y', will save the image
        % Normalize the bounds to be from the initial image coords
        newbound1(1) = curRect(2) + newbound1(1);
        newbound1(2) = curRect(3) + newbound1(2);
        
        newRect = [newRect; [imageNumber newbound1]];
    elseif CH == 50 % Corresponds to a 'y', will save the image
        % Normalize the bounds to be from the initial image coords
        newbound2(1) = curRect(2) + newbound2(1);
        newbound2(2) = curRect(3) + newbound2(2);
        
        newRect = [newRect; [imageNumber newbound2]];
    elseif CH == 51 % Corresponds to a 'y', will save the image
        % Normalize the bounds to be from the initial image coords
        newbound3(1) = curRect(2) + newbound3(1);
        newbound3(2) = curRect(3) + newbound3(2);
        
        newRect = [newRect; [imageNumber newbound3]];
    elseif CH == 3 % A ctrl-c command will exit the program
       break;
    end
end

newRect
addString = 'tightBound_';
readRect = readrectxml(filePath,addString);
writeRect = averagerects(newRect,readRect);
writerectxml(filePath,writeRect,addString)