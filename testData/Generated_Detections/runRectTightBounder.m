%filePath = '../Feb_13_cam1_5.avi';
%filePath = '../July_6_cam1_01.avi';
%filePath = '../July_8_cam1_01.avi';
filePath = '../July_8_cam1_02.avi';
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

    while (numel(s) == 0 && thresh > 0)
        thresh = thresh - 1/256;
        bw = im2bw(im, thresh);
        L = bwlabel(bw, 4);
        s = regionprops(L,'BoundingBox', 'Centroid');
    end
    
    bound = [0 0 0 0];
    centroid = round(s(1).Centroid);
    bound = s(1).BoundingBox
    newImg = insertShape(newImg, 'Rectangle', bound, 'LineWidth', 1, 'color', 'blue');
    imshow(newImg);
    
    % Normalize the bounds to be from the initial image coords
    bound(1) = curRect(2) + bound(1);
    bound(2) = curRect(3) + bound(2);
    
    
    % y to save, anything else for not save, ctrl-c for quit
    CH = getkey;
    if CH == 121 % Corresponds to a 'y', will save the image
        newRect = [newRect; [imageNumber bound]];
    elseif CH == 3 % A ctrl-c command will exit the program
       break;
    end
end

addString = 'tightBound_';
%readRect = readrectxml(filePath,addString);
%writeRect = averagerects(newRect,readRect);
%writerectxml(filePath,writeRect,addString)