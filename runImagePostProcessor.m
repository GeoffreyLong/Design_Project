videoPath = '/home/geoffrey/Dropbox/Temps/Design_Project/Feb_13_cam1_5.avi';

% Instantiate the video reader
v = VideoReader(videoPath);

readRect = readrectxml(videoPath);

for i=1:size(readRect,1)
    curRect = readRect(i,:);
    image = read(v,curRect(1));
    
    newImg = imcrop(image,curRect(2:5));
    imshow(newImg);
    newRect = ceil(getrect);
    
    smallSize = min(newRect(3), newRect(4));
    curRect(2) = curRect(2) + newRect(1);
    curRect(3) = curRect(3) + newRect(2);
    curRect(4) = smallSize;
    curRect(5) = smallSize;
    readRect(i,:) = curRect;
end

writerectxml(videoPath,readRect,'postProcess_')

