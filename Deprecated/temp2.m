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

for i=400:size(readRect,1)
    i
    curRect = readRect(i,:);
    imageNumber = curRect(1);
    image = read(v,imageNumber);
    
    newImg = imcrop(image,curRect(2:5));
    open = imopen(newImg,se);
    close = imclose(newImg,se); 
    im = close - open;
    im = imdilate(im,se);
    imshowpair(newImg, im, 'montage');
end