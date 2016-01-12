filePath = 'testData/Feb_13_cam1_5.avi';
%filePath = 'testData/July_6_cam1_01.avi';
%filePath = 'testData/July_8_cam1_01.avi';
%filePath = 'testData/July_8_cam1_02.avi';
%filePath = 'testData/July_8_cam1_03.avi';
%filePath = 'testData/July_8_cam1_04.avi';
%filePath = 'testData/July_8_cam1_08.avi';
%filePath = 'testData/Oct_20_cam3_07.avi';

% Instantiate the video reader
v = VideoReader(filePath);

readRect = readrectxml(filePath);
se = strel('disk',5);
newRect = [0 0 0 0 0];

for i=1:size(readRect,1)
    curRect = readRect(i,:);
    imageNumber = curRect(1);
    image = read(v,imageNumber);
    
    newImg = imcrop(image,curRect(2:5));
    open = imopen(newImg,se);
    close = imclose(newImg,se); 
    im = close - open;

    
    %newRect = ceil(getrect);
    
    bw = im2bw(im, graythresh(im));
    L = bwlabel(bw);
    s = regionprops(L,'BoundingBox', 'Centroid');
    %imshow(bw)
    rect = zeros(numel(s),5);

    bound = [0 0 0 0];
    largestObjSize = 0;
    for j=1:numel(s)
        centroid = round(s(j).Centroid);
        newBound = s(j).BoundingBox;
        upperDim = ceil(max(newBound(3),newBound(4)));
        
        if upperDim > largestObjSize
            bound(1) = centroid(1) - ceil(1.5*upperDim);
            bound(2) = centroid(2) - ceil(1.5*upperDim);
            bound(3) = 3*upperDim;
            bound(4) = 3*upperDim;
            largestObjSize = upperDim;
        end
    end

    % Normalize the bounds to be from the initial image coords
    bound(1) = curRect(2) + bound(1);
    bound(2) = curRect(3) + bound(2);
    newImg = imcrop(image,bound);
    imshow(newImg)

    CH = getkey;
    if CH == 121 % Corresponds to a 'y', will save the image
        if newRect
            newRect = [newRect; [imageNumber bound]];
        else
            newRect = [imageNumber bound];
        end
    elseif CH == 3 % A ctrl-c command will exit the program
       break;
    end
end

writerectxml(filePath,newRect,'postProcess_')

