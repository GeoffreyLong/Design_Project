%filePath = 'testData/Feb_13_cam1_5.avi';
%filePath = 'testData/July_6_cam1_01.avi';
filePath = 'testData/July_8_cam1_03.avi';
%filePath = 'testData/July_8_cam1_08.avi';
%filePath = 'testData/Oct_20_cam3_07.avi';

% Instantiate the video reader
v = VideoReader(filePath);

readRect = readrectxml(filePath);
saveRect = zeros(1,5);
rectIdx = 1;
for i=1:size(readRect,1)
    curRect = readRect(i,:);
    image = read(v,curRect(1));
    
    newImg = imcrop(image,curRect(2:5));
    imshow(newImg);
    newRect = ceil(getrect);
    
    % Ensure a rect was actually chosen
    % If no rectangle was chosen then a plane probably wasn't seen
    if (newRect(3)*newRect(4) > 20)
        curRect(2) = curRect(2) + newRect(1);
        curRect(3) = curRect(3) + newRect(2);
        curRect(4) = newRect(3);
        curRect(5) = newRect(4);
        
        %readRect(i,:) = curRect;
        saveRect(rectIdx, :) = curRect
    end
end

% Save the detections
writerectxml(filePath,newRect,'postProcess2_')

